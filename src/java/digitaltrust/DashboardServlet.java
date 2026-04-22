package digitaltrust;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DashboardServlet", urlPatterns = "/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final DateTimeFormatter DATE_FORMAT =
        DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userId = getUserId(session);
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Db.loadDriver();
            try (Connection con = Db.getConnection()) {
                loadProfile(con, request, userId);
                request.setAttribute("analysisCount", countAnalysis(con, userId));
                request.setAttribute("fraudCount", countFrauds(con, userId));
                request.setAttribute("grievances", loadGrievances(con, userId));
                request.setAttribute("grievanceCount", countGrievances(con, userId));
            }

            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            log("Could not load user dashboard", e);
            ServletPages.message(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Dashboard unavailable", "Please try again later.", "index.jsp", "Back to Home");
        }
    }

    private Integer getUserId(HttpSession session) {
        if (session == null) {
            return null;
        }

        Object userId = session.getAttribute("userid");
        if (userId == null) {
            userId = session.getAttribute("user_id");
        }
        if (userId instanceof Number) {
            return ((Number) userId).intValue();
        }
        if (userId instanceof String) {
            try {
                return Integer.valueOf((String) userId);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }

    private void loadProfile(Connection con, HttpServletRequest request, int userId) throws Exception {
        String sql = "SELECT name, email, age, address, income, "
            + "marital_status AS maritalstatus, blood_group AS bloodgroup "
            + "FROM users WHERE id = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("name", rs.getString("name"));
                    request.setAttribute("email", rs.getString("email"));
                    request.setAttribute("age", rs.getObject("age"));
                    request.setAttribute("address", rs.getString("address"));
                    request.setAttribute("income", rs.getObject("income"));
                    request.setAttribute("maritalstatus", rs.getString("maritalstatus"));
                    request.setAttribute("bloodgroup", rs.getString("bloodgroup"));
                }
            }
        }
    }

    private int countAnalysis(Connection con, int userId) throws Exception {
        String userColumn = firstExistingColumn(con, "analysis", "userid", "user_id");
        if (userColumn == null) {
            return countRows(con, "SELECT COUNT(*) FROM analysis");
        }
        return countRows(con, "SELECT COUNT(*) FROM analysis WHERE " + userColumn + " = ?", userId);
    }

    private int countFrauds(Connection con, int userId) throws Exception {
        String userColumn = firstExistingColumn(con, "analysis", "userid", "user_id");
        String classificationColumn = firstExistingColumn(con, "analysis", "classification", "label");
        if (classificationColumn == null) {
            return 0;
        }

        if (userColumn == null) {
            return countRows(con,
                "SELECT COUNT(*) FROM analysis WHERE UPPER(" + classificationColumn + ") = ?", "FRAUD");
        }
        return countRows(con,
            "SELECT COUNT(*) FROM analysis WHERE " + userColumn + " = ? AND UPPER("
                + classificationColumn + ") = ?",
            userId, "FRAUD");
    }

    private int countGrievances(Connection con, int userId) throws Exception {
        String userColumn = firstExistingColumn(con, "grievances", "userid", "user_id");
        if (userColumn == null) {
            return countRows(con, "SELECT COUNT(*) FROM grievances");
        }
        return countRows(con, "SELECT COUNT(*) FROM grievances WHERE " + userColumn + " = ?", userId);
    }

    private List<GrievanceItem> loadGrievances(Connection con, int userId) throws Exception {
        List<GrievanceItem> grievances = new ArrayList<>();
        String userColumn = firstExistingColumn(con, "grievances", "userid", "user_id");
        boolean hasCreatedAt = hasColumn(con, "grievances", "created_at");

        String sql;
        if (hasCreatedAt && userColumn != null) {
            sql = "SELECT id, message, status, created_at FROM grievances WHERE "
                + userColumn + " = ? ORDER BY created_at DESC";
        } else if (hasCreatedAt) {
            sql = "SELECT id, message, status, created_at FROM grievances ORDER BY created_at DESC";
        } else if (userColumn != null) {
            sql = "SELECT id, message, status FROM grievances WHERE " + userColumn + " = ? ORDER BY id DESC";
        } else {
            sql = "SELECT id, message, status FROM grievances ORDER BY id DESC";
        }

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            if (userColumn != null) {
                ps.setInt(1, userId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String date = "Not recorded";
                    if (hasCreatedAt) {
                        Timestamp createdAt = rs.getTimestamp("created_at");
                        if (createdAt != null) {
                            date = createdAt.toLocalDateTime().format(DATE_FORMAT);
                        }
                    }
                    grievances.add(new GrievanceItem(
                        rs.getInt("id"),
                        rs.getString("message"),
                        rs.getString("status"),
                        date));
                }
            }
        }

        return grievances;
    }

    private int countRows(Connection con, String sql, Object... params) throws Exception {
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                Object param = params[i];
                if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else {
                    ps.setString(i + 1, String.valueOf(param));
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private String firstExistingColumn(Connection con, String table, String... columns) throws Exception {
        for (String column : columns) {
            if (hasColumn(con, table, column)) {
                return column;
            }
        }
        return null;
    }

    private boolean hasColumn(Connection con, String table, String column) throws Exception {
        try (PreparedStatement ps = con.prepareStatement(
                "SELECT 1 FROM information_schema.COLUMNS "
                    + "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?")) {
            ps.setString(1, table);
            ps.setString(2, column);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public static final class GrievanceItem {
        private final int id;
        private final String message;
        private final String status;
        private final String createdAt;

        private GrievanceItem(int id, String message, String status, String createdAt) {
            this.id = id;
            this.message = message == null ? "" : message;
            this.status = status == null ? "Pending" : status;
            this.createdAt = createdAt == null ? "Not recorded" : createdAt;
        }

        public int getId() {
            return id;
        }

        public String getMessage() {
            return message;
        }

        public String getStatus() {
            return status;
        }

        public String getCreatedAt() {
            return createdAt;
        }
    }
}
