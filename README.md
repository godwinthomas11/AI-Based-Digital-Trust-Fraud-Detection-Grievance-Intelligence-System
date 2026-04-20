# Digital Trust & Fraud Detection System

Java, JSP, Servlet, and MySQL web app for checking suspicious government-scheme messages, calculating a trust score, and saving grievances for risky content.

Live app: https://ai-based-digital-trust-fraud-detection.onrender.com

## Features
- Rule-based fraud detection
- Trust Score from 0 to 100
- `SAFE`, `SUSPICIOUS`, and `FRAUD` labels
- URL checks for trusted `.gov.in` and `.nic.in` style domains
- Message, URL, and `.txt` file analysis
- User registration and login
- PBKDF2 password hashing
- Session-based dashboard access
- Basic profile eligibility matching
- Grievance reporting
- MySQL database integration through JDBC

## Project Structure
```text
src/java/digitaltrust/       Java servlet logic and shared helpers
web/                         JSP frontend
build/web/                   Built web app output used by the WAR
dist/DigitalTrustProject1.war Deployable WAR copied by Dockerfile
nbproject/                   NetBeans project configuration
```

## Environment Variables
Set these in Render or your local Tomcat environment:

```text
DB_URL=jdbc:mysql://your-aiven-host:port/defaultdb?useSSL=true&requireSSL=true&serverTimezone=UTC
DB_USER=your_database_user
DB_PASSWORD=your_database_password
```

The app also accepts these aliases: `AIVEN_DB_URL`, `AIVEN_DB_USER`, `AIVEN_DB_PASSWORD`, `JDBC_DATABASE_URL`, `JDBC_DATABASE_USERNAME`, and `JDBC_DATABASE_PASSWORD`.

## Database Tables
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    address VARCHAR(500) NOT NULL,
    blood_group VARCHAR(5) NOT NULL,
    marital_status VARCHAR(20) NOT NULL,
    income DOUBLE NOT NULL
);

CREATE TABLE analysis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(255) NOT NULL,
    score INT NOT NULL,
    label VARCHAR(20) NOT NULL
);

CREATE TABLE grievances (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(1000) NOT NULL,
    status VARCHAR(30) NOT NULL
);
```

## How It Works
1. User registers and logs in.
2. User submits a message, URL, or `.txt` file.
3. The servlet validates and cleans the input.
4. `FraudAnalyzer` applies weighted risk rules for scam wording, pressure tactics, sensitive-data requests, payment requests, and suspicious URLs.
5. The app stores the result and shows a trust score.
6. Risky content can be submitted as a grievance.

## How to Run Locally
1. Install Apache Tomcat and MySQL Connector/J.
2. Create the MySQL tables above.
3. Set the database environment variables.
4. Import the project into NetBeans.
5. Build and run on Tomcat.
6. Open `http://localhost:8080/DigitalTrustProject1/`.

## Deployment
The project deploys on Render using the checked-in WAR:

```dockerfile
FROM tomcat:9.0
COPY dist/DigitalTrustProject1.war /usr/local/tomcat/webapps/
```

After changing Java or JSP files, rebuild `build/web` and `dist/DigitalTrustProject1.war`, then push to the branch Render deploys from.

## Security Notes
- Do not commit database credentials.
- Configure production credentials only through Render environment variables.
- Previously committed credentials should be rotated.
- New passwords are stored with PBKDF2 hashes.
- Existing plain-text user passwords are upgraded to hashed passwords after a successful login.
- User-facing errors avoid printing database exception details.
