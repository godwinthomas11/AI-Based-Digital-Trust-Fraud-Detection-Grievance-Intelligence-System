package digitaltrust;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/FraudServlet")
public class fraudServlet extends HttpServlet {

    private int calculateScore(String msg) {

        msg = msg.toLowerCase().replaceAll("[^a-zA-Z0-9 ]", "");

        int score = 0;

        if (msg.contains("lottery")) score += 20;
        if (msg.contains("free")) score += 15;
        if (msg.contains("click")) score += 15;
        if (msg.contains("verify")) score += 15;
        if (msg.contains("bank")) score += 15;

        if (msg.contains("won") && msg.contains("rs")) score += 25;
        if (msg.contains("urgent") && msg.contains("verify")) score += 20;
        if (msg.contains("pay") && msg.contains("fee")) score += 25;

        if (msg.contains("http") || msg.contains("www")) {
            if (msg.contains(".gov.in")) score -= 30;
            else score += 30;
        }

        if (score < 0) score = 0;
        if (score > 100) score = 100;

        return score;
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("text/html");

        String msg = req.getParameter("message");
        int score = calculateScore(msg);

        String status;
        if (score >= 70) status = "FRAUD";
        else if (score >= 40) status = "SUSPICIOUS";
        else status = "SAFE";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/digital_trust", "root", "root");

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO analysis(message,score,label) VALUES (?,?,?)");

            ps.setString(1, msg);
            ps.setInt(2, score);
            ps.setString(3, status);
            ps.executeUpdate();

        } catch (Exception e) {}

        PrintWriter out = res.getWriter();

        out.println("<h1>Fraud Detection Result</h1>");
        out.println("<h2>Score: " + score + "%</h2>");
        out.println("<h2>Status: " + status + "</h2>");

        if (status.equals("FRAUD")) {
            out.println("<form action='GrievanceServlet' method='post'>");
            out.println("<input type='hidden' name='message' value='" + msg + "'>");
            out.println("<button type='submit'>Report Grievance</button>");
            out.println("</form>");
        }

        out.println("<br><a href='index.jsp'>Back</a>");
    }
}