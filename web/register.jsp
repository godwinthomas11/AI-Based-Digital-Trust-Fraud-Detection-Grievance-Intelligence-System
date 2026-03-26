<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Digital Trust System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f7f6;
            padding: 40px 0;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .btn-primary {
            background-color: #00adb5;
            border: none;
        }
        .btn-primary:hover {
            background-color: #008c9e;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card p-4">
                    <div class="card-body">
                        <h3 class="text-center mb-4 fw-bold" style="color: #243b55;">Create Your Profile</h3>
                       
                        <form action="RegisterServlet" method="post">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Full Name</label>
                                    <input type="text" name="name" class="form-control" placeholder="Enter your full name" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Email Address</label>
                                    <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
                                </div>
                            </div>
                           
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Password</label>
                                    <input type="password" name="password" class="form-control" placeholder="Create a password" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Age</label>
                                    <input type="number" name="age" class="form-control" placeholder="Enter your age" required>
                                </div>
                            </div>
                           
                            <div class="mb-3">
                                <label class="form-label">Address</label>
                                <textarea name="address" class="form-control" rows="2" placeholder="Enter your full residential address" required></textarea>
                            </div>
                           
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Blood Group</label>
                                    <select name="blood_group" class="form-select" required>
                                        <option value="" disabled selected>Select...</option>
                                        <option value="A+">A+</option>
                                        <option value="A-">A-</option>
                                        <option value="B+">B+</option>
                                        <option value="B-">B-</option>
                                        <option value="O+">O+</option>
                                        <option value="O-">O-</option>
                                        <option value="AB+">AB+</option>
                                        <option value="AB-">AB-</option>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Marital Status</label>
                                    <select name="marital_status" class="form-select" required>
                                        <option value="" disabled selected>Select...</option>
                                        <option value="Single">Single</option>
                                        <option value="Married">Married</option>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Annual Income (₹)</label>
                                    <input type="number" name="income" class="form-control" placeholder="e.g. 500000" required>
                                </div>
                            </div>
                           
                            <button type="submit" class="btn btn-primary w-100 py-2 mt-3">Register Account</button>
                        </form>
                       
                        <div class="text-center mt-3">
                            <span class="text-muted">Already have an account?</span>
                            <a href="login.jsp" class="text-decoration-none fw-bold" style="color: #00adb5;">Login Here</a>
                        </div>
                       
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>