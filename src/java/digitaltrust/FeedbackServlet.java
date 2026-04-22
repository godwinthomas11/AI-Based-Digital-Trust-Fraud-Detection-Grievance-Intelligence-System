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

@WebServlet(name = "FeedbackServlet", urlPatterns = "/submitFeedback")
public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null
                || (session.getAttribute("userid") == null && session.getAttribute("user_id") == null)) {
            response.sendRedirect("login.jsp");
            return;
        }

        Integer grievanceId = parseInt(request.getParameter("grievance_id"));
        String feedbackMessage = TextUtil.clean(request.getParameter("feedback_message"));
        if (grievanceId == null || TextUtil.isBlank(feedbackMessage)) {
            response.sendRedirect("dashboard?feedback=error");
            return;
        }

        try {
            Db.loadDriver();
            try (Connection con = Db.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO feedback(grievance_id, feedback_message) VALUES (?, ?)")) {

                ps.setInt(1, grievanceId);
                ps.setString(2, TextUtil.truncate(feedbackMessage, 2000));
                ps.executeUpdate();
            }

            response.sendRedirect("dashboard?feedback=success");
        } catch (Exception e) {
            log("Could not submit grievance feedback", e);
            response.sendRedirect("dashboard?feedback=error");
        }
    }

    private Integer parseInt(String value) {
        try {
            return Integer.valueOf(TextUtil.clean(value));
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
