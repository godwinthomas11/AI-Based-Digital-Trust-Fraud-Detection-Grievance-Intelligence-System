# 🛡️ AI-Based Digital Trust & Fraud Detection — Grievance Intelligence System

<p align="center">
  <img src="https://img.shields.io/badge/Java-Servlets-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white"/>
  <img src="https://img.shields.io/badge/JSP-Frontend-007396?style=for-the-badge&logo=java&logoColor=white"/>
  <img src="https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white"/>
  <img src="https://img.shields.io/badge/Apache_Tomcat-9.x-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black"/>
  <img src="https://img.shields.io/badge/Deployed_on-Render-46E3B7?style=for-the-badge&logo=render&logoColor=white"/>
  <img src="https://img.shields.io/badge/Database-Aiven_Cloud-FF5533?style=for-the-badge"/>
</p>

<p align="center">
  <strong>A web-based fraud detection and grievance intelligence platform that protects Indian citizens from fake government scheme messages using rule-based NLP, weighted trust scoring, and integrated fraud reporting.</strong>
</p>

<p align="center">
  <a href="#-live-demo">Live Demo</a> •
  <a href="#-features">Features</a> •
  <a href="#-directory-structure">Directory Structure</a> •
  <a href="#-local-setup">Local Setup</a> •
  <a href="#-database-scripts">Database Scripts</a> •
  <a href="#-deployment">Deployment</a> •
  <a href="#-user-manual">User Manual</a> •
  <a href="#-team">Team</a>
</p>

-----

## 🌐 Live Demo

> **Live Application:** <https://ai-based-digital-trust-fraud-detection.onrender.com>

> ⚠️ The app is hosted on a free Render tier. It may take **30–60 seconds** to wake up on first visit.

-----

## ✨ Features

|Feature                     |Description                                                               |
|----------------------------|--------------------------------------------------------------------------|
|🔍 **Fraud Detection Engine**|Analyzes messages using 50+ keyword indicators across 5 risk categories   |
|📊 **Trust Score Calculator**|Generates a score from 0–100 with SAFE / SUSPICIOUS / FRAUD classification|
|🌐 **URL Intelligence**      |Validates `.gov.in` / `.nic.in` vs suspicious / shortened URLs            |
|📁 **Multi-Input Support**   |Accepts text messages, URLs, or uploaded `.txt` files                     |
|🔐 **User Authentication**   |Session-based login with profile (income, age, marital status)            |
|🎯 **Profile Matching**      |Cross-checks scheme eligibility based on user income                      |
|📢 **Grievance Reporting**   |One-click fraud reporting with Pending/Resolved tracking                  |
|🗄️ **Cloud Database**        |MySQL 8.0 on Aiven with SSL-encrypted connections                         |

-----

## 📁 Directory Structure

```
DigitalTrustProject1/
│
├── src/
│   └── java/
│       └── digitaltrust/
│           ├── AnalyzeSchemeServlet.java   ← Core fraud detection engine
│           ├── LoginServlet.java           ← User authentication
│           ├── RegisterServlet.java        ← New user registration
│           ├── fraudServlet.java           ← Fraud detection + DB logging
│           ├── TrustServlet.java           ← Quick trust score calculator
│           ├── GrievanceServlet.java       ← Grievance submission handler
│           └── SubmitGrievanceServlet.java ← Scam details submission
│
├── web/
│   ├── WEB-INF/
│   │   ├── web.xml                         ← Servlet + deployment config
│   │   └── lib/
│   │       └── mysql-connector-j-8.x.jar  ← MySQL JDBC driver
│   ├── index.jsp                           ← Main dashboard
│   ├── login.jsp                           ← Login page
│   ├── register.jsp                        ← Registration page
│   └── check_scheme.jsp                    ← Analysis results page
│
├── database/
│   └── schema.sql                          ← Database creation script
│
├── nbproject/                              ← NetBeans project config
├── build.xml                               ← Ant build script
└── README.md
```

