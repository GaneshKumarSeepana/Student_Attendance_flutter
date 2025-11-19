# 📊 Student Attendance System (Flutter)

A Flutter application for tracking student attendance across multiple courses with rich analytics, alerts, and reports.

---

## 🚀 Live Demo

👉 **[Open Web Demo](https://ganeshkumarseepana.github.io/Student_Attendance_flutter/)**  

> The web build is deployed using GitHub Pages.  
> Best viewed on mobile or tablet.

---

## 📌 Overview

This app helps students monitor their attendance across different subjects, visualize trends, and stay above required thresholds (e.g. 75%).  
It uses **MobX** for state management and **SQFlite** for local data persistence, following a clean and testable architecture.

---

## ✨ Features

- ✅ **MobX State Management** – Centralized state for attendance records, statistics, and course data  
- 🔐 **Authentication** – Login with student ID and password  
- 💾 **Local Data Persistence** – Store attendance data using **SQFlite** + **Shared Preferences**  
- 📝 **Attendance Tracking** – Mark **Present / Absent / Leave** for each subject and each day  
- 📈 **Visual Analytics** – View attendance percentage by subject/course with color-coded indicators  
- 🗓️ **Calendar View** – Attendance history in a calendar with intuitive color coding  
- 🚨 **Alerts** – Warnings when attendance falls below the **75% threshold**  
- 📑 **Reports** – Monthly and semester-wise attendance reports  
- 📤 **Export** – Generate & share **PDF attendance reports**

---

## 🧱 Folder Structure

```text
lib/
├── models/       # Data models (Course, Attendance, Stats)
├── stores/       # MobX stores for state management
├── views/        # Screen-level UI pages
├── widgets/      # Reusable UI components
├── services/     # Business logic and services
└── main.dart     # App entry point
