# medicalservic

> A Flutter mobile app prototype for basic medical services (Assignment Project)

---

## Table of Contents

* [Project Overview](#project-overview)
* [Assignment Scenario](#assignment-scenario)
* [Features](#features)
* [Tech Stack](#tech-stack)
* [Getting Started](#getting-started)

  * [Prerequisites](#prerequisites)
  * [Install](#install)
  * [Run](#run)
* [Project Structure](#project-structure)
* [Assumptions](#assumptions)
* [Scaling & Improvements](#scaling--improvements)
* [Deliverables](#deliverables)
* [License](#license)
* [Contact](#contact)

---

## Project Overview

`medicalservice` is a Flutter prototype app for academic assignment purposes. It demonstrates basic functionality of a medical service app including authentication, service booking, request tracking, and a simple admin panel.

---

## Assignment Scenario

The app allows users to:

1. **Login / Register** – using email or phone.
2. **Book a Service** – request a medical service like medical transport, doctor appointment, or health check-up (demo service).
3. **Track Request Status** – see if requests are **Pending**, **Accepted**, or **Completed**.
4. **Admin / Service Provider Panel** – view new requests, accept them, or mark as completed.

---

## Features

* Email/phone login and registration
* Book and manage medical services
* Track request status in real-time
* Role-based interface: User & Admin
* Local storage using **SharedPreferences**
* Clean UI with Flutter widgets and Google Fonts

---

## Tech Stack

* Flutter (>= 3.x)
* Dart
* GetX for state management & routing
* SharedPreferences for local storage
* Optional: REST API / Google Sheets for backend simulation

---

## Getting Started

### Prerequisites

* Flutter SDK installed
* Android Studio or VS Code with Flutter/Dart plugins
* Emulator or real device to run the app

### Install

```bash
git clone https://github.com/yourusername/medicalservic.git
cd medicalservic
flutter pub get
```

### Run

```bash
flutter run
```

---

## Project Structure

```
lib/
  main.dart
  login_screen.dart
  register_screen.dart
  user_home_screen.dart
  admin_home_screen.dart
  booking_screen.dart
  status_screen.dart
```

---

## Assumptions

* Authentication is simulated; no real backend.
* Admin and User roles are hardcoded.
* Request statuses are stored locally via SharedPreferences.

---

## Scaling & Improvements

* Add Firebase Authentication
* Use Firestore or SQL for backend storage
* Push notifications for status updates
* More robust admin dashboard
* Multiple services & payment integration

---

## Deliverables

1. Working Prototype / Demo App (Flutter)
2. GitHub Repository (this project)
3. Code Walkthrough Video & APK file (Google Drive)
4. Documentation (this README or short PDF)

---

## License

MIT License

---

## Contact

For queries: mail to: iqranaeem129@gmail.com 
GitHub: [https://github.com/In129-flutter/medicalservic](https://github.com/In129-flutter/medicalservic)
