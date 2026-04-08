# 🛡️ AI-Based Digital Trust & Fraud Detection Grievance Intelligence System

<p align="center">
  <img src="https://img.shields.io/badge/Java-Servlets-red?style=for-the-badge&logo=java" />
  <img src="https://img.shields.io/badge/JSP-Frontend-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/MySQL-Database-orange?style=for-the-badge&logo=mysql" />
  <img src="https://img.shields.io/badge/Tomcat-Server-yellow?style=for-the-badge&logo=apache" />
  <img src="https://img.shields.io/badge/Deployed-Render-green?style=for-the-badge&logo=render" />
  <img src="https://img.shields.io/badge/Database-Aiven-purple?style=for-the-badge" />
</p>

<p align="center">
  <strong>A comprehensive fraud detection and digital trust platform that protects Indian citizens from fraudulent government scheme messages using rule-based NLP, weighted risk scoring, and an integrated grievance reporting system.</strong>
</p>

---

## 📌 Problem Statement

With the rapid expansion of **Digital India** services, millions of citizens receive messages about government schemes daily. Scammers exploit this by sending fake messages that mimic legitimate schemes, leading to financial losses and erosion of digital trust. There is a critical need for an intelligent system that can analyze such messages, determine their authenticity, and empower users to report fraud seamlessly.

---

## 💡 Our Solution

This system provides a multi-layered defense against digital fraud by combining **text analysis**, **URL validation**, **trust scoring**, and **grievance filing** into a single unified platform.

### How It Works

```
User Input (Message/URL/File)
        │
        ▼
  ┌─────────────────┐
  │  Text Cleaning   │  ──▶  Lowercasing, special character removal
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │ Keyword Detection│  ──▶  50+ fraud indicators analyzed
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │  URL Validation  │  ──▶  .gov.in / .nic.in boost | suspicious domains penalized
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │ Weighted Scoring │  ──▶  Trust Score (0 to 100)
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │  Classification  │  ──▶  SAFE | SUSPICIOUS | FRAUD
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │ Grievance Filing │  ──▶  Auto-report to Government Portal
  └─────────────────┘
```

---

## ✨ Key Features

| Feature | Description |
|---|---|
| **Fraud Detection Engine** | Rule-based NLP with 50+ keyword patterns, URL analysis, and multi-factor scoring |
| **Trust Score Calculator** | Generates a score from 0 to 100 based on weighted risk indicators |
| **URL Intelligence** | Validates links against known government domains (.gov.in, .nic.in) and flags suspicious shortened URLs (bit.ly, tinyurl) |
| **Multi-Input Support** | Analyze plain text messages, URLs, or uploaded .txt files |
| **User Profile Matching** | Cross-references scheme eligibility with user income data |
| **Grievance Reporting** | One-click grievance submission for detected fraud, stored and tracked with status |
| **User Authentication** | Secure registration and login with session management |
| **Database Persistence** | All analyses, users, and grievances stored in cloud MySQL |

---

## 🏗️ System Architecture

The system follows the **MVC (Model-View-Controller)** design pattern:

```
┌────────────────────────────────────────────────────┐
│                    CLIENT BROWSER                   │
└──────────────────────┬─────────────────────────────┘
                       │
          ┌────────────▼────────────┐
          │      VIEW LAYER (JSP)   │
          │  login.jsp | index.jsp  │
          │  register.jsp           │
          │  check_scheme.jsp       │
          └────────────┬────────────┘
                       │
          ┌────────────▼────────────┐
          │  CONTROLLER (Servlets)  │
          │  LoginServlet           │
          │  RegisterServlet        │
          │  AnalyzeSchemeServlet   │
          │  FraudServlet           │
          │  TrustServlet           │
          │  GrievanceServlet       │
          │  SubmitGrievanceServlet │
          └────────────┬────────────┘
                       │
          ┌────────────▼────────────┐
          │   MODEL (MySQL - Aiven) │
          │  users | analysis       │
          │  grievances             │
          └─────────────────────────┘
```

---

## 🧠 Fraud Detection Algorithm

The scoring engine evaluates messages across **5 risk categories**:

### 1. Lottery & Prize Scam Indicators
Keywords like `lottery`, `won`, `winner`, `prize`, `jackpot`, `congratulations`, `lucky`, `selected` each carry penalty weights from 15 to 25 points.

### 2. Urgency & Pressure Tactics
Phrases such as `claim now`, `act now`, `limited time`, `urgent`, `immediately`, `account blocked`, `suspended` are penalized 15 to 25 points.

### 3. Financial Red Flags
Terms including `processing fee`, `registration fee`, `advance`, `deposit`, `pay`, `UPI`, `Paytm`, `wallet` deduct 10 to 25 points.