-----

## 🧠 How the Fraud Detection Algorithm Works

```
Input (Text / URL / File)
        │
        ▼
  Text Preprocessing  ──→  Lowercase + Remove special characters
        │
        ▼
  Base Score = 100 (starts fully trusted)
        │
        ├── Category 1: Lottery/Prize keywords    → up to -25 per keyword
        ├── Category 2: Urgency/Pressure tactics  → up to -25 per keyword
        ├── Category 3: Financial red flags        → up to -25 per keyword
        ├── Category 4: Data harvesting attempts  → up to -25 per keyword
        └── Category 5: URL Risk Assessment
                        .gov.in  → +40 (trusted)
                        .nic.in  → +35 (trusted)
                        Unknown  → -40 (risky)
                        bit.ly   → -20 (high risk)
        │
        ▼
  Keyword Density Multiplier
        3+ fraud keywords co-occur → extra -20
        5+ fraud keywords co-occur → extra -20
        │
        ▼
  Final Score (clamped 0–100)
        │
        ├── Score ≥ 60  →  ✅ SAFE
        ├── Score 40–59 →  ⚠️  SUSPICIOUS
        └── Score < 40  →  🚨 FRAUD → Enable Grievance Filing
```

-----

## ⚙️ Local Setup & Installation

### Prerequisites

|Tool             |Version   |Download                                           |
|-----------------|----------|---------------------------------------------------|
|Java JDK         |8 or above|https://www.oracle.com/java/technologies/downloads/|
|Apache Tomcat    |9.x       |https://tomcat.apache.org/download-90.cgi          |
|MySQL Server     |8.0       |https://dev.mysql.com/downloads/mysql/             |
|NetBeans IDE     |12+       |https://netbeans.apache.org/download/              |
|MySQL Connector/J|8.x       |https://dev.mysql.com/downloads/connector/j/       |

-----

### Step 1 — Clone the Repository

```bash
git clone https://github.com/godwinthomas11/AI-Based-Digital-Trust-Fraud-Detection-Grievance-Intelligence-System.git
cd AI-Based-Digital-Trust-Fraud-Detection-Grievance-Intelligence-System
```

-----

### Step 2 — Set Up the Database

```bash
mysql -u root -p < database/schema.sql
```

