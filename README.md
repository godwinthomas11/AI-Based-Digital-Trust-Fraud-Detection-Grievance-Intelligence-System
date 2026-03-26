#  AI Digital Trust & Fraud Detection System

##  Project Overview
This project is an AI-inspired Digital Trust and Fraud Detection System developed using Java, JSP, Servlets, and MySQL. The system helps users identify fraudulent government scheme messages, calculate a trust score, and submit grievances for suspicious or fake schemes.

With the rapid growth of Digital India services, this system aims to enhance digital trust, improve transparency, and protect users from online fraud.

---

##  Key Features
- 🔍 Fraud Detection using rule-based NLP techniques
- 📊 Trust Score Calculation (0–100%)
- 🌐 URL Validation (.gov.in vs suspicious domains)
- 🔐 User Authentication (Register & Login)
- 📢 Grievance Reporting System
- 🗄️ MySQL Database Integration
- 🧩 MVC Architecture Implementation

---

##  System Workflow
1. User registers and logs into the system  
2. User enters a scheme message  
3. System preprocesses the text (cleaning, tokenization)  
4. Applies keyword detection and pattern matching  
5. Calculates fraud score using weighted risk scoring  
6. Classifies message as:
   - SAFE  
   - SUSPICIOUS  
   - FRAUD  
7. Stores result in database  
8. If fraud detected → user can submit grievance  

---

##  Architecture (MVC)

- **View:** JSP (Frontend UI)
- **Controller:** Java Servlets (Business Logic)
- **Model:** MySQL Database

---

##  Technologies Used

### 💻 Backend
- Java (Servlets)
- JDBC

### 🌐 Frontend
- JSP (Java Server Pages)
- HTML
- CSS

### 🗄️ Database
- MySQL

### ⚙️ Server
- Apache Tomcat

### 🛠️ Tools
- NetBeans / VS Code
- MySQL Workbench
- Git & GitHub

---

##  Database Schema

### 📁 user_db
- **users**
  - id
  - name
  - email
  - password
  - salary
  - address

### 📁 digital_trust
- **analysis**
  - id
  - message
  - score
  - label

- **grievances**
  - id
  - message
  - status

---

##  Core Concepts Used
- Rule-Based NLP
- Tokenization
- Pattern Recognition
- Weighted Risk Scoring
- Session Management
- MVC Architecture
- CRUD Operations

---

## 🔐 Security Features
- Session-based authentication
- PreparedStatement (Prevents SQL Injection)
- Input validation

---

##  How to Run the Project

1. Install Apache Tomcat  
2. Install MySQL and create required databases  
3. Import project into NetBeans  
4. Add MySQL Connector JAR  
5. Configure database credentials in servlets  
6. Run the project on Tomcat server  
7. Open in browser:
