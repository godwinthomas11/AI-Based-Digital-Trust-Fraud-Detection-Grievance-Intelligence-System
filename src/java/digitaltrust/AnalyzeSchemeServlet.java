package digitaltrust;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
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

    // ── Railway MySQL credentials ──────────────────────────────────
    private static final String DB_URL  = "jdbc:mysql://mysql.railway.internal:3306/railway";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "FQmnmekFaZJ1OckDWxOGmFudvuPKNURx";
    // ──────────────────────────────────────────────────────────────

    private int calculateScore(String msg) {
        if (msg == null || msg.trim().isEmpty()) return 0;

        String rawLower = msg.toLowerCase();
        String cleanMsg = rawLower.replaceAll("[^a-z0-9 ]", " ");

        int score = 100;

        // --- HIGH SEVERITY fraud keywords ---
        if (cleanMsg.contains("lottery"))           score -= 25;
        if (cleanMsg.contains("won"))               score -= 25;
        if (cleanMsg.contains("winner"))            score -= 25;
        if (cleanMsg.contains("prize"))             score -= 25;
        if (cleanMsg.contains("jackpot"))           score -= 25;
        if (cleanMsg.contains("congratulations"))   score -= 20;
        if (cleanMsg.contains("selected"))          score -= 15;
        if (cleanMsg.contains("lucky"))             score -= 15;

        // --- MEDIUM SEVERITY fraud keywords ---
        if (cleanMsg.contains("free money"))        score -= 20;
        if (cleanMsg.contains("free cash"))         score -= 20;
        if (cleanMsg.contains("free reward"))       score -= 20;
        if (cleanMsg.contains("claim now"))         score -= 20;
        if (cleanMsg.contains("claim your"))        score -= 20;
        if (cleanMsg.contains("act now"))           score -= 20;
        if (cleanMsg.contains("limited time"))      score -= 20;
        if (cleanMsg.contains("expire"))            score -= 15;
        if (cleanMsg.contains("urgent"))            score -= 20;
        if (cleanMsg.contains("immediately"))       score -= 15;
        if (cleanMsg.contains("otp"))               score -= 20;
        if (cleanMsg.contains("account blocked"))   score -= 25;
        if (cleanMsg.contains("suspended"))         score -= 20;
        if (cleanMsg.contains("free"))              score -= 15;

        // --- FINANCIAL red flags ---
        if (cleanMsg.contains("pay"))               score -= 15;
        if (cleanMsg.contains("fee"))               score -= 15;
        if (cleanMsg.contains("processing fee"))    score -= 25;
        if (cleanMsg.contains("registration fee"))  score -= 25;
        if (cleanMsg.contains("advance"))           score -= 15;
        if (cleanMsg.contains("deposit"))           score -= 15;
        if (cleanMsg.contains("transfer"))          score -= 10;
        if (cleanMsg.contains("wallet"))            score -= 10;
        if (cleanMsg.contains("upi"))               score -= 10;
        if (cleanMsg.contains("paytm"))             score -= 10;

        // --- PHISHING / DATA theft red flags ---
        if (cleanMsg.contains("verify"))            score -= 15;
        if (cleanMsg.contains("click"))             score -= 15;
        if (cleanMsg.contains("click here"))        score -= 20;
        if (cleanMsg.contains("open link"))         score -= 20;
        if (cleanMsg.contains("bank"))              score -= 10;
        if (cleanMsg.contains("account number"))    score -= 20;
        if (cleanMsg.contains("password"))          score -= 20;
        if (cleanMsg.contains("cvv"))               score -= 25;
        if (cleanMsg.contains("pin"))               score -= 15;
        if (cleanMsg.contains("aadhaar"))           score -= 15;
        if (cleanMsg.contains("pan card"))          score -= 15;

        // --- Amount mentions with Rs / ₹ ---
        if (rawLower.matches(".*[₹rs\\.\\s]\\s*[0-9,]+.*")) score -= 15;

        // --- URL ANALYSIS ---
        boolean hasUrl = rawLower.contains("http")
                      || rawLower.contains("www")
                      || rawLower.contains(".com")
                      || rawLower.contains(".net")
                      || rawLower.contains(".org")
                      || rawLower.contains(".in");

        if (hasUrl) {
            if (rawLower.contains(".gov.in")) {
                score += 40;
            } else if (rawLower.contains(".nic.in")) {
                score += 35;
            } else if (rawLower.contains(".edu.in") || rawLower.contains(".ac.in")) {
                score += 10;
            } else {
                score -= 40;
                if (rawLower.contains("freemoney") || rawLower.contains("free-money")) score -= 20;
                if (rawLower.contains("prize")      || rawLower.contains("win"))        score -= 20;
                if (rawLower.contains("lottery"))                                        score -= 20;
                if (rawLower.contains("claim"))                                          score -= 15;
                if (rawLower.contains("reward"))                                         score -= 15;
                if (rawLower.contains("lucky"))                                          score -= 15;
                if (rawLower.contains("gift"))                                           score -= 15;
                if (rawLower.contains("cash"))                                           score -= 15;
                if (rawLower.contains("money"))                                          score -= 15;
                if (rawLower.contains("bit.ly") || rawLower.contains("tinyurl")
                 || rawLower.contains("t.co")   || rawLower.contains("goo.gl"))         score -= 20;
            }
        }

        // --- COMBINATION PENALTIES ---
        int fraudKeywordCount = 0;
        if (cleanMsg.contains("free"))    fraudKeywordCount++;
        if (cleanMsg.contains("won"))     fraudKeywordCount++;
        if (cleanMsg.contains("lottery")) fraudKeywordCount++;
        if (cleanMsg.contains("prize"))   fraudKeywordCount++;
        if (cleanMsg.contains("urgent"))  fraudKeywordCount++;
        if (cleanMsg.contains("click"))   fraudKeywordCount++;
        if (cleanMsg.contains("verify"))  fraudKeywordCount++;
        if (cleanMsg.contains("pay"))     fraudKeywordCount++;
        if (cleanMsg.contains("fee"))     fraudKeywordCount++;
        if (cleanMsg.contains("claim"))   fraudKeywordCount++;

        if (fraudKeywordCount >= 3) score -= 20;
        if (fraudKeywordCount >= 5) score -= 20;

        if (score < 0)   score = 0;
        if (score > 100) score = 100;

        return score;
    }

    private String extractTextFromTxt(Part filePart) {
        StringBuilder textBuilder = new StringBuilder();
        try (InputStream input = filePart.getInputStream();
             BufferedReader reader = new BufferedReader(
                     new InputStreamReader(input, StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                textBuilder.append(line).append(" ");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return textBuilder.toString();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message  = request.getParameter("message");
        String url      = request.getParameter("url");
        Part   textPart = request.getPart("text_file");

        String textToAnalyze = "";

        if (textPart != null && textPart.getSize() > 0) {
            textToAnalyze = extractTextFromTxt(textPart);
        } else if (message != null && !message.trim().isEmpty()) {
            textToAnalyze = message;
        } else if (url != null && !url.trim().isEmpty()) {
            textToAnalyze = url;
        }

        int    trustScore = calculateScore(textToAnalyze);
        String label      = (trustScore >= 60) ? "SAFE" : "FRAUD";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO analysis(message, score, label) VALUES (?,?,?)");
            String dbText = textToAnalyze.length() > 255
                          ? textToAnalyze.substring(0, 255)
                          : textToAnalyze;
            ps.setString(1, dbText);
            ps.setInt(2, trustScore);
            ps.setString(3, label);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        HttpSession session      = request.getSession();
        String      profileMatch = "No";
        if (label.equals("SAFE")) {
            Double userIncome = (Double) session.getAttribute("user_income");
            if (userIncome != null && userIncome <= 800000) {
                profileMatch = "Yes";
            }
        }

        request.setAttribute("trustScore",   String.valueOf(trustScore));
        request.setAttribute("isGenuine",    label);
        request.setAttribute("profileMatch", profileMatch);

        request.getRequestDispatcher("check_scheme.jsp").forward(request, response);
    }
}