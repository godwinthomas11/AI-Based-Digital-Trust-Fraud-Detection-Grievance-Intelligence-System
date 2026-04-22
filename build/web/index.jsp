<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String userName = (String) session.getAttribute("user");
    Double userIncome = (Double) session.getAttribute("user_income");
    String incomeFormatted = userIncome != null ? String.format("₹%,.0f", userIncome) : "—";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Digital Trust System</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:ital,wght@0,300;0,400;0,500;1,300&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #07090f;
            --surface: #0e1117;
            --surface2: #151b26;
            --surface3: #1a2235;
            --border: rgba(255,255,255,0.07);
            --border-hover: rgba(99,179,237,0.25);
            --accent: #63b3ed;
            --accent2: #4fd1c5;
            --text: #e8edf5;
            --muted: #6b7a99;
            --success: #68d391;
            --warning: #f6ad55;
            --danger: #fc8181;
            --glow: rgba(99,179,237,0.12);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
        }

        /* Grid bg */
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

        /* NAVBAR */
        .navbar {
            position: sticky;
            top: 0;
            z-index: 100;
            background: rgba(7,9,15,0.85);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
            padding: 0 32px;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .nav-left {
            display: flex;
            align-items: center;
            gap: 32px;
        }

        .logo-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }

        .logo-icon {
            width: 34px; height: 34px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 15px;
        }

        .logo-text {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 15px;
            color: var(--text);
        }
        .logo-text span { color: var(--accent); }

        .nav-links {
            display: flex;
            gap: 4px;
        }

        .nav-link {
            padding: 6px 14px;
            border-radius: 7px;
            text-decoration: none;
            font-size: 13px;
            color: var(--muted);
            transition: all 0.2s;
        }

        .nav-link:hover, .nav-link.active {
            background: var(--surface2);
            color: var(--text);
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        /* Live indicator */
        .live-badge {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 5px 12px;
            background: rgba(104,211,145,0.08);
            border: 1px solid rgba(104,211,145,0.2);
            border-radius: 99px;
            font-size: 11px;
            color: var(--success);
            letter-spacing: 0.04em;
        }

        .live-dot {
            width: 6px; height: 6px;
            border-radius: 50%;
            background: var(--success);
            box-shadow: 0 0 0 0 rgba(104,211,145,0.5);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(104,211,145,0.5); }
            70% { box-shadow: 0 0 0 6px rgba(104,211,145,0); }
            100% { box-shadow: 0 0 0 0 rgba(104,211,145,0); }
        }

        .user-chip {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 6px 14px 6px 8px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 99px;
        }

        .user-avatar {
            width: 26px; height: 26px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 700;
            color: #07090f;
        }

        .user-name {
            font-size: 12px;
            font-weight: 500;
            color: var(--text);
        }

        .btn-logout {
            padding: 7px 16px;
            background: transparent;
            border: 1px solid rgba(252,129,129,0.25);
            border-radius: 7px;
            color: var(--danger);
            font-family: 'DM Sans', sans-serif;
            font-size: 12px;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-logout:hover {
            background: rgba(252,129,129,0.08);
            border-color: rgba(252,129,129,0.5);
        }

        /* MAIN CONTENT */
        .main {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 32px;
            position: relative;
            z-index: 1;
        }

        /* Hero section */
        .hero {
            margin-bottom: 40px;
            animation: fadeUp 0.5s ease forwards;
            opacity: 0;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .hero-eyebrow {
            font-size: 11px;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--accent);
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .hero-eyebrow::before {
            content: '';
            width: 20px; height: 1px;
            background: var(--accent);
        }

        .hero-title {
            font-family: 'Syne', sans-serif;
            font-size: 38px;
            font-weight: 800;
            line-height: 1.15;
            margin-bottom: 12px;
        }

        .hero-title em {
            font-style: normal;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-sub {
            font-size: 15px;
            color: var(--muted);
            max-width: 560px;
            line-height: 1.6;
        }

        /* Stats row */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 32px;
            animation: fadeUp 0.5s 0.1s ease forwards;
            opacity: 0;
        }

        .stat-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 22px 24px;
            transition: border-color 0.2s, transform 0.2s;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
        }

        .stat-card.blue::before { background: linear-gradient(90deg, var(--accent), transparent); }
        .stat-card.teal::before { background: linear-gradient(90deg, var(--accent2), transparent); }
        .stat-card.green::before { background: linear-gradient(90deg, var(--success), transparent); }
        .stat-card.orange::before { background: linear-gradient(90deg, var(--warning), transparent); }

        .stat-card:hover {
            border-color: var(--border-hover);
            transform: translateY(-2px);
        }

        .stat-card-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 14px;
        }

        .stat-icon {
            width: 36px; height: 36px;
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }

        .stat-icon.blue { background: rgba(99,179,237,0.12); }
        .stat-icon.teal { background: rgba(79,209,197,0.12); }
        .stat-icon.green { background: rgba(104,211,145,0.12); }
        .stat-icon.orange { background: rgba(246,173,85,0.12); }

        .stat-trend {
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 4px;
            font-weight: 500;
        }

        .stat-trend.up { background: rgba(104,211,145,0.1); color: var(--success); }
        .stat-trend.down { background: rgba(252,129,129,0.1); color: var(--danger); }

        .stat-value {
            font-family: 'Syne', sans-serif;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .stat-label {
            font-size: 12px;
            color: var(--muted);
        }

        /* Action area */
        .action-section {
            animation: fadeUp 0.5s 0.2s ease forwards;
            opacity: 0;
        }

        .section-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .section-title {
            font-family: 'Syne', sans-serif;
            font-size: 18px;
            font-weight: 700;
        }

        .section-badge {
            font-size: 11px;
            padding: 4px 10px;
            border-radius: 99px;
            background: rgba(99,179,237,0.1);
            color: var(--accent);
            border: 1px solid rgba(99,179,237,0.2);
        }

        /* Main CTA card */
        .cta-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 48px;
            text-align: center;
            margin-bottom: 24px;
            position: relative;
            overflow: hidden;
            transition: border-color 0.3s;
        }

        .cta-card:hover { border-color: var(--border-hover); }

        .cta-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--accent), var(--accent2), transparent);
        }

        /* Big animated shield */
        .shield-wrap {
            width: 100px; height: 100px;
            background: linear-gradient(145deg, rgba(99,179,237,0.15), rgba(79,209,197,0.08));
            border: 1px solid rgba(99,179,237,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 42px;
            margin: 0 auto 24px;
            animation: shieldPulse 3s ease-in-out infinite;
        }

        @keyframes shieldPulse {
            0%, 100% { box-shadow: 0 0 0 0 rgba(99,179,237,0.2); }
            50% { box-shadow: 0 0 0 20px rgba(99,179,237,0); }
        }

        .cta-title {
            font-family: 'Syne', sans-serif;
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .cta-desc {
            font-size: 14px;
            color: var(--muted);
            max-width: 460px;
            margin: 0 auto 32px;
            line-height: 1.6;
        }

        .cta-btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 16px 40px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border: none;
            border-radius: 12px;
            color: #07090f;
            font-family: 'Syne', sans-serif;
            font-size: 15px;
            font-weight: 700;
            letter-spacing: 0.03em;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
        }

        .cta-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(99,179,237,0.35);
        }

        .cta-meta {
            display: flex;
            justify-content: center;
            gap: 28px;
            margin-top: 24px;
        }

        .cta-meta-item {
            font-size: 12px;
            color: var(--muted);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        /* Feature grid */
        .features-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 32px;
            animation: fadeUp 0.5s 0.3s ease forwards;
            opacity: 0;
        }

        .feature-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 24px;
            transition: all 0.2s;
            cursor: pointer;
            text-decoration: none;
            display: block;
        }

        .feature-card:hover {
            border-color: var(--border-hover);
            background: var(--surface2);
            transform: translateY(-2px);
        }

        .feature-icon {
            width: 44px; height: 44px;
            border-radius: 11px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            margin-bottom: 14px;
        }

        .feature-icon.blue { background: rgba(99,179,237,0.1); border: 1px solid rgba(99,179,237,0.15); }
        .feature-icon.teal { background: rgba(79,209,197,0.1); border: 1px solid rgba(79,209,197,0.15); }
        .feature-icon.purple { background: rgba(159,122,234,0.1); border: 1px solid rgba(159,122,234,0.15); }

        .feature-name {
            font-family: 'Syne', sans-serif;
            font-size: 15px;
            font-weight: 600;
            color: var(--text);
            margin-bottom: 6px;
        }

        .feature-desc {
            font-size: 12px;
            color: var(--muted);
            line-height: 1.6;
        }

        .feature-arrow {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 16px;
            padding-top: 14px;
            border-top: 1px solid var(--border);
            font-size: 11px;
            color: var(--accent);
            letter-spacing: 0.04em;
            text-transform: uppercase;
        }

        /* Profile bar */
        .profile-bar {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 20px 24px;
            display: flex;
            align-items: center;
            gap: 24px;
            animation: fadeUp 0.5s 0.4s ease forwards;
            opacity: 0;
        }

        .profile-label {
            font-size: 11px;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 2px;
        }

        .profile-value {
            font-size: 14px;
            font-weight: 500;
            color: var(--text);
        }

        .profile-divider {
            width: 1px;
            height: 32px;
            background: var(--border);
            flex-shrink: 0;
        }

        .profile-icon {
            width: 48px; height: 48px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Syne', sans-serif;
            font-size: 18px;
            font-weight: 700;
            color: #07090f;
            flex-shrink: 0;
        }

        @media (max-width: 900px) {
            .stats-row { grid-template-columns: 1fr 1fr; }
            .features-grid { grid-template-columns: 1fr; }
            .hero-title { font-size: 28px; }
            .cta-card { padding: 32px 20px; }
            .profile-bar { flex-wrap: wrap; }
            .nav-links { display: none; }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="nav-left">
            <a href="index.jsp" class="logo-wrap">
                <div class="logo-icon">🛡️</div>
                <div class="logo-text">Digital<span>Trust</span></div>
            </a>
            <div class="nav-links">
                <a href="index.jsp" class="nav-link active">Dashboard</a>
                <a href="check_scheme.jsp" class="nav-link">Analyze Scheme</a>
                <a href="dashboard" class="nav-link">My Dashboard</a>
            </div>
        </div>
        <div class="nav-right">
            <div class="live-badge">
                <div class="live-dot"></div>
                System Online
            </div>
            <div class="user-chip">
                <div class="user-avatar"><%= userName.substring(0,1).toUpperCase() %></div>
                <span class="user-name"><%= userName %></span>
            </div>
            <a href="dashboard" class="nav-link">My Dashboard</a>
            <a href="LogoutServlet" class="btn-logout">Sign Out</a>
        </div>
    </nav>

    <main class="main">
        <!-- Hero -->
        <div class="hero">
            <div class="hero-eyebrow">Citizen Protection Platform</div>
            <h1 class="hero-title">Welcome back, <em><%= userName.split(" ")[0] %>.</em></h1>
            <p class="hero-sub">Your fraud protection dashboard is active. Analyze scheme messages, verify authenticity, and stay protected from digital scams.</p>
        </div>

        <!-- Stats -->
        <div class="stats-row">
            <div class="stat-card blue">
                <div class="stat-card-top">
                    <div class="stat-icon blue">Check</div>
                    <div class="stat-trend up">Ready</div>
                </div>
                <div class="stat-value">Analyze</div>
                <div class="stat-label">Message, URL, or text file</div>
            </div>
            <div class="stat-card teal">
                <div class="stat-card-top">
                    <div class="stat-icon teal">Flag</div>
                    <div class="stat-trend up">After scan</div>
                </div>
                <div class="stat-value">Report</div>
                <div class="stat-label">Save suspicious schemes</div>
            </div>
            <div class="stat-card green">
                <div class="stat-card-top">
                    <div class="stat-icon green">User</div>
                    <div class="stat-trend up">Profile</div>
                </div>
                <div class="stat-value">Match</div>
                <div class="stat-label">Basic eligibility check</div>
            </div>
            <div class="stat-card orange">
                <div class="stat-card-top">
                    <div class="stat-icon orange">Lock</div>
                    <div class="stat-trend up">30 min</div>
                </div>
                <div class="stat-value">Secure</div>
                <div class="stat-label">Session-protected access</div>
            </div>
        </div>

        <!-- Main CTA -->
        <div class="action-section">
            <div class="section-head">
                <div class="section-title">Scheme Verification</div>
                <div class="section-badge">Rule-Based</div>
            </div>

            <div class="cta-card">
                <div class="shield-wrap">Shield</div>
                <div class="cta-title">Check any Government Scheme</div>
                <div class="cta-desc">Paste a message, share a URL, or upload a text document. The verification rules check scam triggers, risky links, and basic profile eligibility.</div>
                <a href="check_scheme.jsp" class="cta-btn">
                    <span>Analyze a Scheme Now</span>
                    <span>&rarr;</span>
                </a>
                <div class="cta-meta">
                    <div class="cta-meta-item">Trust score generated instantly</div>
                    <div class="cta-meta-item">URL and .txt upload supported</div>
                    <div class="cta-meta-item">Eligibility check included</div>
                </div>
            </div>
        </div>

        <!-- Features -->
        <div class="features-grid">
            <a href="check_scheme.jsp" class="feature-card">
                <div class="feature-icon blue">Text</div>
                <div class="feature-name">Fraud Keyword Engine</div>
                <div class="feature-desc">Detects urgent triggers, scam terms, payment pressure, and sensitive-data requests in submitted text.</div>
                <div class="feature-arrow"><span>Analyze now</span><span>&rarr;</span></div>
            </a>
            <a href="check_scheme.jsp" class="feature-card">
                <div class="feature-icon teal">URL</div>
                <div class="feature-name">URL Verification</div>
                <div class="feature-desc">Checks whether submitted links use trusted government-style domains or suspicious public domains.</div>
                <div class="feature-arrow"><span>Check a URL</span><span>&rarr;</span></div>
            </a>
            <a href="check_scheme.jsp" class="feature-card">
                <div class="feature-icon purple">User</div>
                <div class="feature-name">Profile Eligibility Match</div>
                <div class="feature-desc">After verification, the system checks if a genuine scheme broadly matches your saved income and age profile.</div>
                <div class="feature-arrow"><span>View eligibility</span><span>&rarr;</span></div>
            </a>
        </div>

        <!-- Profile bar -->
        <div class="profile-bar">
            <div class="profile-icon"><%= userName.substring(0,1).toUpperCase() %></div>
            <div>
                <div class="profile-label">Registered Citizen</div>
                <div class="profile-value"><%= userName %></div>
            </div>
            <div class="profile-divider"></div>
            <div>
                <div class="profile-label">Annual Income</div>
                <div class="profile-value"><%= incomeFormatted %></div>
            </div>
            <div class="profile-divider"></div>
            <div>
                <div class="profile-label">Scheme Eligibility</div>
                <div class="profile-value" style="color: var(--success);">
                    <% if (userIncome != null && userIncome <= 800000) { %>Eligible for subsidized schemes<% } else { %>Standard profile<% } %>
                </div>
            </div>
            <div class="profile-divider"></div>
            <div>
                <div class="profile-label">Protection Status</div>
                <div class="profile-value" style="color: var(--success);">Active</div>
            </div>
        </div>
    </main>
</body>
</html>
