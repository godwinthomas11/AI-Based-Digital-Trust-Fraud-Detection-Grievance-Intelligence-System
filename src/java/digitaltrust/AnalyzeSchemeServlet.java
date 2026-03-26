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

    private int calculateScore(String msg) {
        int score = 100;
        if (msg == null || msg.trim().isEmpty()) return 0;
        
        String cleanMsg = msg.toLowerCase().replaceAll("[^a-zA-Z0-9 ]", "");
        String rawLower = msg.toLowerCase();
        
        if (cleanMsg.contains("lottery")) score -= 25;
        if (cleanMsg.contains("free")) score -= 15;
        if (cleanMsg.contains("click")) score -= 15;
        if (cleanMsg.contains("verify")) score -= 10;
        if (cleanMsg.contains("bank")) score -= 10;
        if (cleanMsg.contains("won")) score -= 20;
        if (cleanMsg.contains("rs")) score -= 5;
        if (cleanMsg.contains("urgent")) score -= 15;
        if (cleanMsg.contains("pay")) score -= 15;
        if (cleanMsg.contains("fee")) score -= 10;
        
        if (rawLower.contains(".gov.in")) score += 30;
        
        if (score < 0) score = 0;
        if (score > 100) score = 100;
        
        return score;
    }

    private String extractTextFromTxt(Part filePart) {
        StringBuilder textBuilder = new StringBuilder();
        try (InputStream input = filePart.getInputStream();
             BufferedReader reader = new BufferedReader(new InputStreamReader(input, StandardCharsets.UTF_8))) {
            
            String line;
            while ((line = reader.readLine()) != null) {
                textBuilder.append(line).append(" ");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return textBuilder.toString();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String message = request.getParameter("message");
        String url = request.getParameter("url");
        Part textPart = request.getPart("text_file");
        
        String textToAnalyze = "";
        
        if (textPart != null && textPart.getSize() > 0) {
            textToAnalyze = extractTextFromTxt(textPart);
        } else if (message != null && !message.trim().isEmpty()) {
            textToAnalyze = message;
        } else if (url != null && !url.trim().isEmpty()) {
            textToAnalyze = url;
        }

        int trustScore = calculateScore(textToAnalyze);
        String label = (trustScore >= 75) ? "SAFE" : "FRAUD";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/digital_trust", "root", "root");
            PreparedStatement ps = con.prepareStatement("INSERT INTO analysis(message, score, label) VALUES (?,?,?)");
            String dbText = textToAnalyze.length() > 255 ? textToAnalyze.substring(0, 255) : textToAnalyze;
            ps.setString(1, dbText);
            ps.setInt(2, trustScore);
            ps.setString(3, label);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        HttpSession session = request.getSession();
        String profileMatch = "No";
        if (label.equals("SAFE")) {
            Double userIncome = (Double) session.getAttribute("user_income");
            if (userIncome != null && userIncome <= 800000) { 
                profileMatch = "Yes";
            }
        }

        request.setAttribute("trustScore", String.valueOf(trustScore));
        request.setAttribute("isGenuine", label);
        request.setAttribute("profileMatch", profileMatch);
        
        request.getRequestDispatcher("check_scheme.jsp").forward(request, response);
    }
}