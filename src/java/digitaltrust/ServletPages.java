package digitaltrust;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.http.HttpServletResponse;

final class ServletPages {

    private ServletPages() {
    }

    static void message(HttpServletResponse response, int status, String title,
                        String message, String backHref, String backText) throws IOException {
        response.setStatus(status);
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();
        out.println("<!doctype html>");
        out.println("<html lang=\"en\"><head><meta charset=\"UTF-8\">");
        out.println("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
        out.println("<title>" + TextUtil.escapeHtml(title) + "</title>");
        out.println("<style>");
        out.println("body{font-family:Arial,sans-serif;background:#07090f;color:#e8edf5;display:grid;place-items:center;min-height:100vh;margin:0;padding:24px}");
        out.println(".box{max-width:520px;background:#0e1117;border:1px solid rgba(255,255,255,.09);border-radius:10px;padding:28px;line-height:1.5}");
        out.println("a{color:#63b3ed}");
        out.println("</style></head><body><main class=\"box\">");
        out.println("<h2>" + TextUtil.escapeHtml(title) + "</h2>");
        out.println("<p>" + TextUtil.escapeHtml(message) + "</p>");
        out.println("<a href=\"" + TextUtil.escapeHtml(backHref) + "\">" + TextUtil.escapeHtml(backText) + "</a>");
        out.println("</main></body></html>");
    }
}