### 4. Data Harvesting Attempts
Words like `password`, `CVV`, `PIN`, `Aadhaar`, `PAN card`, `account number`, `verify`, `click here` reduce the score by 15 to 25 points.

### 5. URL Risk Assessment
The system applies intelligent URL scoring:

| URL Type | Score Impact |
|---|---|
| `.gov.in` domains | +40 (trusted) |
| `.nic.in` domains | +35 (trusted) |
| `.edu.in` / `.ac.in` | +10 (semi-trusted) |
| Shortened URLs (bit.ly, tinyurl) | -20 (high risk) |
| Other external URLs | -40 (risky) |

A **keyword density multiplier** applies additional penalties when 3+ or 5+ fraud indicators appear together.

---

## 🗄️ Database Schema

### `users` Table
| Column | Type | Description |
|---|---|---|
| id | INT (PK, AUTO_INCREMENT) | Unique user ID |
| name | VARCHAR(100) | Full name |
| email | VARCHAR(100) | Email address |
| password | VARCHAR(100) | User password |
| age | INT | Age |
| address | VARCHAR(255) | Residential address |
| blood_group | VARCHAR(10) | Blood group |
| marital_status | VARCHAR(20) | Marital status |
| income | DOUBLE | Annual income |

### `analysis` Table
| Column | Type | Description |
|---|---|---|
| id | INT (PK, AUTO_INCREMENT) | Analysis record ID |
| message | VARCHAR(255) | Analyzed text |
| score | INT | Calculated trust score |
| label | VARCHAR(20) | SAFE / SUSPICIOUS / FRAUD |

### `grievances` Table
| Column | Type | Description |
|---|---|---|
| id | INT (PK, AUTO_INCREMENT) | Grievance ID |
| message | TEXT | Grievance details |
| status | VARCHAR(20) | Pending / Resolved |

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Backend** | Java Servlets, JDBC |
| **Frontend** | JSP, HTML, CSS |
| **Database** | MySQL 8.0 (Aiven Cloud) |
| **Server** | Apache Tomcat |
| **Deployment** | Render (Web Service) |
| **Version Control** | Git & GitHub |
| **IDE** | NetBeans |

---

## 🚀 Deployment

The application is deployed as a **live web service**:

| Component | Platform |
|---|---|
| Web Application | [Render](https://render.com) |
| Cloud Database | [Aiven](https://aiven.io) (MySQL 8.0) |

---

## ⚙️ Local Setup & Installation

### Prerequisites
Java JDK 8+, Apache Tomcat 9+, MySQL 8.0, NetBeans IDE

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/godwinthomas11/AI-Based-Digital-Trust-Fraud-Detection-Grievance-Intelligence-System.git
   ```

2. **Import into NetBeans** as a Web Application project

3. **Add MySQL Connector JAR** to project libraries

4. **Create database tables**
   ```sql
   CREATE TABLE users (
       id INT AUTO_INCREMENT PRIMARY KEY,
       name VARCHAR(100),
       email VARCHAR(100),
       password VARCHAR(100),
       age INT,
       address VARCHAR(255),
       blood_group VARCHAR(10),
       marital_status VARCHAR(20),
       income DOUBLE
   );

   CREATE TABLE analysis (
       id INT AUTO_INCREMENT PRIMARY KEY,
       message VARCHAR(255),
       score INT,
       label VARCHAR(20)
   );

   CREATE TABLE grievances (
       id INT AUTO_INCREMENT PRIMARY KEY,
       message TEXT,
       status VARCHAR(20)
   );
   ```

5. **Configure database credentials** in servlet files

6. **Run on Tomcat** and access at `http://localhost:8080/DigitalTrustProject1/`

---

## 🔐 Security Measures

| Measure | Implementation |
|---|---|
| SQL Injection Prevention | PreparedStatement used across all queries |
| Session Management | HttpSession for authenticated user tracking |
| Input Sanitization | Text cleaning before processing |
| SSL Database Connection | Encrypted connection to cloud database |

---

## 📊 Classification Logic

| Trust Score | Classification | Action |
|---|---|---|
| 60 to 100 | ✅ SAFE | Scheme appears genuine |
| 40 to 59 | ⚠️ SUSPICIOUS | Proceed with caution |
| 0 to 39 | 🚨 FRAUD | Grievance filing recommended |

---

## 🔮 Future Scope

The system can be enhanced with Machine Learning models (NLP classifiers like Naive Bayes or BERT), real-time SMS/WhatsApp integration, multilingual support for regional Indian languages, integration with government APIs for live scheme verification, and a mobile application for wider accessibility.

---

## 👥 Contributors

| Name | Role |
|---|---|
| **Godwin Thomas** | Developer & Project Lead |

---

## 📄 License

This project is developed for academic and educational purposes.

---

<p align="center">
  <strong>Built with ❤️ for a safer Digital India</strong>
</p>