Or run the SQL manually from the [Database Scripts](#-database-scripts) section below.

-----

### Step 3 — Add MySQL Connector JAR

1. Download `mysql-connector-j-8.x.x.jar` from https://dev.mysql.com/downloads/connector/j/
1. Place it inside `web/WEB-INF/lib/`
1. In NetBeans: Right-click project → **Properties → Libraries → Add JAR/Folder**

-----

### Step 4 — Configure Database Credentials

Open each servlet file listed below and update the three database constants:

```
src/java/digitaltrust/AnalyzeSchemeServlet.java
src/java/digitaltrust/LoginServlet.java
src/java/digitaltrust/RegisterServlet.java
src/java/digitaltrust/GrievanceServlet.java
src/java/digitaltrust/SubmitGrievanceServlet.java
src/java/digitaltrust/fraudServlet.java
```

Update these lines in each file:

```java
private static final String DB_URL  = "jdbc:mysql://YOUR_HOST:YOUR_PORT/YOUR_DB?useSSL=true&requireSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
private static final String DB_USER = "your_username";
private static final String DB_PASS = "your_password";
```

**For local MySQL setup:**

```java
private static final String DB_URL  = "jdbc:mysql://localhost:3306/digitaltrust?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
private static final String DB_USER = "root";
private static final String DB_PASS = "your_local_mysql_password";
```

-----

### Step 5 — Add Tomcat Server in NetBeans

1. Go to **Tools → Servers → Add Server**
1. Select **Apache Tomcat or TomEE**
1. Browse to your Tomcat installation directory
1. Set port to `8080` (default)
1. Click **Finish**

-----

### Step 6 — Build and Run

1. Open NetBeans → **File → Open Project** → select cloned folder
1. Right-click project → **Clean and Build**
1. Right-click project → **Run**
1. App opens at:

```
http://localhost:8080/DigitalTrustProject1/
```

-----

## 🗄️ Database Scripts

### Full Setup Script

```sql
-- Create database
CREATE DATABASE IF NOT EXISTS digitaltrust;
USE digitaltrust;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(100)  NOT NULL,
    email          VARCHAR(100)  NOT NULL UNIQUE,
    password       VARCHAR(100)  NOT NULL,
    age            INT,
    address        VARCHAR(255),
    blood_group    VARCHAR(10),
    marital_status VARCHAR(20),
    income         DOUBLE
);

-- Fraud analysis results table
CREATE TABLE IF NOT EXISTS analysis (
    id      INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(255),
    score   INT,
    label   VARCHAR(20)
);

-- Grievances table
CREATE TABLE IF NOT EXISTS grievances (
    id      INT AUTO_INCREMENT PRIMARY KEY,
    message TEXT,
    status  VARCHAR(20) DEFAULT 'Pending'
);
```

### Verify Tables

```sql
USE digitaltrust;
SHOW TABLES;
DESCRIBE users;
DESCRIBE analysis;
DESCRIBE grievances;
```

### Optional: Insert Test User

```sql
INSERT INTO users (name, email, password, age, address, blood_group, marital_status, income)
VALUES ('Test User', 'test@example.com', 'test123', 28, 'Pune, Maharashtra', 'O+', 'Single', 450000);
```

### Useful Admin Queries

```sql
-- View all analysis results
SELECT * FROM analysis ORDER BY id DESC;

-- View all pending grievances
SELECT * FROM grievances WHERE status = 'Pending';

-- Count fraud vs safe results
SELECT label, COUNT(*) as total FROM analysis GROUP BY label;

-- View all registered users (without passwords)
SELECT id, name, email, age, income FROM users;
```

-----

## 🚀 Deployment

### Deploy on Render (Recommended — Free)

#### Step 1 — Push to GitHub

```bash
git add .
git commit -m "deploy: update for production"
git push origin main
```

#### Step 2 — Create Render Web Service

1. Go to <https://render.com> → **New → Web Service**
1. Connect your GitHub repository
1. Configure the service:

|Setting      |Value              |
|-------------|-------------------|
|Environment  |Java               |
|Instance Type|Free               |
|Auto-Deploy  |Yes (on every push)|

1. Click **Create Web Service** — Render builds and deploys automatically

#### Step 3 — Set Environment Variables on Render

Go to your service → **Environment** tab → add:

|Key      |Value                           |
|---------|--------------------------------|
|`DB_URL` |Your full JDBC connection string|
|`DB_USER`|Database username               |
|`DB_PASS`|Database password               |

-----

### Set Up Aiven Cloud MySQL

1. Sign up at <https://aiven.io> (free tier available)
1. Create a new **MySQL** service → choose free/hobbyist plan
1. Wait for status: **Running** (1–2 minutes)
1. Go to **Overview** tab → copy Host, Port, User, Password
1. Connect and run the schema:

```bash
# Using MySQL CLI
mysql -h YOUR_HOST -P YOUR_PORT -u avnadmin -pYOUR_PASSWORD --ssl-mode=REQUIRED defaultdb
```

Paste and run the database scripts above, then update your servlet credentials.

**JDBC URL format for Aiven:**

```java
"jdbc:mysql://YOUR_HOST:YOUR_PORT/defaultdb?useSSL=true&requireSSL=true&allowPublicKeyRetrieval=true&serverTimezone=UTC"
```

-----

## 📖 User Manual

### Register

1. Open the app → click **Register**
1. Fill in: Name, Email, Password, Age, Address, Blood Group, Marital Status, Annual Income
1. Click **Register** → redirected to Login

### Login

1. Enter your email and password → click **Login**
1. Redirected to the main dashboard

### Analyze a Message

**Text message:** Paste the suspicious message → click Analyze

**URL:** Paste a suspicious URL → click Analyze

**File upload:** Upload a `.txt` file containing the message → click Analyze

### Reading Results

|Score |Label       |Action                    |
|------|------------|--------------------------|
|60–100|✅ SAFE      |Message likely genuine    |
|40–59 |⚠️ SUSPICIOUS|Proceed with caution      |
|0–39  |🚨 FRAUD     |Do not respond — report it|

### File a Grievance

After a **FRAUD** result → click **Report Grievance** → message auto-fills → click **Submit**

-----

## 🧪 Test Cases

### FRAUD Example (Score near 0)

```
Congratulations! You have won Rs. 50,000 in the PM Kisan lottery.
Click http://bit.ly/claim-prize to claim now.
Pay processing fee of Rs. 500 via UPI. Urgent — offer expires today!
```

### SAFE Example (Score 80+)

```
Apply for Pradhan Mantri Awas Yojana at https://pmaymis.gov.in
Check eligibility and submit your documents online.
```

### SUSPICIOUS Example (Score 40–59)

```
Dear customer, your bank account needs verification.
Please visit our branch or call customer care immediately.
```

-----

## 🛠️ Troubleshooting

|Problem                                           |Solution                                              |
|--------------------------------------------------|------------------------------------------------------|
|`Access denied for user root@IP`                  |Switch to Aiven Cloud; Railway blocks external IPs    |
|`ClassNotFoundException: com.mysql.cj.jdbc.Driver`|Add MySQL Connector JAR to `WEB-INF/lib/`             |
|`HTTP 404` on servlet URL                         |Check `@WebServlet` annotation matches form `action`  |
|`HTTP 500` error                                  |Check Tomcat logs in `logs/catalina.out`              |
|GitHub push rejected (secret detected)            |Go to Repo → Security → Secret Scanning → Allow secret|
|App slow on first load (Render)                   |Free tier sleeps after inactivity — wait 30–60s       |
|`SSL connection required` error                   |Add `useSSL=true&requireSSL=true` to your JDBC URL    |

-----

## 🔐 Security Notes

|Measure                 |Status                                                     |
|------------------------|-----------------------------------------------------------|
|SQL Injection Prevention|✅ PreparedStatement used for all queries                   |
|Session Management      |✅ HttpSession with user attributes                         |
|SSL Database Connection |✅ Mandatory TLS on Aiven                                   |
|Input Sanitization      |✅ Text cleaning before processing                          |
|Password Hashing        |⚠️ Plain text (academic project — use BCrypt for production)|

-----

## 📦 Tech Stack

|Layer          |Technology             |
|---------------|-----------------------|
|Backend        |Java Servlets, JDBC    |
|Frontend       |JSP, HTML5, CSS3       |
|Database       |MySQL 8.0 (Aiven Cloud)|
|Server         |Apache Tomcat 9.x      |
|Deployment     |Render                 |
|Version Control|Git & GitHub           |
|IDE            |NetBeans               |

-----

## 👥 Team

|Name             |PRN       |Roll No.|Role                    |
|-----------------|----------|--------|------------------------|
|Aryan Gavali     |1032240154|33      |Frontend Developer      |
|Godwin Thomas    |1032240162|41      |Backend Developer & Lead|
|Sarthak Vyavahare|1032240163|42      |Database & Testing      |
|Praveet Gupta    |1032240179|57      |Research & Documentation|

**Faculty Mentor:** Prof. Suhas Joshi
**Institution:** MIT World Peace University, Pune

-----

## 📄 License

Academic project — MIT World Peace University, Pune (2025–2026).

-----

<p align="center">Built with ❤️ for a safer Digital India 🇮🇳</p>
