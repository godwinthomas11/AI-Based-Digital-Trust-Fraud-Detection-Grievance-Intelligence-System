package digitaltrust;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = TextUtil.clean(request.getParameter("email")).toLowerCase();
        String password = request.getParameter("password");

        if (TextUtil.isBlank(email) || TextUtil.isBlank(password)) {
            ServletPages.message(response, HttpServletResponse.SC_BAD_REQUEST,
                "Login failed", "Email and password are required.", "login.jsp", "Back to Login");
            return;
        }

        try {
            Db.loadDriver();
            try (Connection con = Db.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                     "SELECT id, name, email, password, income, age, marital_status "
                         + "FROM users WHERE LOWER(email) = ? LIMIT 1")) {

                ps.setString(1, email);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next() || !PasswordUtil.verify(password, rs.getString("password"))) {
                        ServletPages.message(response, HttpServletResponse.SC_UNAUTHORIZED,
                            "Invalid login", "The email or password is incorrect.", "login.jsp", "Back to Login");
                        return;
                    }

                    String storedPassword = rs.getString("password");
                    if (!PasswordUtil.isHash(storedPassword)) {
                        upgradePassword(con, rs.getInt("id"), password);
                    }

                    HttpSession oldSession = request.getSession(false);
                    if (oldSession != null) {
                        oldSession.invalidate();
                    }

                    HttpSession session = request.getSession(true);
                    session.setMaxInactiveInterval(30 * 60);
                    session.setAttribute("user_id", rs.getInt("id"));
                    session.setAttribute("user", rs.getString("name"));
                    session.setAttribute("user_email", rs.getString("email"));
                    session.setAttribute("user_income", rs.getDouble("income"));
                    session.setAttribute("user_age", rs.getInt("age"));
                    session.setAttribute("user_marital_status", rs.getString("marital_status"));

                    response.sendRedirect("index.jsp");
                }
            }
        } catch (Exception e) {
            log("Login failed", e);
            ServletPages.message(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Login unavailable", "Please try again later.", "login.jsp", "Back to Login");
        }
    }

    private void upgradePassword(Connection con, int userId, String plainPassword) {
        try (PreparedStatement ps = con.prepareStatement("UPDATE users SET password = ? WHERE id = ?")) {
            ps.setString(1, PasswordUtil.hash(plainPassword));
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            log("Password upgrade failed for user id " + userId, e);
        }
    }
}
