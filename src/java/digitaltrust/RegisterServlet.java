package digitaltrust;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLIntegrityConstraintViolationException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = TextUtil.clean(request.getParameter("name"));
        String email = TextUtil.clean(request.getParameter("email")).toLowerCase();
        String password = request.getParameter("password");
        String address = TextUtil.clean(request.getParameter("address"));
        String bloodGroup = TextUtil.clean(request.getParameter("blood_group"));
        String maritalStatus = TextUtil.clean(request.getParameter("marital_status"));

        Integer age = parseInt(request.getParameter("age"));
        Double income = parseDouble(request.getParameter("income"));

        String validationError = validate(name, email, password, age, address, bloodGroup, maritalStatus, income);
        if (validationError != null) {
            ServletPages.message(response, HttpServletResponse.SC_BAD_REQUEST,
                "Registration failed", validationError, "register.jsp", "Back to Registration");
            return;
        }

        try {
            Db.loadDriver();
            try (Connection con = Db.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO users(name, email, password, age, address, blood_group, marital_status, income) "
                         + "VALUES (?,?,?,?,?,?,?,?)")) {

                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, PasswordUtil.hash(password));
                ps.setInt(4, age);
                ps.setString(5, address);
                ps.setString(6, bloodGroup);
                ps.setString(7, maritalStatus);
                ps.setDouble(8, income);
                ps.executeUpdate();
            }

            response.sendRedirect("login.jsp");
        } catch (SQLIntegrityConstraintViolationException e) {
            ServletPages.message(response, HttpServletResponse.SC_CONFLICT,
                "Registration failed", "An account with this email already exists.",
                "register.jsp", "Back to Registration");
        } catch (Exception e) {
            log("Registration failed", e);
            ServletPages.message(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Registration unavailable", "Please try again later.",
                "register.jsp", "Back to Registration");
        }
    }

    private String validate(String name, String email, String password, Integer age, String address,
                            String bloodGroup, String maritalStatus, Double income) {
        if (TextUtil.isBlank(name) || name.length() < 2 || name.length() > 100) {
            return "Enter a valid full name.";
        }
        if (TextUtil.isBlank(email) || !email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            return "Enter a valid email address.";
        }
        if (password == null || password.length() < 8 || password.length() > 72) {
            return "Password must be between 8 and 72 characters.";
        }
        if (age == null || age < 18 || age > 100) {
            return "Age must be between 18 and 100.";
        }
        if (TextUtil.isBlank(address) || address.length() > 500) {
            return "Enter a valid address.";
        }
        if (TextUtil.isBlank(bloodGroup) || !bloodGroup.matches("^(A|B|AB|O)[+-]$")) {
            return "Select a valid blood group.";
        }
        if (!"Single".equals(maritalStatus) && !"Married".equals(maritalStatus)) {
            return "Select a valid marital status.";
        }
        if (income == null || income < 0 || income > 100000000) {
            return "Enter a valid annual income.";
        }
        return null;
    }

    private Integer parseInt(String value) {
        try {
            return Integer.valueOf(TextUtil.clean(value));
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Double parseDouble(String value) {
        try {
            return Double.valueOf(TextUtil.clean(value));
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
