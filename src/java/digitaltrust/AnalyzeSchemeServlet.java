package digitaltrust;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collections;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/AnalyzeSchemeServlet")
@MultipartConfig(maxFileSize = 16777215)
public class AnalyzeSchemeServlet extends HttpServlet {

    private static final int MAX_ANALYSIS_LENGTH = 10000;
    private static final int MAX_DB_MESSAGE_LENGTH = 255;

    private Map<String, Integer> blockedDomains = Collections.emptyMap();

    @Override
    public void init() throws ServletException {
        super.init();
        this.blockedDomains = loadBlockedDomains();
        log("Loaded " + blockedDomains.size() + " blocked domains from config");
    }

    private Map<String, Integer> loadBlockedDomains() {
        Map<String, Integer> map = new HashMap<>();
        try (InputStream in = getServletContext()
                .getResourceAsStream("/WEB-INF/blocked_domains.properties")) {
            if (in == null) {
                return map;
            }
            Properties props = new Properties();
            props.load(in);
            for (String key : props.stringPropertyNames()) {
                String host = key.trim().toLowerCase(Locale.ROOT);
                if (host.startsWith("www.")) {
                    host = host.substring(4);
                }
                try {
                    int penalty = Integer.parseInt(props.getProperty(key).trim());
                    map.put(host, penalty);
                } catch (NumberFormatException ignored) {
                }
            }
        } catch (IOException e) {
            log("Failed to read blocked_domains.properties", e);
        }
        return map;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String textToAnalyze = readSubmittedText(request);
        if (TextUtil.isBlank(textToAnalyze)) {
            ServletPages.message(response, HttpServletResponse.SC_BAD_REQUEST,
                "Analysis failed", "Submit a message, URL, or .txt file before analyzing.",
                "check_scheme.jsp", "Back to Analysis");
            return;
        }

        textToAnalyze = TextUtil.truncate(textToAnalyze, MAX_ANALYSIS_LENGTH);
        FraudResult result = FraudAnalyzer.analyze(textToAnalyze, blockedDomains);

        String dbMessage = TextUtil.truncate(textToAnalyze, MAX_DB_MESSAGE_LENGTH);
        Integer previousScore = lookupPreviousScore(dbMessage);

        saveAnalysis(dbMessage, result);

        int displayScore = result.getTrustScore();
        if (previousScore != null && result.getBlockedDomain() != null) {
            displayScore = clamp(previousScore - result.getBlockedPenalty(), 0, 100);
        }

        request.setAttribute("trustScore", String.valueOf(displayScore));
        request.setAttribute("isGenuine", result.getLabel());
        request.setAttribute("profileMatch", profileMatches(session, result) ? "Yes" : "No");
        if (previousScore != null) {
            request.setAttribute("previousScore", String.valueOf(previousScore));
        }
        if (result.getBlockedDomain() != null) {
            request.setAttribute("blockedDomain", result.getBlockedDomain());
            request.setAttribute("blockedPenalty", String.valueOf(result.getBlockedPenalty()));
        }

        request.getRequestDispatcher("check_scheme.jsp").forward(request, response);
    }

    private Integer lookupPreviousScore(String dbMessage) {
        try {
            Db.loadDriver();
            try (Connection con = Db.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                     "SELECT score FROM analysis WHERE message = ? ORDER BY id DESC LIMIT 1")) {
                ps.setString(1, dbMessage);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("score");
                    }
                }
            }
        } catch (Exception e) {
            log("Could not look up previous analysis", e);
        }
        return null;
    }

    private static int clamp(int value, int min, int max) {
        if (value < min) return min;
        if (value > max) return max;
        return value;
    }

    private String readSubmittedText(HttpServletRequest request) throws IOException, ServletException {
        Part textPart = request.getPart("text_file");
        if (textPart != null && textPart.getSize() > 0) {
            return extractTextFromTxt(textPart);
        }

        String message = TextUtil.clean(request.getParameter("message"));
        if (!message.isEmpty()) {
            return message;
        }

        return TextUtil.clean(request.getParameter("url"));
    }

    private String extractTextFromTxt(Part filePart) throws IOException {
        String fileName = getSubmittedFileName(filePart).toLowerCase();
        if (!fileName.endsWith(".txt")) {
            return "";
        }

        StringBuilder textBuilder = new StringBuilder();
        try (InputStream input = filePart.getInputStream();
             BufferedReader reader = new BufferedReader(
                 new InputStreamReader(input, StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null && textBuilder.length() < MAX_ANALYSIS_LENGTH) {
                textBuilder.append(line).append(' ');
            }
        }
        return textBuilder.toString();
    }

    private String getSubmittedFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) {
            return "";
        }
        for (String token : header.split(";")) {
            String trimmed = token.trim();
            if (trimmed.startsWith("filename=")) {
                return trimmed.substring(trimmed.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "";
    }

    private void saveAnalysis(String dbMessage, FraudResult result) {
        try {
            Db.loadDriver();
            try (Connection con = Db.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO analysis(message, score, label) VALUES (?,?,?)")) {

                ps.setString(1, dbMessage);
                ps.setInt(2, result.getTrustScore());
                ps.setString(3, result.getLabel());
                ps.executeUpdate();
            }
        } catch (Exception e) {
            log("Could not save analysis result", e);
        }
    }

    private boolean profileMatches(HttpSession session, FraudResult result) {
        if (!result.isSafe()) {
            return false;
        }

        Object incomeValue = session.getAttribute("user_income");
        Object ageValue = session.getAttribute("user_age");
        double income = incomeValue instanceof Number ? ((Number) incomeValue).doubleValue() : Double.MAX_VALUE;
        int age = ageValue instanceof Number ? ((Number) ageValue).intValue() : 0;

        return income <= 800000 && age >= 18;
    }
}
