package digitaltrust;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/GrievanceServlet")
public class GrievanceServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("text/html");

        String msg = req.getParameter("message");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/digital_trust", "root", "root");

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO grievances(message,status) VALUES (?,?)");

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