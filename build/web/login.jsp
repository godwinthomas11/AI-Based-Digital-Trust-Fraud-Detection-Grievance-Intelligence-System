<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Digital Trust System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; display: flex; align-items: center; justify-content: center; height: 100vh; }
        .card { border: none; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .btn-primary { background-color: #00adb5; border: none; }
        .btn-primary:hover { background-color: #008c9e; }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card p-4">
                    <div class="card-body">
                        <h3 class="text-center mb-4 fw-bold" style="color: #243b55;">Digital Trust System</h3>
                        <h5 class="text-center mb-4 text-muted">Sign In to Your Account</h5>
                        <form action="LoginServlet" method="post">
                            <div class="mb-3">
                                <label class="form-label">Email address</label>
                                <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label">Password</label>
                                <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 py-2 mb-3">Login</button>
                        </form>
                        <div class="text-center">
                            <span class="text-muted">First time user?</span> 
                            <a href="register.jsp" class="text-decoration-none fw-bold" style="color: #00adb5;">Create an Account</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>