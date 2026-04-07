package digitaltrust;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    // ── Railway MySQL credentials ──────────────────────────────────
    private static final String DB_URL  =  "jdbc:mysql://maglev.proxy.rlwy.net:11997/railway?useSSL=true&requireSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "railway";
    private static final String DB_PASS = "FQmnmekFaZJ1OckDWxOGmFudvuPKNURx";
    // ──────────────────────────────────────────────────────────────

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name          = request.getParameter("name");
        String email         = request.getParameter("email");
        String password      = request.getParameter("password");
        int    age           = Integer.parseInt(request.getParameter("age"));
        String address       = request.getParameter("address");
        String bloodGroup    = request.getParameter("blood_group");
        String maritalStatus = request.getParameter("marital_status");
        double income        = Double.parseDouble(request.getParameter("income"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "INSERT INTO users(name, email, password, age, address, blood_group, marital_status, income) "
                       + "VALUES (?,?,?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setInt(4, age);
            ps.setString(5, address);
            ps.setString(6, bloodGroup);
            ps.setString(7, maritalStatus);
            ps.setDouble(8, income);

            ps.executeUpdate();
            response.sendRedirect("login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<h3>Error in Registration: " + e.getMessage() + "</h3>");
            out.println("<a href='register.jsp'>Back</a>");
        }
    }
}