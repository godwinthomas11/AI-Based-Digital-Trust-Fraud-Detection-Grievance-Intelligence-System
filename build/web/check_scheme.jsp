<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Mock attributes for demonstration. These would be set by your ML Servlet.
    String trustScoreStr = (String) request.getAttribute("trustScore");
    String isGenuine = (String) request.getAttribute("isGenuine");
    String profileMatch = (String) request.getAttribute("profileMatch");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Check Scheme - Digital Trust System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { background-color: #141e30; }
        .analysis-card { border: none; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .score-circle { width: 120px; height: 120px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2rem; font-weight: bold; margin: 0 auto; color: white; }
        .score-high { background-color: #198754; }
        .score-low { background-color: #dc3545; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">Digital Trust System</a>
            <a href="index.jsp" class="btn btn-outline-light btn-sm">Back to Dashboard</a>
        </div>
    </nav>

    <div class="container">
        <div class="row">
            <div class="col-md-6 mb-4">
                <div class="card analysis-card p-4">
                    <h4 class="mb-4 fw-bold text-secondary">Submit Scheme for Analysis</h4>
                    <form action="AnalyzeSchemeServlet" method="post" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Paste Scheme Message</label>
                            <textarea class="form-control" name="message" rows="4" placeholder="Paste the SMS, WhatsApp message, or email text here..."></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Or Paste Link/URL</label>
                            <input type="url" class="form-control" name="url" placeholder="https://...">
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-bold">Or Upload Scheme PDF</label>
                            <input class="form-control" type="file" name="text_file" accept=".txt">
                        </div>
                        <button type="submit" class="btn btn-primary w-100 py-2" style="background-color:#00adb5; border:none;">Analyze with AI</button>
                    </form>
                </div>
            </div>

            <% if (trustScoreStr != null) {
                int trustScore = Integer.parseInt(trustScoreStr);
            %>
            <div class="col-md-6 mb-4">
                <div class="card analysis-card p-4 h-100">
                    <h4 class="mb-4 fw-bold text-secondary">Analysis Results</h4>
                   
                    <div class="text-center mb-4">
                        <div class="score-circle <%= trustScore >= 75 ? "score-high" : "score-low" %>">
                            <%= trustScore %>%
                        </div>
                        <h5 class="mt-3 fw-bold <%= trustScore >= 75 ? "text-success" : "text-danger" %>">
                            Status: <%= isGenuine %>
                        </h5>
                    </div>

                    <% if (trustScore < 75) { %>
                        <div class="alert alert-danger">
                            <strong>Warning!</strong> This scheme appears highly suspicious. Do not share personal details.
                        </div>
                        <form action="SubmitGrievanceServlet" method="post" class="mt-3 border-top pt-3">
                            <h6 class="fw-bold text-danger">Report to Government Portal</h6>
                            <input type="hidden" name="scam_details" value="User flagged content">
                            <button type="submit" class="btn btn-danger btn-sm w-100">Submit Official Grievance</button>
                        </form>
                    <% } else { %>
                        <div class="alert alert-success mt-2">
                            <strong>Verified!</strong> This scheme passes security checks.
                        </div>
                       
                        <h6 class="fw-bold mt-4 border-bottom pb-2">Profile Compatibility</h6>
                        <% if ("Yes".equals(profileMatch)) { %>
                            <p class="text-success"><i class="bi bi-check-circle-fill"></i> This scheme perfectly matches your registered profile (Age, Income, Marital Status).</p>
                            <button class="btn btn-success w-100">Proceed to Official Registration</button>
                        <% } else { %>
                            <p class="text-warning text-dark">This scheme is genuine, but you do not meet the eligibility criteria based on your profile.</p>
                            <div class="card bg-light p-3 mt-2">
                                <h6 class="fw-bold mb-2">Recommended For You:</h6>
                                <ul class="mb-0 small text-muted">
                                    <li>PM Kisan Samman Nidhi (Matches your income bracket)</li>
                                    <li>State Youth Scholarship Program (Matches your age group)</li>
                                </ul>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>