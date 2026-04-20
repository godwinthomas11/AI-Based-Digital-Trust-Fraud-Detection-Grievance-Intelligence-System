package digitaltrust;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SubmitGrievanceServlet")
public class SubmitGrievanceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String message = TextUtil.clean(request.getParameter("scam_details"));
        if (message.isEmpty()) {
            ServletPages.message(response, HttpServletResponse.SC_BAD_REQUEST,
                "Grievance failed", "Please provide the scam details before submitting.",
                "index.jsp", "Back to Dashboard");
            return;
        }

        if (saveGrievance(message)) {
            ServletPages.message(response, HttpServletResponse.SC_OK,
                "Grievance submitted", "Your report has been saved for review.",
                "index.jsp", "Back to Dashboard");
        } else {
            ServletPages.message(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Grievance unavailable", "Please try again later.",
                "index.jsp", "Back to Dashboard");
        }
    }

    private boolean saveGrievance(String message) {
        try {
            Db.loadDriver();
            try (Connection con = Db.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO grievances(message, status) VALUES (?,?)")) {

                ps.setString(1, TextUtil.truncate(message, 1000));
                ps.setString(2, "Pending");
                ps.executeUpdate();
                return true;
            }
        } catch (Exception e) {
            log("Could not save grievance", e);
            return false;
        }
    }
}
