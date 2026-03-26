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

@WebServlet("/SubmitGrievanceServlet")
public class SubmitGrievanceServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String message = request.getParameter("scam_details"); 
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/digital_trust", "root", "root");
            
            PreparedStatement ps = con.prepareStatement("INSERT INTO grievances(message, status) VALUES (?,?)");
            ps.setString(1, message);
            ps.setString(2, "Pending");
            ps.executeUpdate();
            
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<h2>Grievance Submitted Successfully to Government Portal</h2>");
            out.println("<br><a href='index.jsp'>Back to Dashboard</a>");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}