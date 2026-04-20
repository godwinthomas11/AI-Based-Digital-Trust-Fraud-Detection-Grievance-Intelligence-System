<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Digital Trust System</title>
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
            --glow: rgba(99,179,237,0.12);
            --success: #68d391;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            padding: 32px 20px;
            position: relative;
        }

        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background-image:
                linear-gradient(rgba(99,179,237,0.025) 1px, transparent 1px),
                linear-gradient(90deg, rgba(99,179,237,0.025) 1px, transparent 1px);
            background-size: 60px 60px;
            animation: gridMove 20s linear infinite;
            pointer-events: none;
        }

        @keyframes gridMove {
            0% { transform: translateY(0); }
            100% { transform: translateY(60px); }
        }

        /* Top nav bar */
        .topbar {
            max-width: 900px;
            margin: 0 auto 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            animation: fadeDown 0.4s ease forwards;
            opacity: 0;
        }

        @keyframes fadeDown {
            from { opacity: 0; transform: translateY(-12px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .logo-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }

        .logo-icon {
            width: 36px; height: 36px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }

        .logo-text {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 15px;
            color: var(--text);
        }
        .logo-text span { color: var(--accent); }

        .login-pill {
            padding: 8px 18px;
            background: transparent;
            border: 1px solid var(--border);
            border-radius: 99px;
            color: var(--muted);
            text-decoration: none;
            font-size: 13px;
            transition: all 0.2s;
        }
        .login-pill:hover {
            border-color: var(--border-active);
            color: var(--accent);
        }

        /* Progress steps */
        .steps-wrap {
            max-width: 900px;
            margin: 0 auto 28px;
            display: flex;
            align-items: center;
            gap: 0;
            animation: fadeUp 0.5s 0.1s ease forwards;
            opacity: 0;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .step {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
            color: var(--muted);
            letter-spacing: 0.04em;
        }

        .step.active { color: var(--accent); }
        .step.done { color: var(--success); }

        .step-num {
            width: 24px; height: 24px;
            border-radius: 50%;
            border: 1px solid currentColor;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 600;
        }

        .step-line {
            flex: 1;
            height: 1px;
            background: var(--border);
            margin: 0 12px;
            min-width: 40px;
        }

        /* Main card */
        .card {
            max-width: 900px;
            margin: 0 auto;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 20px;
            overflow: hidden;
            position: relative;
            animation: fadeUp 0.5s 0.15s ease forwards;
            opacity: 0;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--accent), var(--accent2), transparent);
        }

        .card-header {
            padding: 36px 48px 28px;
            border-bottom: 1px solid var(--border);
        }

        .card-title {
            font-family: 'Syne', sans-serif;
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .card-sub {
            font-size: 13px;
            color: var(--muted);
        }

        .card-body {
            padding: 36px 48px;
        }

        /* Section dividers */
        .section-label {
            font-size: 10px;
            font-weight: 600;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: var(--accent);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .section-label::after {
            content: '';
            flex: 1;
            height: 1px;
            background: linear-gradient(90deg, rgba(99,179,237,0.3), transparent);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            margin-bottom: 28px;
        }

        .form-grid-3 {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 18px;
            margin-bottom: 28px;
        }

        .form-grid-full {
            margin-bottom: 28px;
        }

        .field-group { display: flex; flex-direction: column; }

        .field-label {
            font-size: 11px;
            font-weight: 500;
            letter-spacing: 0.07em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 8px;
        }

        .field-wrap { position: relative; }

        .field-icon {
            position: absolute;
            left: 13px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 14px;
            pointer-events: none;
            opacity: 0.5;
            transition: opacity 0.2s;
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 12px 14px 12px 40px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 10px;
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            transition: border-color 0.2s, box-shadow 0.2s;
            outline: none;
            -webkit-appearance: none;
        }

        .form-textarea {
            padding: 12px 14px 12px 40px;
            resize: vertical;
            min-height: 80px;
        }

        .form-input::placeholder, .form-textarea::placeholder { color: #2d3a52; }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            border-color: var(--border-active);
            box-shadow: 0 0 0 3px var(--glow);
        }

        .form-select {
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%236b7a99' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
            cursor: pointer;
        }

        .form-select option { background: var(--surface2); }

        /* Income range visual */
        .income-hint {
            font-size: 11px;
            color: var(--muted);
            margin-top: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .income-tag {
            padding: 2px 8px;
            border-radius: 4px;
            background: rgba(99,179,237,0.1);
            color: var(--accent);
            font-size: 10px;
            font-weight: 500;
        }

        /* Terms */
        .terms-wrap {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            padding: 16px 20px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 10px;
            margin-bottom: 24px;
        }

        .terms-check {
            width: 16px; height: 16px;
            accent-color: var(--accent);
            margin-top: 2px;
            flex-shrink: 0;
            cursor: pointer;
        }

        .terms-text {
            font-size: 12px;
            color: var(--muted);
            line-height: 1.6;
        }

        .terms-text a { color: var(--accent); text-decoration: none; }

        /* Action row */
        .action-row {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .btn-primary {
            flex: 1;
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
            transition: opacity 0.2s, transform 0.15s, box-shadow 0.2s;
            position: relative;
            overflow: hidden;
        }

        .btn-primary:hover {
            opacity: 0.9;
            transform: translateY(-1px);
            box-shadow: 0 8px 28px rgba(99,179,237,0.3);
        }

        .btn-secondary {
            padding: 14px 20px;
            background: transparent;
            border: 1px solid var(--border);
            border-radius: 10px;
            color: var(--muted);
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-secondary:hover {
            border-color: var(--border-active);
            color: var(--accent);
        }

        /* Data protection notice */
        .protection-bar {
            margin-top: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 20px;
            padding: 14px;
            border-top: 1px solid var(--border);
        }

        .protect-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 11px;
            color: var(--muted);
        }

        @media (max-width: 700px) {
            .form-grid, .form-grid-3 { grid-template-columns: 1fr; }
            .card-header, .card-body { padding: 24px 20px; }
            .steps-wrap { display: none; }
            .action-row { flex-direction: column-reverse; }
            .btn-secondary { width: 100%; text-align: center; }
            .protection-bar { flex-direction: column; gap: 10px; }
        }
    </style>
</head>
<body>
    <div class="topbar">
        <a href="login.jsp" class="logo-wrap">
            <div class="logo-icon">🛡️</div>
            <div class="logo-text">Digital<span>Trust</span></div>
        </a>
        <a href="login.jsp" class="login-pill">&larr; Back to Sign In</a>
    </div>

    <div class="steps-wrap">
        <div class="step active">
            <div class="step-num">1</div>
            Personal Details
        </div>
        <div class="step-line"></div>
        <div class="step">
            <div class="step-num">2</div>
            Verify Identity
        </div>
        <div class="step-line"></div>
        <div class="step">
            <div class="step-num">3</div>
            Access Dashboard
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <div class="card-title">Create your citizen profile</div>
            <div class="card-sub">Your profile enables personalized scheme matching based on eligibility criteria</div>
        </div>

        <div class="card-body">
            <form action="RegisterServlet" method="post">

                <!-- Personal Info -->
                <div class="section-label">Personal Information</div>
                <div class="form-grid">
                    <div class="field-group">
                        <label class="field-label">Full Name</label>
                        <div class="field-wrap">
                            <span class="field-icon">👤</span>
                            <input type="text" name="name" class="form-input" placeholder="As per Aadhaar card" required>
                        </div>
                    </div>
                    <div class="field-group">
                        <label class="field-label">Email Address</label>
                        <div class="field-wrap">
                            <span class="field-icon">✉</span>
                            <input type="email" name="email" class="form-input" placeholder="you@example.com" required>
                        </div>
                    </div>
                    <div class="field-group">
                        <label class="field-label">Password</label>
                        <div class="field-wrap">
                            <span class="field-icon">🔒</span>
                            <input type="password" name="password" class="form-input" placeholder="Minimum 8 characters" required>
                        </div>
                    </div>
                    <div class="field-group">
                        <label class="field-label">Age</label>
                        <div class="field-wrap">
                            <span class="field-icon">🎂</span>
                            <input type="number" name="age" class="form-input" placeholder="Your current age" min="18" max="100" required>
                        </div>
                    </div>
                </div>

                <!-- Address -->
                <div class="section-label">Residential Address</div>
                <div class="form-grid-full">
                    <div class="field-group">
                        <label class="field-label">Full Address</label>
                        <div class="field-wrap">
                            <span class="field-icon" style="top: 20px; transform: none;">📍</span>
                            <textarea name="address" class="form-textarea" rows="2" placeholder="House/Flat No., Street, City, State, PIN" required></textarea>
                        </div>
                    </div>
                </div>

                <!-- Demographics -->
                <div class="section-label">Demographic Profile</div>
                <div class="form-grid-3">
                    <div class="field-group">
                        <label class="field-label">Blood Group</label>
                        <div class="field-wrap">
                            <span class="field-icon">🩸</span>
                            <select name="blood_group" class="form-select" required>
                                <option value="" disabled selected>Select group</option>
                                <option value="A+">A+</option>
                                <option value="A-">A−</option>
                                <option value="B+">B+</option>
                                <option value="B-">B−</option>
                                <option value="O+">O+</option>
                                <option value="O-">O−</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB−</option>
                            </select>
                        </div>
                    </div>
                    <div class="field-group">
                        <label class="field-label">Marital Status</label>
                        <div class="field-wrap">
                            <span class="field-icon">💍</span>
                            <select name="marital_status" class="form-select" required>
                                <option value="" disabled selected>Select status</option>
                                <option value="Single">Single</option>
                                <option value="Married">Married</option>
                            </select>
                        </div>
                    </div>
                    <div class="field-group">
                        <label class="field-label">Annual Income (₹)</label>
                        <div class="field-wrap">
                            <span class="field-icon">₹</span>
                            <input type="number" name="income" class="form-input" placeholder="e.g. 500000" required>
                        </div>
                        <div class="income-hint">
                            <span>Schemes available for</span>
                            <span class="income-tag">≤ ₹8,00,000</span>
                        </div>
                    </div>
                </div>

                <!-- Terms -->
                <div class="terms-wrap">
                    <input type="checkbox" class="terms-check" id="terms" required>
                    <label for="terms" class="terms-text">
                        I consent to the secure storage of my profile data for scheme eligibility verification under the <a href="#">Digital India Data Protection Policy</a>. Your data is encrypted and never shared with third parties.
                    </label>
                </div>

                <!-- Actions -->
                <div class="action-row">
                    <a href="login.jsp" class="btn-secondary">Cancel</a>
                    <button type="submit" class="btn-primary">Create Profile & Continue &rarr;</button>
                </div>

            </form>

            <div class="protection-bar">
                <div class="protect-item">🔐 256-bit SSL Encryption</div>
                <div class="protect-item">Profile used for eligibility checks</div>
                <div class="protect-item">Passwords stored with hashing</div>
            </div>
        </div>
    </div>

</body>
</html>
