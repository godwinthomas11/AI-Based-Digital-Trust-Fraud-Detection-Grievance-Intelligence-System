<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="digitaltrust.DashboardServlet.GrievanceItem" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("user");
    Object incomeValue = request.getAttribute("income");
    String incomeText = incomeValue == null ? "Not available" : "&#8377;" + String.format("%,.0f", Double.valueOf(String.valueOf(incomeValue)));
    Integer analysisCount = (Integer) request.getAttribute("analysisCount");
    Integer fraudCount = (Integer) request.getAttribute("fraudCount");
    Integer grievanceCount = (Integer) request.getAttribute("grievanceCount");
    List<GrievanceItem> grievances = (List<GrievanceItem>) request.getAttribute("grievances");
%>
<%!
    private String safe(Object value) {
        if (value == null) {
            return "Not available";
        }
        String text = String.valueOf(value);
        if (text.trim().isEmpty()) {
            return "Not available";
        }
        return escapeHtml(text);
    }

    private String initial(Object value) {
        if (value == null || String.valueOf(value).trim().isEmpty()) {
            return "U";
        }
        return escapeHtml(String.valueOf(value).trim().substring(0, 1).toUpperCase());
    }

    private String truncate(String value, int maxLength) {
        if (value == null) {
            return "";
        }
        return value.length() <= maxLength ? value : value.substring(0, maxLength) + "...";
    }

    private String escapeHtml(String value) {
        StringBuilder escaped = new StringBuilder(value.length());
        for (int i = 0; i < value.length(); i++) {
            char c = value.charAt(i);
            switch (c) {
                case '&':
                    escaped.append("&amp;");
                    break;
                case '<':
                    escaped.append("&lt;");
                    break;
                case '>':
                    escaped.append("&gt;");
                    break;
                case '"':
                    escaped.append("&quot;");
                    break;
                case '\'':
                    escaped.append("&#x27;");
                    break;
                default:
                    escaped.append(c);
                    break;
            }
        }
        return escaped.toString();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Dashboard - Digital Trust System</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #07090f;
            --surface: #0e1117;
            --surface2: #151b26;
            --surface3: #1a2235;
            --border: rgba(255,255,255,0.07);
            --accent: #63b3ed;
            --accent2: #4fd1c5;
            --text: #e8edf5;
            --muted: #6b7a99;
            --success: #68d391;
            --warning: #f6ad55;
            --danger: #fc8181;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            min-height: 100vh;
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--text);
        }

        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background-image:
                linear-gradient(rgba(99,179,237,0.02) 1px, transparent 1px),
                linear-gradient(90deg, rgba(99,179,237,0.02) 1px, transparent 1px);
            background-size: 60px 60px;
            pointer-events: none;
            z-index: 0;
        }

        .navbar {
            position: sticky;
            top: 0;
            z-index: 100;
            height: 64px;
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: rgba(7,9,15,0.85);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
        }

        .nav-left, .nav-right, .nav-links, .user-chip {
            display: flex;
            align-items: center;
        }

        .nav-left { gap: 32px; }
        .nav-right { gap: 12px; }
        .nav-links { gap: 4px; }

        .logo-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }

        .logo-icon {
            width: 34px;
            height: 34px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: #07090f;
            font-family: 'Syne', sans-serif;
            font-weight: 800;
        }

        .logo-text {
            color: var(--text);
            font-family: 'Syne', sans-serif;
            font-size: 15px;
            font-weight: 700;
        }

        .logo-text span { color: var(--accent); }

        .nav-link, .btn-logout {
            padding: 7px 14px;
            border-radius: 7px;
            color: var(--muted);
            font-size: 13px;
            text-decoration: none;
            transition: all 0.2s;
        }

        .nav-link:hover, .nav-link.active {
            background: var(--surface2);
            color: var(--text);
        }

        .btn-logout {
            border: 1px solid rgba(252,129,129,0.25);
            color: var(--danger);
        }

        .btn-logout:hover {
            background: rgba(252,129,129,0.08);
            border-color: rgba(252,129,129,0.5);
        }

        .user-chip {
            gap: 8px;
            padding: 6px 14px 6px 8px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 99px;
        }

        .user-avatar {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: #07090f;
            font-size: 11px;
            font-weight: 700;
        }

        .main {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 32px;
            position: relative;
            z-index: 1;
        }

        .page-header { margin-bottom: 28px; }

        .page-eyebrow {
            color: var(--accent);
            font-size: 11px;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            margin-bottom: 10px;
        }

        .page-title {
            font-family: 'Syne', sans-serif;
            font-size: 34px;
            line-height: 1.15;
            margin-bottom: 8px;
        }

        .page-subtitle {
            color: var(--muted);
            font-size: 15px;
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 28px;
        }

        .stat-card, .panel {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
        }

        .stat-card {
            padding: 22px 24px;
            border-left-width: 4px;
        }

        .stat-card.green { border-left-color: var(--success); }
        .stat-card.red { border-left-color: var(--danger); }
        .stat-card.orange { border-left-color: var(--warning); }
        .stat-card.blue { border-left-color: var(--accent); }

        .stat-label {
            color: var(--muted);
            font-size: 12px;
            margin-bottom: 8px;
        }

        .stat-value {
            color: var(--text);
            font-family: 'Syne', sans-serif;
            font-size: 28px;
            font-weight: 700;
        }

        .panel { margin-bottom: 28px; overflow: hidden; }

        .panel-header {
            padding: 22px 26px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
        }

        .panel-title {
            font-family: 'Syne', sans-serif;
            font-size: 18px;
            font-weight: 700;
        }

        .panel-body { padding: 24px 26px; }

        .profile-table {
            width: 100%;
            border-collapse: collapse;
        }

        .profile-table th, .profile-table td {
            width: 50%;
            padding: 14px 16px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            font-size: 14px;
            vertical-align: top;
        }

        .profile-table th {
            color: var(--muted);
            font-weight: 500;
        }

        .profile-table tr:last-child th, .profile-table tr:last-child td { border-bottom: none; }

        .success-banner, .error-banner, .empty-message {
            border-radius: 10px;
            padding: 13px 16px;
            font-size: 13px;
            margin-bottom: 16px;
        }

        .success-banner {
            background: rgba(104,211,145,0.08);
            border: 1px solid rgba(104,211,145,0.25);
            color: var(--success);
        }

        .error-banner {
            background: rgba(252,129,129,0.08);
            border: 1px solid rgba(252,129,129,0.25);
            color: var(--danger);
        }

        .empty-message {
            background: var(--surface2);
            border: 1px solid var(--border);
            color: var(--muted);
        }

        .table-wrap { overflow-x: auto; }

        .grievance-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 760px;
        }

        .grievance-table th, .grievance-table td {
            padding: 14px 12px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            font-size: 13px;
            vertical-align: top;
        }

        .grievance-table th {
            color: var(--muted);
            font-size: 11px;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            font-weight: 700;
        }

        .badge {
            display: inline-flex;
            padding: 4px 10px;
            border-radius: 99px;
            font-size: 12px;
            font-weight: 700;
        }

        .badge.pending {
            background: rgba(246,173,85,0.1);
            color: var(--warning);
            border: 1px solid rgba(246,173,85,0.25);
        }

        .badge.resolved {
            background: rgba(104,211,145,0.1);
            color: var(--success);
            border: 1px solid rgba(104,211,145,0.25);
        }

        .feedback-btn, .submit-btn {
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-family: 'DM Sans', sans-serif;
            font-weight: 700;
            transition: all 0.2s;
        }

        .feedback-btn {
            padding: 8px 12px;
            background: rgba(99,179,237,0.12);
            color: var(--accent);
            border: 1px solid rgba(99,179,237,0.25);
        }

        .feedback-btn:hover { background: rgba(99,179,237,0.2); }

        .feedback-row { display: none; }
        .feedback-row.open { display: table-row; }

        .feedback-form {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 12px;
            padding: 10px 0;
        }

        .feedback-form textarea {
            width: 100%;
            min-height: 70px;
            padding: 12px;
            resize: vertical;
            border-radius: 10px;
            border: 1px solid var(--border);
            outline: none;
            background: var(--surface2);
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
        }

        .feedback-form textarea:focus {
            border-color: rgba(99,179,237,0.5);
        }

        .submit-btn {
            align-self: start;
            padding: 12px 18px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: #07090f;
        }

        @media (max-width: 900px) {
            .navbar { height: auto; padding: 16px 20px; gap: 14px; align-items: flex-start; }
            .nav-left, .nav-right { flex-wrap: wrap; gap: 12px; }
            .nav-links { order: 3; width: 100%; }
            .main { padding: 28px 18px; }
            .stats-row { grid-template-columns: 1fr 1fr; }
            .panel-header, .panel-body { padding: 20px; }
            .feedback-form { grid-template-columns: 1fr; }
        }

        @media (max-width: 560px) {
            .stats-row { grid-template-columns: 1fr; }
            .page-title { font-size: 28px; }
            .profile-table th, .profile-table td { display: block; width: 100%; padding: 10px 0; }
            .profile-table th { border-bottom: none; padding-bottom: 2px; }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-left">
            <a href="index.jsp" class="logo-wrap">
                <div class="logo-icon">DT</div>
                <div class="logo-text">Digital<span>Trust</span></div>
            </a>
            <div class="nav-links">
                <a href="index.jsp" class="nav-link">Home</a>
                <a href="check_scheme.jsp" class="nav-link">Analyze Scheme</a>
                <a href="dashboard" class="nav-link active">My Dashboard</a>
            </div>
        </div>
        <div class="nav-right">
            <div class="user-chip">
                <div class="user-avatar"><%= initial(userName) %></div>
                <span><%= safe(userName) %></span>
            </div>
            <a href="LogoutServlet" class="btn-logout">Sign Out</a>
        </div>
    </nav>

    <main class="main">
        <section class="page-header">
            <div class="page-eyebrow">User Overview</div>
            <h1 class="page-title">My Dashboard</h1>
            <p class="page-subtitle">Welcome back, <%= safe(userName) %></p>
        </section>

        <section class="stats-row" aria-label="Dashboard statistics">
            <div class="stat-card green">
                <div class="stat-label">Total Schemes Checked</div>
                <div class="stat-value"><%= analysisCount == null ? 0 : analysisCount %></div>
            </div>
            <div class="stat-card red">
                <div class="stat-label">Frauds Caught</div>
                <div class="stat-value"><%= fraudCount == null ? 0 : fraudCount %></div>
            </div>
            <div class="stat-card orange">
                <div class="stat-label">Total Grievances Filed</div>
                <div class="stat-value"><%= grievanceCount == null ? 0 : grievanceCount %></div>
            </div>
            <div class="stat-card blue">
                <div class="stat-label">Account Status</div>
                <div class="stat-value">Active</div>
            </div>
        </section>

        <section class="panel">
            <div class="panel-header">
                <h2 class="panel-title">Your Profile</h2>
            </div>
            <div class="panel-body">
                <table class="profile-table">
                    <tr><th>Name</th><td><%= safe(request.getAttribute("name")) %></td></tr>
                    <tr><th>Email</th><td><%= safe(request.getAttribute("email")) %></td></tr>
                    <tr><th>Age</th><td><%= safe(request.getAttribute("age")) %></td></tr>
                    <tr><th>Address</th><td><%= safe(request.getAttribute("address")) %></td></tr>
                    <tr><th>Annual Income</th><td><%= incomeText %></td></tr>
                    <tr><th>Marital Status</th><td><%= safe(request.getAttribute("maritalstatus")) %></td></tr>
                    <tr><th>Blood Group</th><td><%= safe(request.getAttribute("bloodgroup")) %></td></tr>
                </table>
            </div>
        </section>

        <section class="panel">
            <div class="panel-header">
                <h2 class="panel-title">My Grievances &amp; Feedback</h2>
            </div>
            <div class="panel-body">
                <% if ("success".equals(request.getParameter("feedback"))) { %>
                    <div class="success-banner">Feedback submitted successfully.</div>
                <% } else if ("error".equals(request.getParameter("feedback"))) { %>
                    <div class="error-banner">Feedback could not be submitted. Please try again.</div>
                <% } %>

                <% if (grievances == null || grievances.isEmpty()) { %>
                    <div class="empty-message">No grievances filed yet.</div>
                <% } else { %>
                    <div class="table-wrap">
                        <table class="grievance-table">
                            <thead>
                                <tr>
                                    <th>#ID</th>
                                    <th>Message</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (GrievanceItem grievance : grievances) {
                                    String statusClass = "Resolved".equalsIgnoreCase(grievance.getStatus()) ? "resolved" : "pending";
                                %>
                                    <tr>
                                        <td>#<%= grievance.getId() %></td>
                                        <td><%= escapeHtml(truncate(grievance.getMessage(), 60)) %></td>
                                        <td><span class="badge <%= statusClass %>"><%= safe(grievance.getStatus()) %></span></td>
                                        <td><%= safe(grievance.getCreatedAt()) %></td>
                                        <td>
                                            <button type="button" class="feedback-btn" onclick="toggleFeedback('feedback-<%= grievance.getId() %>')">Give Feedback</button>
                                        </td>
                                    </tr>
                                    <tr class="feedback-row" id="feedback-<%= grievance.getId() %>">
                                        <td colspan="5">
                                            <form action="submitFeedback" method="post" class="feedback-form">
                                                <input type="hidden" name="grievance_id" value="<%= grievance.getId() %>">
                                                <textarea name="feedback_message" placeholder="Your feedback..." rows="2" required></textarea>
                                                <button type="submit" class="submit-btn">Submit</button>
                                            </form>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </section>
    </main>

    <script>
        function toggleFeedback(rowId) {
            var row = document.getElementById(rowId);
            if (row) {
                row.classList.toggle('open');
            }
        }
    </script>
</body>
</html>
