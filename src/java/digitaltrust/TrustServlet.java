package digitaltrust;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/TrustServlet")
public class TrustServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message = TextUtil.clean(request.getParameter("message"));
        if (message.isEmpty()) {
            ServletPages.message(response, HttpServletResponse.SC_BAD_REQUEST,
                "Analysis failed", "Enter a message to analyze.", "index.jsp", "Back");
            return;
        }

        FraudResult result = FraudAnalyzer.analyze(message);

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<!doctype html><html lang=\"en\"><head><meta charset=\"UTF-8\">");
        out.println("<title>Trust Analysis</title></head><body>");
        out.println("<h1>Trust Analysis</h1>");
        out.println("<h2>Trust Score: " + result.getTrustScore() + "%</h2>");
        out.println("<h2>Status: " + TextUtil.escapeHtml(result.getLabel()) + "</h2>");
        out.println("<br><a href=\"index.jsp\">Back</a>");
        out.println("</body></html>");
    }
}
