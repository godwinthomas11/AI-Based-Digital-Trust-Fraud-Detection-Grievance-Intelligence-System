package digitaltrust;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/FraudServlet")
public class fraudServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message = TextUtil.clean(request.getParameter("message"));
        if (message.isEmpty()) {
            ServletPages.message(response, HttpServletResponse.SC_BAD_REQUEST,
                "Fraud check failed", "Enter a message to analyze.", "index.jsp", "Back");
            return;
        }

        FraudResult result = FraudAnalyzer.analyze(message);
        saveAnalysis(message, result);

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<!doctype html><html lang=\"en\"><head><meta charset=\"UTF-8\">");
        out.println("<title>Fraud Detection Result</title></head><body>");
        out.println("<h1>Fraud Detection Result</h1>");
        out.println("<h2>Trust Score: " + result.getTrustScore() + "%</h2>");
        out.println("<h2>Status: " + TextUtil.escapeHtml(result.getLabel()) + "</h2>");

        if (!result.isSafe()) {
            out.println("<form action=\"GrievanceServlet\" method=\"post\">");
            out.println("<input type=\"hidden\" name=\"message\" value=\""
                + TextUtil.escapeHtml(TextUtil.truncate(message, 500)) + "\">");
            out.println("<button type=\"submit\">Report Grievance</button>");
            out.println("</form>");
        }

        out.println("<br><a href=\"index.jsp\">Back</a>");
        out.println("</body></html>");
    }

    private void saveAnalysis(String message, FraudResult result) {
        try {
            Db.loadDriver();
            try (Connection con = Db.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO analysis(message, score, label) VALUES (?,?,?)")) {

                ps.setString(1, TextUtil.truncate(message, 255));
                ps.setInt(2, result.getTrustScore());
                ps.setString(3, result.getLabel());
                ps.executeUpdate();
            }
        } catch (Exception e) {
            log("Could not save fraud analysis", e);
        }
    }
}
