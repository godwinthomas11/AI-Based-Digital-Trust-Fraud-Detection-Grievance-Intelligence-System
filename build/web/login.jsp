<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In — Digital Trust System</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:ital,wght@0,300;0,400;0,500;1,300&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #07090f;
            --surface: #0e1117;
            --surface2: #151b26;
            --border: rgba(255,255,255,0.07);
            --border-active: rgba(99,179,237,0.5);
            --accent: #63b3ed;
            --accent2: #4fd1c5;
            --text: #e8edf5;
            --muted: #6b7a99;
            --danger: #fc8181;
            --success: #68d391;
            --glow: rgba(99,179,237,0.15);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            position: relative;
        }

        /* Animated background grid */
        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background-image:
                linear-gradient(rgba(99,179,237,0.03) 1px, transparent 1px),
                linear-gradient(90deg, rgba(99,179,237,0.03) 1px, transparent 1px);
            background-size: 60px 60px;
            animation: gridMove 20s linear infinite;
            pointer-events: none;
        }

        @keyframes gridMove {
            0% { transform: translateY(0); }
            100% { transform: translateY(60px); }
        }

        /* Ambient glow blobs */
        .blob {
            position: fixed;
            border-radius: 50%;
            filter: blur(120px);
            pointer-events: none;
            animation: blobFloat 8s ease-in-out infinite;
        }
        .blob-1 {
            width: 500px; height: 500px;
            background: rgba(99,179,237,0.08);
            top: -150px; right: -100px;
            animation-delay: 0s;
        }
        .blob-2 {
            width: 400px; height: 400px;
            background: rgba(79,209,197,0.06);
            bottom: -100px; left: -100px;
            animation-delay: -4s;
        }

        @keyframes blobFloat {
            0%, 100% { transform: translateY(0) scale(1); }
            50% { transform: translateY(-30px) scale(1.05); }
        }

        .page-wrap {
            display: flex;
            width: 100%;
            max-width: 1000px;
            min-height: 580px;
            margin: 20px;
            position: relative;
            z-index: 1;
            animation: fadeUp 0.6s ease forwards;
            opacity: 0;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(24px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Left branding panel */
        .brand-panel {
            flex: 1;
            background: linear-gradient(145deg, #0d1829 0%, #0a1220 100%);
            border: 1px solid var(--border);
            border-right: none;
            border-radius: 20px 0 0 20px;
            padding: 56px 48px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }

        .brand-panel::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--accent), var(--accent2), transparent);
        }

        .brand-panel::after {
            content: '';
            position: absolute;
            bottom: -60px; right: -60px;
            width: 250px; height: 250px;
            border: 1px solid rgba(99,179,237,0.08);
            border-radius: 50%;
            box-shadow: 0 0 0 50px rgba(99,179,237,0.03), 0 0 0 100px rgba(99,179,237,0.015);
        }

        .brand-logo {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .logo-icon {
            width: 40px; height: 40px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .logo-text {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 16px;
            letter-spacing: 0.02em;
            color: var(--text);
        }
        .logo-text span { color: var(--accent); }

        .brand-headline {
            font-family: 'Syne', sans-serif;
            font-size: 32px;
            font-weight: 800;
            line-height: 1.2;
            color: var(--text);
            margin-bottom: 16px;
        }
        .brand-headline em {
            font-style: normal;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .brand-desc {
            font-size: 14px;
            line-height: 1.7;
            color: var(--muted);
        }

        .brand-stats {
            display: flex;
            gap: 28px;
            margin-top: 40px;
        }

        .stat {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .stat-num {
            font-family: 'Syne', sans-serif;
            font-size: 22px;
            font-weight: 700;
            color: var(--accent);
        }

        .stat-label {
            font-size: 11px;
            color: var(--muted);
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .trust-badges {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .badge-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 14px;
            background: rgba(99,179,237,0.05);
            border: 1px solid rgba(99,179,237,0.1);
            border-radius: 8px;
            font-size: 12px;
            color: var(--muted);
        }

        .badge-dot {
            width: 6px; height: 6px;
            border-radius: 50%;
            background: var(--success);
            flex-shrink: 0;
            box-shadow: 0 0 6px var(--success);
        }

        /* Right form panel */
        .form-panel {
            width: 420px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 0 20px 20px 0;
            padding: 56px 48px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-title {
            font-family: 'Syne', sans-serif;
            font-size: 26px;
            font-weight: 700;
            color: var(--text);
            margin-bottom: 6px;
        }

        .form-sub {
            font-size: 14px;
            color: var(--muted);
            margin-bottom: 36px;
        }

        .field-group {
            margin-bottom: 20px;
        }

        .field-label {
            display: block;
            font-size: 12px;
            font-weight: 500;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 8px;
        }

        .field-wrap {
            position: relative;
        }

        .field-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--muted);
            font-size: 15px;
            pointer-events: none;
            transition: color 0.2s;
        }

        .form-input {
            width: 100%;
            padding: 13px 14px 13px 42px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 10px;
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            transition: border-color 0.2s, box-shadow 0.2s;
            outline: none;
        }

        .form-input::placeholder { color: #3a4560; }

        .form-input:focus {
            border-color: var(--border-active);
            box-shadow: 0 0 0 3px var(--glow);
        }

        .form-input:focus ~ .field-icon,
        .field-wrap:focus-within .field-icon {
            color: var(--accent);
        }

        .forgot-link {
            display: block;
            text-align: right;
            font-size: 12px;
            color: var(--muted);
            text-decoration: none;
            margin-top: 6px;
            transition: color 0.2s;
        }
        .forgot-link:hover { color: var(--accent); }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border: none;
            border-radius: 10px;
            color: #07090f;
            font-family: 'Syne', sans-serif;
            font-size: 14px;
            font-weight: 700;
            letter-spacing: 0.04em;
            cursor: pointer;
            margin-top: 28px;
            position: relative;
            overflow: hidden;
            transition: opacity 0.2s, transform 0.15s, box-shadow 0.2s;
        }

        .btn-submit:hover {
            opacity: 0.92;
            transform: translateY(-1px);
            box-shadow: 0 8px 24px rgba(99,179,237,0.3);
        }

        .btn-submit:active { transform: translateY(0); }

        .btn-submit::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.15), transparent);
            opacity: 0;
            transition: opacity 0.2s;
        }
        .btn-submit:hover::after { opacity: 1; }

        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 28px 0 20px;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--border);
        }
        .divider span {
            font-size: 11px;
            color: var(--muted);
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .register-link {
            text-align: center;
            font-size: 13px;
            color: var(--muted);
        }

        .register-link a {
            color: var(--accent);
            text-decoration: none;
            font-weight: 500;
            margin-left: 4px;
            transition: color 0.2s;
        }
        .register-link a:hover { color: var(--accent2); }

        /* Gov badge */
        .gov-badge {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 32px;
            padding: 10px 14px;
            background: rgba(104,211,145,0.05);
            border: 1px solid rgba(104,211,145,0.15);
            border-radius: 8px;
            font-size: 11px;
            color: #68d391;
            letter-spacing: 0.04em;
        }

        @media (max-width: 768px) {
            .page-wrap { flex-direction: column; margin: 16px; }
            .brand-panel { border-radius: 20px 20px 0 0; border-right: 1px solid var(--border); border-bottom: none; padding: 36px 28px; }
            .form-panel { width: 100%; border-radius: 0 0 20px 20px; padding: 36px 28px; }
            .brand-stats { display: none; }
        }
    </style>
</head>
<body>
    <div class="blob blob-1"></div>
    <div class="blob blob-2"></div>

    <div class="page-wrap">
        <!-- Brand Panel -->
        <div class="brand-panel">
            <div>
                <div class="brand-logo">
                    <div class="logo-icon">🛡️</div>
                    <div class="logo-text">Digital<span>Trust</span></div>
                </div>

                <div style="margin-top: 48px;">
                    <div class="brand-headline">
                        Protect yourself from<br><em>scheme fraud.</em>
                    </div>
                    <div class="brand-desc">
                        AI-powered verification system that analyzes government scheme messages, detects fraud in real-time, and matches genuine schemes to your profile.
                    </div>

                    <div class="brand-stats">
                        <div class="stat">
                            <div class="stat-num">98.4%</div>
                            <div class="stat-label">Accuracy</div>
                        </div>
                        <div class="stat">
                            <div class="stat-num">2.3M+</div>
                            <div class="stat-label">Scans done</div>
                        </div>
                        <div class="stat">
                            <div class="stat-num">₹47Cr</div>
                            <div class="stat-label">Fraud blocked</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="trust-badges">
                <div class="badge-item">
                    <div class="badge-dot"></div>
                    NLP Keyword Detection Engine active
                </div>
                <div class="badge-item">
                    <div class="badge-dot"></div>
                    GOV.IN Domain Verification live
                </div>
                <div class="badge-item">
                    <div class="badge-dot"></div>
                    Grievance Portal connected
                </div>
            </div>
        </div>

        <!-- Form Panel -->
        <div class="form-panel">
            <div class="form-title">Welcome back</div>
            <div class="form-sub">Sign in to access your dashboard</div>

            <form action="LoginServlet" method="post">
                <div class="field-group">
                    <label class="field-label" for="email">Email Address</label>
                    <div class="field-wrap">
                        <span class="field-icon">✉</span>
                        <input type="email" id="email" name="email" class="form-input" placeholder="you@example.com" required>
                    </div>
                </div>

                <div class="field-group">
                    <label class="field-label" for="password">Password</label>
                    <div class="field-wrap">
                        <span class="field-icon">🔒</span>
                        <input type="password" id="password" name="password" class="form-input" placeholder="••••••••••" required>
                    </div>
                </div>

                <button type="submit" class="btn-submit">Sign In to Dashboard →</button>
            </form>

            <div class="divider"><span>New here?</span></div>

            <div class="register-link">
                Don't have an account?
                <a href="register.jsp">Create one now</a>
            </div>

            <div class="gov-badge">
                <span>🏛️</span>
                Authorized Digital India Initiative — Ministry of Electronics & IT
            </div>
        </div>
    </div>
</body>
</html>
