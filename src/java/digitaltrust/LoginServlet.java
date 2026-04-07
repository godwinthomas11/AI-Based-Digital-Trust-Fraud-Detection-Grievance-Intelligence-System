package digitaltrust;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    // ── Railway MySQL credentials ──────────────────────────────────
    private static final String DB_URL  = "jdbc:mysql://mysql.railway.internal:3306/railway";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "FQmnmekFaZJ1OckDWxOGmFudvuPKNURx";
    // ──────────────────────────────────────────────────────────────

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE email=? AND password=?");
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = req.getSession();
                session.setAttribute("user",               rs.getString("name"));
                session.setAttribute("user_income",        rs.getDouble("income"));
                session.setAttribute("user_age",           rs.getInt("age"));
                session.setAttribute("user_marital_status", rs.getString("marital_status"));

                res.sendRedirect("index.jsp");
            } else {
                res.setContentType("text/html");
                PrintWriter out = res.getWriter();
                out.println("<h3>Invalid Login</h3>");
                out.println("<br><a href='login.jsp'>Back to Login Page</a>");
            }

        } catch (Exception e) {
            res.setContentType("text/html");
            PrintWriter out = res.getWriter();
            out.println("<h3 style='color:red;'>Database Error Occurred!</h3>");
            out.println("<p><b>Error Details:</b> " + e.getMessage() + "</p>");
            out.println("<br><a href='login.jsp'>Back to Login Page</a>");
            e.printStackTrace();
        }
    }
}