package digitaltrust;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/GrievanceServlet")
public class GrievanceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message = TextUtil.clean(request.getParameter("message"));
        if (message.isEmpty()) {
            ServletPages.message(response, HttpServletResponse.SC_BAD_REQUEST,
                "Grievance failed", "Please provide a message to report.",
                "index.jsp", "Back");
            return;
        }

        try {
            Db.loadDriver();
            try (Connection con = Db.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO grievances(message, status) VALUES (?,?)")) {

                ps.setString(1, TextUtil.truncate(message, 1000));
                ps.setString(2, "Pending");
                ps.executeUpdate();
            }

            ServletPages.message(response, HttpServletResponse.SC_OK,
                "Grievance submitted", "Your report has been saved for review.",
                "index.jsp", "Back");
        } catch (Exception e) {
            log("Could not save grievance", e);
            ServletPages.message(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Grievance unavailable", "Please try again later.",
                "index.jsp", "Back");
        }
    }
}
