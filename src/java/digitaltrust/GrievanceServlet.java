package digitaltrust;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/GrievanceServlet")
public class GrievanceServlet extends HttpServlet {

    // ── Railway MySQL credentials ──────────────────────────────────
    private static final String DB_URL  =  "jdbc:mysql://maglev.proxy.rlwy.net:11997/railway?useSSL=true&requireSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "FQmnmekFaZJ1OckDWxOGmFudvuPKNURx";
    // ──────────────────────────────────────────────────────────────

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("text/html");

        String msg = req.getParameter("message");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO grievances(message, status) VALUES (?,?)");
            ps.setString(1, msg);
            ps.setString(2, "Pending");
            ps.executeUpdate();

            res.getWriter().println("<h2>Grievance Submitted Successfully</h2>");

        } catch (Exception e) {
            res.getWriter().println(e);
        }

        res.getWriter().println("<br><a href='index.jsp'>Back</a>");
    }
}