<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Digital Trust System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { background-color: #141e30; }
        .hero-section { background: linear-gradient(135deg, #141e30, #243b55); color: white; padding: 60px 0; border-radius: 0 0 20px 20px; }
        .feature-card { border: none; border-radius: 12px; transition: transform 0.2s; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .feature-card:hover { transform: translateY(-5px); }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">Digital Trust System</a>
            <div class="d-flex">
                <span class="navbar-text me-3 text-light">Welcome, <%= session.getAttribute("user") %></span>
                <a href="login.jsp" class="btn btn-outline-danger btn-sm">Logout</a>
            </div>
        </div>
    </nav>

    <div class="hero-section text-center mb-5">
        <div class="container">
            <h1 class="display-5 fw-bold mb-3">Protecting You from Government Scheme Fraud</h1>
            <p class="lead w-75 mx-auto">Our Machine Learning powered system analyzes messages, links, and documents to determine the authenticity of government schemes. We calculate a precise Trust Score and match schemes to your specific demographic profile.</p>
            <a href="check_scheme.jsp" class="btn btn-lg btn-info text-white mt-4 px-5 rounded-pill shadow">Check Scheme Authenticity</a>
        </div>
    </div>

    <div class="container mb-5">
        <div class="row g-4">
            <div class="col-md-3">
                <div class="card feature-card h-100 p-3 text-center">
                    <h5 class="fw-bold mt-2">Fraud Keyword Detection</h5>
                    <p class="text-muted small">NLP algorithms scan text for urgent triggers and known scam terminologies.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card feature-card h-100 p-3 text-center">
                    <h5 class="fw-bold mt-2">URL Verification</h5>
                    <p class="text-muted small">Cross-references links against official GOV databases and blacklists.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card feature-card h-100 p-3 text-center">
                    <h5 class="fw-bold mt-2">AI Trust Score</h5>
                    <p class="text-muted small">Generates a 0-100% confidence metric based on multi-layered analysis.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card feature-card h-100 p-3 text-center">
                    <h5 class="fw-bold mt-2">Profile Matching</h5>
                    <p class="text-muted small">Checks if genuine schemes fit your income, age, and marital status.</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>