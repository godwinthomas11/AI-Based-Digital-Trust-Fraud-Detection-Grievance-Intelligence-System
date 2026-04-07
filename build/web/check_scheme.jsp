<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String userName = (String) session.getAttribute("user");
    String trustScoreStr = (String) request.getAttribute("trustScore");
    String isGenuine = (String) request.getAttribute("isGenuine");
    String profileMatch = (String) request.getAttribute("profileMatch");
    boolean hasResult = (trustScoreStr != null);
    int trustScore = hasResult ? Integer.parseInt(trustScoreStr) : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analyze Scheme — Digital Trust System</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:ital,wght@0,300;0,400;0,500;1,300&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #07090f;
            --surface: #0e1117;
            --surface2: #151b26;
            --surface3: #1a2235;
            --border: rgba(255,255,255,0.07);
            --border-active: rgba(99,179,237,0.5);
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

        .blob {
            position: fixed;
            border-radius: 50%;
            filter: blur(150px);
            pointer-events: none;
            z-index: 0;
        }
        .blob-1 { width: 600px; height: 600px; background: rgba(99,179,237,0.05); top: -200px; right: -150px; }
        .blob-2 { width: 400px; height: 400px; background: rgba(79,209,197,0.04); bottom: -100px; left: -100px; }

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

        .nav-left { display: flex; align-items: center; gap: 32px; }

        .logo-wrap { display: flex; align-items: center; gap: 10px; text-decoration: none; }

        .logo-icon {
            width: 34px; height: 34px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            font-size: 15px;
        }

        .logo-text { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 15px; color: var(--text); }
        .logo-text span { color: var(--accent); }

        .nav-links { display: flex; gap: 4px; }

        .nav-link {
            padding: 6px 14px;
            border-radius: 7px;
            text-decoration: none;
            font-size: 13px;
            color: var(--muted);
            transition: all 0.2s;
        }
        .nav-link:hover, .nav-link.active { background: var(--surface2); color: var(--text); }

        .nav-right { display: flex; align-items: center; gap: 12px; }

        .user-chip {
            display: flex; align-items: center; gap: 8px;
            padding: 6px 14px 6px 8px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 99px;
        }

        .user-avatar {
            width: 26px; height: 26px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            display: flex; align-items: center; justify-content: center;
            font-size: 11px; font-weight: 700; color: #07090f;
        }

        .user-name { font-size: 12px; font-weight: 500; color: var(--text); }

        .btn-back {
            padding: 7px 16px;
            background: transparent;
            border: 1px solid var(--border);
            border-radius: 7px;
            color: var(--muted);
            font-size: 12px;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-back:hover { border-color: var(--border-active); color: var(--accent); }

        /* MAIN */
        .main {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 32px;
            position: relative;
            z-index: 1;
        }

        /* Page header */
        .page-header {
            margin-bottom: 36px;
            animation: fadeUp 0.5s ease forwards;
            opacity: 0;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .page-eyebrow {
            font-size: 11px;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--accent);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .page-eyebrow::before { content: ''; width: 20px; height: 1px; background: var(--accent); }

        .page-title {
            font-family: 'Syne', sans-serif;
            font-size: 30px;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .page-sub { font-size: 14px; color: var(--muted); }

        /* Two-col layout */
        .layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            align-items: start;
        }

        /* Input card */
        .input-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 20px;
            overflow: hidden;
            animation: fadeUp 0.5s 0.1s ease forwards;
            opacity: 0;
            position: relative;
        }

        .input-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--accent), var(--accent2), transparent);
        }

        .card-head {
            padding: 28px 32px 20px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .card-title {
            font-family: 'Syne', sans-serif;
            font-size: 17px;
            font-weight: 700;
        }

        .card-badge {
            font-size: 10px;
            padding: 3px 10px;
            border-radius: 99px;
            background: rgba(99,179,237,0.1);
            color: var(--accent);
            border: 1px solid rgba(99,179,237,0.2);
            letter-spacing: 0.06em;
            text-transform: uppercase;
        }

        .card-body { padding: 28px 32px; }

        /* Tab selector */
        .tabs {
            display: flex;
            gap: 4px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 4px;
            margin-bottom: 24px;
        }

        .tab {
            flex: 1;
            padding: 8px;
            border-radius: 7px;
            border: none;
            background: transparent;
            color: var(--muted);
            font-family: 'DM Sans', sans-serif;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
        }

        .tab.active {
            background: var(--surface3);
            color: var(--text);
            border: 1px solid var(--border);
        }

        /* Input panels */
        .input-panel { display: none; }
        .input-panel.active { display: block; }

        .field-label {
            font-size: 11px;
            font-weight: 500;
            letter-spacing: 0.07em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 8px;
            display: block;
        }

        .form-textarea {
            width: 100%;
            padding: 16px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 12px;
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            line-height: 1.6;
            resize: vertical;
            min-height: 140px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-textarea::placeholder { color: #2d3a52; }
        .form-textarea:focus {
            border-color: var(--border-active);
            box-shadow: 0 0 0 3px var(--glow);
        }

        .form-input {
            width: 100%;
            padding: 13px 16px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 12px;
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-input::placeholder { color: #2d3a52; }
        .form-input:focus {
            border-color: var(--border-active);
            box-shadow: 0 0 0 3px var(--glow);
        }

        /* File upload zone */
        .upload-zone {
            border: 2px dashed var(--border);
            border-radius: 12px;
            padding: 36px 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
            position: relative;
        }

        .upload-zone:hover, .upload-zone.drag-over {
            border-color: rgba(99,179,237,0.4);
            background: rgba(99,179,237,0.03);
        }

        .upload-zone input {
            position: absolute;
            inset: 0;
            opacity: 0;
            cursor: pointer;
            width: 100%;
            height: 100%;
        }

        .upload-icon { font-size: 32px; margin-bottom: 10px; }
        .upload-title { font-size: 14px; font-weight: 500; margin-bottom: 4px; }
        .upload-sub { font-size: 12px; color: var(--muted); }

        /* Keyword tags */
        .keyword-info {
            margin-top: 20px;
            padding: 16px;
            background: rgba(246,173,85,0.05);
            border: 1px solid rgba(246,173,85,0.1);
            border-radius: 10px;
        }

        .keyword-title {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--warning);
            margin-bottom: 10px;
        }

        .keyword-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .keyword-tag {
            padding: 3px 10px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 500;
        }

        .tag-bad { background: rgba(252,129,129,0.1); color: var(--danger); border: 1px solid rgba(252,129,129,0.2); }
        .tag-good { background: rgba(104,211,145,0.1); color: var(--success); border: 1px solid rgba(104,211,145,0.2); }

        /* Submit button */
        .btn-submit {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border: none;
            border-radius: 12px;
            color: #07090f;
            font-family: 'Syne', sans-serif;
            font-size: 14px;
            font-weight: 700;
            letter-spacing: 0.04em;
            cursor: pointer;
            margin-top: 20px;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 28px rgba(99,179,237,0.3);
        }

        /* ===== RESULT CARD ===== */
        .result-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 20px;
            overflow: hidden;
            animation: fadeUp 0.5s 0.15s ease forwards;
            opacity: 0;
            position: relative;
        }

        <% if (hasResult) { %>
        .result-card {
            border-color: <%= trustScore >= 75 ? "rgba(104,211,145,0.25)" : "rgba(252,129,129,0.25)" %>;
        }
        <% } %>

        .result-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: <%= hasResult ? (trustScore >= 75 ? "linear-gradient(90deg, transparent, #68d391, transparent)" : "linear-gradient(90deg, transparent, #fc8181, transparent)") : "linear-gradient(90deg, transparent, var(--border), transparent)" %>;
        }

        /* Score display */
        .score-display {
            padding: 36px 32px;
            text-align: center;
            border-bottom: 1px solid var(--border);
            position: relative;
        }

        /* Circular progress */
        .score-ring-wrap {
            position: relative;
            width: 140px;
            height: 140px;
            margin: 0 auto 20px;
        }

        .score-ring {
            transform: rotate(-90deg);
        }

        .score-ring-bg {
            fill: none;
            stroke: var(--surface2);
            stroke-width: 8;
        }

        .score-ring-fill {
            fill: none;
            stroke-width: 8;
            stroke-linecap: round;
            transition: stroke-dashoffset 1.5s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .score-ring-fill.safe {
            stroke: url(#safe-gradient);
        }

        .score-ring-fill.fraud {
            stroke: url(#fraud-gradient);
        }

        .score-center {
            position: absolute;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
        }

        .score-number {
            font-family: 'Syne', sans-serif;
            font-size: 32px;
            font-weight: 800;
            line-height: 1;
        }

        .score-number.safe { color: var(--success); }
        .score-number.fraud { color: var(--danger); }

        .score-unit {
            font-size: 12px;
            color: var(--muted);
        }

        .verdict-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 20px;
            border-radius: 99px;
            font-family: 'Syne', sans-serif;
            font-size: 14px;
            font-weight: 700;
            letter-spacing: 0.06em;
        }

        .verdict-badge.safe {
            background: rgba(104,211,145,0.1);
            border: 1px solid rgba(104,211,145,0.3);
            color: var(--success);
        }

        .verdict-badge.fraud {
            background: rgba(252,129,129,0.1);
            border: 1px solid rgba(252,129,129,0.3);
            color: var(--danger);
        }

        /* Result details */
        .result-details { padding: 28px 32px; }

        .detail-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 0;
            border-bottom: 1px solid var(--border);
        }

        .detail-row:last-child { border-bottom: none; }

        .detail-key {
            font-size: 12px;
            color: var(--muted);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .detail-val {
            font-size: 13px;
            font-weight: 500;
        }

        .detail-val.safe { color: var(--success); }
        .detail-val.fraud { color: var(--danger); }
        .detail-val.warn { color: var(--warning); }

        /* Score bar */
        .score-bar-wrap {
            margin-top: 4px;
        }

        .score-bar-bg {
            width: 100%;
            height: 6px;
            background: var(--surface2);
            border-radius: 99px;
            overflow: hidden;
            margin-top: 8px;
        }

        .score-bar-fill {
            height: 100%;
            border-radius: 99px;
            transition: width 1s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .score-bar-fill.safe { background: linear-gradient(90deg, var(--success), #9ae6b4); }
        .score-bar-fill.fraud { background: linear-gradient(90deg, var(--danger), #feb2b2); }

        /* Alert box */
        .alert-box {
            margin: 0 32px 28px;
            padding: 16px 20px;
            border-radius: 12px;
        }

        .alert-box.fraud-alert {
            background: rgba(252,129,129,0.06);
            border: 1px solid rgba(252,129,129,0.2);
        }

        .alert-box.safe-alert {
            background: rgba(104,211,145,0.06);
            border: 1px solid rgba(104,211,145,0.2);
        }

        .alert-title {
            font-family: 'Syne', sans-serif;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .alert-box.fraud-alert .alert-title { color: var(--danger); }
        .alert-box.safe-alert .alert-title { color: var(--success); }

        .alert-body { font-size: 12px; color: var(--muted); line-height: 1.6; }

        /* Report button */
        .report-section {
            padding: 0 32px 28px;
        }

        .btn-report {
            width: 100%;
            padding: 13px;
            background: rgba(252,129,129,0.08);
            border: 1px solid rgba(252,129,129,0.25);
            border-radius: 10px;
            color: var(--danger);
            font-family: 'Syne', sans-serif;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-align: center;
        }

        .btn-report:hover {
            background: rgba(252,129,129,0.14);
            border-color: rgba(252,129,129,0.5);
        }

        /* Scheme suggestions */
        .suggestions {
            margin: 0 32px 28px;
        }

        .suggest-title {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 12px;
        }

        .suggest-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 10px;
            margin-bottom: 8px;
        }

        .suggest-icon {
            width: 32px; height: 32px;
            border-radius: 8px;
            background: rgba(99,179,237,0.1);
            display: flex; align-items: center; justify-content: center;
            font-size: 14px;
            flex-shrink: 0;
        }

        .suggest-name { font-size: 13px; font-weight: 500; }
        .suggest-tag { font-size: 11px; color: var(--success); }

        /* Empty state */
        .empty-state {
            padding: 60px 32px;
            text-align: center;
        }

        .empty-icon {
            width: 80px; height: 80px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 32px;
            margin: 0 auto 20px;
        }

        .empty-title {
            font-family: 'Syne', sans-serif;
            font-size: 17px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .empty-sub { font-size: 13px; color: var(--muted); line-height: 1.6; }

        /* How it works */
        .how-it-works {
            margin-top: 24px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 24px 28px;
            animation: fadeUp 0.5s 0.2s ease forwards;
            opacity: 0;
        }

        .hiw-title {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 16px;
        }

        .hiw-steps {
            display: flex;
            gap: 0;
        }

        .hiw-step {
            flex: 1;
            text-align: center;
            position: relative;
        }

        .hiw-step:not(:last-child)::after {
            content: '→';
            position: absolute;
            right: -8px;
            top: 14px;
            color: var(--border);
            font-size: 14px;
        }

        .hiw-num {
            width: 32px; height: 32px;
            border-radius: 50%;
            background: var(--surface2);
            border: 1px solid var(--border);
            display: flex; align-items: center; justify-content: center;
            font-size: 12px;
            font-weight: 600;
            color: var(--accent);
            margin: 0 auto 8px;
        }

        .hiw-label { font-size: 11px; color: var(--muted); line-height: 1.4; }

        @media (max-width: 900px) {
            .layout { grid-template-columns: 1fr; }
            .nav-links { display: none; }
            .card-body, .card-head { padding: 20px; }
            .score-display { padding: 24px 20px; }
            .result-details, .report-section, .alert-box, .suggestions { padding-left: 20px; padding-right: 20px; }
        }
    </style>
</head>
<body>
    <div class="blob blob-1"></div>
    <div class="blob blob-2"></div>

    <!-- Navbar -->
    <nav class="navbar">
        <div class="nav-left">
            <a href="index.jsp" class="logo-wrap">
                <div class="logo-icon">🛡️</div>
                <div class="logo-text">Digital<span>Trust</span></div>
            </a>
            <div class="nav-links">
                <a href="index.jsp" class="nav-link">Dashboard</a>
                <a href="check_scheme.jsp" class="nav-link active">Analyze Scheme</a>
            </div>
        </div>
        <div class="nav-right">
            <div class="user-chip">
                <div class="user-avatar"><%= userName.substring(0,1).toUpperCase() %></div>
                <span class="user-name"><%= userName %></span>
            </div>
            <a href="index.jsp" class="btn-back">← Dashboard</a>
        </div>
    </nav>

    <main class="main">
        <!-- Page header -->
        <div class="page-header">
            <div class="page-eyebrow">AI-Powered Analysis</div>
            <h1 class="page-title">Scheme Authenticity Checker</h1>
            <p class="page-sub">Submit a message, URL, or document to get an instant Trust Score and eligibility check</p>
        </div>

        <div class="layout">
            <!-- Input Card -->
            <div class="input-card">
                <div class="card-head">
                    <div class="card-title">Submit for Analysis</div>
                    <div class="card-badge">NLP Engine</div>
                </div>
                <div class="card-body">
                    <form action="AnalyzeSchemeServlet" method="post" enctype="multipart/form-data" id="analyzeForm">

                        <!-- Tabs -->
                        <div class="tabs">
                            <button type="button" class="tab active" onclick="switchTab('message', this)">📝 Message</button>
                            <button type="button" class="tab" onclick="switchTab('url', this)">🔗 URL</button>
                            <button type="button" class="tab" onclick="switchTab('file', this)">📄 File</button>
                        </div>

                        <!-- Message panel -->
                        <div class="input-panel active" id="panel-message">
                            <label class="field-label">Paste SMS / WhatsApp / Email Text</label>
                            <textarea name="message" class="form-textarea" placeholder="Paste the suspicious message here...&#10;&#10;e.g. 'Congratulations! You have won a lottery of Rs 5,00,000. Click here to verify and claim your prize immediately...'"></textarea>
                        </div>

                        <!-- URL panel -->
                        <div class="input-panel" id="panel-url">
                            <label class="field-label">Paste Suspicious Link / URL</label>
                            <input type="url" name="url" class="form-input" placeholder="https://suspicious-site.com/claim-prize">
                            <div style="margin-top: 12px; font-size: 12px; color: var(--muted); line-height: 1.6;">
                                The system checks whether the domain is an official <span style="color:var(--success)">gov.in</span> site or a suspicious non-government URL.
                            </div>
                        </div>

                        <!-- File panel -->
                        <div class="input-panel" id="panel-file">
                            <label class="field-label">Upload Scheme Document (.txt)</label>
                            <div class="upload-zone" id="uploadZone">
                                <input type="file" name="text_file" accept=".txt" onchange="handleFileSelect(this)">
                                <div class="upload-icon">📂</div>
                                <div class="upload-title" id="upload-title">Drop your .txt file here</div>
                                <div class="upload-sub">or click to browse · Max 16MB</div>
                            </div>
                        </div>

                        <!-- Keyword info -->
                        <div class="keyword-info">
                            <div class="keyword-title">⚠ Fraud Trigger Keywords</div>
                            <div class="keyword-tags">
                                <span class="keyword-tag tag-bad">lottery</span>
                                <span class="keyword-tag tag-bad">won</span>
                                <span class="keyword-tag tag-bad">free</span>
                                <span class="keyword-tag tag-bad">urgent</span>
                                <span class="keyword-tag tag-bad">click here</span>
                                <span class="keyword-tag tag-bad">verify bank</span>
                                <span class="keyword-tag tag-bad">pay fee</span>
                                <span class="keyword-tag tag-good">.gov.in ✓</span>
                            </div>
                        </div>

                        <button type="submit" class="btn-submit">
                            <span>🔍</span>
                            <span>Analyze Now</span>
                        </button>
                    </form>
                </div>
            </div>

            <!-- Result / Empty card -->
            <div class="result-card">
                <% if (hasResult) { %>
                <!-- Result header -->
                <div class="score-display">
                    <div class="score-ring-wrap">
                        <svg class="score-ring" width="140" height="140" viewBox="0 0 140 140">
                            <defs>
                                <linearGradient id="safe-gradient" x1="0%" y1="0%" x2="100%" y2="0%">
                                    <stop offset="0%" style="stop-color:#68d391"/>
                                    <stop offset="100%" style="stop-color:#9ae6b4"/>
                                </linearGradient>
                                <linearGradient id="fraud-gradient" x1="0%" y1="0%" x2="100%" y2="0%">
                                    <stop offset="0%" style="stop-color:#fc8181"/>
                                    <stop offset="100%" style="stop-color:#feb2b2"/>
                                </linearGradient>
                            </defs>
                            <circle class="score-ring-bg" cx="70" cy="70" r="57"/>
                            <circle class="score-ring-fill <%= trustScore >= 75 ? "safe" : "fraud" %>"
                                cx="70" cy="70" r="57"
                                stroke-dasharray="358"
                                stroke-dashoffset="<%= (int)(358 - (358.0 * trustScore / 100)) %>"
                                id="ringFill"/>
                        </svg>
                        <div class="score-center">
                            <div class="score-number <%= trustScore >= 75 ? "safe" : "fraud" %>">
                                <%= trustScore %>
                            </div>
                            <div class="score-unit">/ 100</div>
                        </div>
                    </div>

                    <div class="verdict-badge <%= trustScore >= 75 ? "safe" : "fraud" %>">
                        <span><%= trustScore >= 75 ? "✓" : "✗" %></span>
                        <span><%= isGenuine %></span>
                    </div>

                    <div style="font-size: 12px; color: var(--muted); margin-top: 10px;">
                        Trust Score · NLP Analysis Complete
                    </div>
                </div>

                <!-- Score breakdown -->
                <div class="result-details">
                    <div class="detail-row">
                        <span class="detail-key">📊 Trust Score</span>
                        <div style="display:flex; align-items:center; gap:12px;">
                            <div class="score-bar-bg" style="width:120px">
                                <div class="score-bar-fill <%= trustScore >= 75 ? "safe" : "fraud" %>" style="width:<%= trustScore %>%"></div>
                            </div>
                            <span class="detail-val <%= trustScore >= 75 ? "safe" : "fraud" %>"><%= trustScore %>%</span>
                        </div>
                    </div>
                    <div class="detail-row">
                        <span class="detail-key">🏷️ Verdict</span>
                        <span class="detail-val <%= trustScore >= 75 ? "safe" : "fraud" %>">
                            <%= trustScore >= 75 ? "✓ Genuine Scheme" : "⚠ Possible Fraud" %>
                        </span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-key">👤 Profile Match</span>
                        <span class="detail-val <%= "Yes".equals(profileMatch) ? "safe" : "warn" %>">
                            <%= "Yes".equals(profileMatch) ? "✓ You are eligible" : "✗ Profile mismatch" %>
                        </span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-key">🔒 Threshold</span>
                        <span class="detail-val" style="color:var(--muted)">Safe ≥ 75 · Fraud &lt; 75</span>
                    </div>
                </div>

                <% if (trustScore < 75) { %>
                <!-- Fraud alert -->
                <div class="alert-box fraud-alert">
                    <div class="alert-title">⚠ High Fraud Risk Detected</div>
                    <div class="alert-body">This content exhibits multiple red flags associated with known scam patterns. Do not share personal information, click any links, or make any payments.</div>
                </div>
                <div class="report-section">
                    <form action="SubmitGrievanceServlet" method="post">
                        <input type="hidden" name="scam_details" value="Fraudulent scheme reported via Digital Trust System">
                        <button type="submit" class="btn-report">
                            🏛️ Submit Official Grievance to Government Portal
                        </button>
                    </form>
                </div>
                <% } else { %>
                <!-- Safe alert -->
                <div class="alert-box safe-alert">
                    <div class="alert-title">✓ Scheme Verified as Genuine</div>
                    <div class="alert-body">This content passes security checks. It appears to be a legitimate government scheme.</div>
                </div>
                <% if ("Yes".equals(profileMatch)) { %>
                <div class="suggestions">
                    <div class="suggest-title">✓ You are eligible for this scheme</div>
                    <div class="suggest-item">
                        <div class="suggest-icon">🌾</div>
                        <div>
                            <div class="suggest-name">PM Kisan Samman Nidhi</div>
                            <div class="suggest-tag">✓ Matches your income bracket</div>
                        </div>
                    </div>
                </div>
                <% } else { %>
                <div class="suggestions">
                    <div class="suggest-title">Schemes matching your profile:</div>
                    <div class="suggest-item">
                        <div class="suggest-icon">🌾</div>
                        <div>
                            <div class="suggest-name">PM Kisan Samman Nidhi</div>
                            <div class="suggest-tag">Matches your income bracket</div>
                        </div>
                    </div>
                    <div class="suggest-item">
                        <div class="suggest-icon">📚</div>
                        <div>
                            <div class="suggest-name">State Youth Scholarship Program</div>
                            <div class="suggest-tag">Matches your age group</div>
                        </div>
                    </div>
                </div>
                <% } %>
                <% } %>

                <% } else { %>
                <!-- Empty state -->
                <div class="empty-state">
                    <div class="empty-icon">🔍</div>
                    <div class="empty-title">No analysis yet</div>
                    <div class="empty-sub">Submit a scheme message, URL, or upload a document on the left to get an instant Trust Score and eligibility check.</div>
                </div>
                <% } %>
            </div>
        </div>

        <!-- How it works -->
        <div class="how-it-works">
            <div class="hiw-title">How the analysis works</div>
            <div class="hiw-steps">
                <div class="hiw-step">
                    <div class="hiw-num">1</div>
                    <div class="hiw-label">Submit text, URL or file</div>
                </div>
                <div class="hiw-step">
                    <div class="hiw-num">2</div>
                    <div class="hiw-label">NLP keyword scan runs</div>
                </div>
                <div class="hiw-step">
                    <div class="hiw-num">3</div>
                    <div class="hiw-label">Domain verification check</div>
                </div>
                <div class="hiw-step">
                    <div class="hiw-num">4</div>
                    <div class="hiw-label">Trust Score (0–100) generated</div>
                </div>
                <div class="hiw-step">
                    <div class="hiw-num">5</div>
                    <div class="hiw-label">Profile eligibility matched</div>
                </div>
            </div>
        </div>
    </main>

    <script>
        function switchTab(tab, btn) {
            document.querySelectorAll('.input-panel').forEach(p => p.classList.remove('active'));
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.getElementById('panel-' + tab).classList.add('active');
            btn.classList.add('active');
        }

        function handleFileSelect(input) {
            if (input.files.length > 0) {
                document.getElementById('upload-title').textContent = '📄 ' + input.files[0].name;
            }
        }

        const zone = document.getElementById('uploadZone');
        if (zone) {
            zone.addEventListener('dragover', e => { e.preventDefault(); zone.classList.add('drag-over'); });
            zone.addEventListener('dragleave', () => zone.classList.remove('drag-over'));
            zone.addEventListener('drop', e => { e.preventDefault(); zone.classList.remove('drag-over'); });
        }

        // Animate ring on load
        window.addEventListener('load', () => {
            const fill = document.getElementById('ringFill');
            if (fill) {
                const target = fill.getAttribute('stroke-dashoffset');
                fill.style.strokeDashoffset = '358';
                setTimeout(() => {
                    fill.style.transition = 'stroke-dashoffset 1.5s cubic-bezier(0.4, 0, 0.2, 1)';
                    fill.style.strokeDashoffset = target;
                }, 200);
            }
        });
    </script>
</body>
</html>
