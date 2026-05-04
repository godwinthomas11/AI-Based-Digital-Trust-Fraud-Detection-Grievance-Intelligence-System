# Digital Trust, Fraud Detection & Grievance Intelligence System

A Java-based web application that helps users identify whether a government scheme message, URL, or uploaded `.txt` file appears genuine or fraudulent using a rule-based trust scoring engine.

The system allows users to register, log in, analyze suspicious scheme-related content, receive a Trust Score, classify content as `SAFE`, `SUSPICIOUS`, or `FRAUD`, submit grievances, and view their activity through a dashboard.

---

## Live Demo

[Open Project](https://ai-based-digital-trust-fraud-detection.onrender.com/DigitalTrustProject1/login.jsp)

---

## Project Overview

Fraudulent messages and fake government scheme links are common methods used to mislead users into sharing sensitive information or making payments. This project provides a simple web-based platform where users can check suspicious content before trusting it.

The application analyzes user-submitted messages, URLs, or text files and generates a **Trust Score from 0 to 100**. Based on the score, the system classifies the content as:

- `SAFE`
- `SUSPICIOUS`
- `FRAUD`

The project also includes a grievance reporting module where users can report suspicious schemes and track related feedback.

> Note: The fraud detection logic is rule-based. It uses keyword matching, URL checks, and fraud-risk signals rather than a trained machine learning model.

---

## Features

### User Authentication
- User registration and login
- Session-based authentication
- Secure password hashing using PBKDF2-HMAC-SHA256
- Logout functionality

### Fraud Detection
- Analyze government scheme messages
- Analyze suspicious URLs
- Upload and analyze `.txt` files
- Generate a Trust Score from 0 to 100
- Classify content as SAFE, SUSPICIOUS, or FRAUD

### Rule-Based Scoring Engine
The system checks for:
- Suspicious keywords
- Urgency/pressure phrases such as “claim now”, “urgent”, or “act now”
- Requests for sensitive data such as OTP, CVV, PIN, Aadhaar, PAN, or password
- Payment-related terms such as processing fee, registration fee, UPI, Paytm, or deposit
- Trusted government domains such as `.gov.in` and `.nic.in`
- Suspicious public domains and URL shorteners

### User Dashboard
- View profile details
- View analysis history
- Track number of analyzed messages
- Track fraud/suspicious counts
- View submitted grievances
- Submit feedback

### Grievance Module
- Report suspicious schemes
- Store grievance records in MySQL
- Track grievance-related feedback

### Deployment
- WAR-based deployment on Apache Tomcat
- Docker/Render deployment support
- Database credentials managed through environment variables

---

## Tech Stack

### Frontend
- JSP
- HTML
- CSS
- JavaScript

### Backend
- Java Servlets
- JDBC
- MVC-style architecture

### Database
- MySQL

### Security
- PBKDF2-HMAC-SHA256 password hashing
- Session management
- PreparedStatement-based database queries
- Input sanitization utilities

### Deployment
- Apache Tomcat
- NetBeans/Ant
- Docker
- Render

---

## System Architecture

The project follows a simple MVC-style structure:

```text
User Interface (JSP Pages)
        |
        v
Servlet Controllers
        |
        v
Business Logic / Fraud Analyzer
        |
        v
Database Layer using JDBC
        |
        v
MySQL Database
