
# Event Discovery Platform

A full-stack mobile application for discovering and managing social events with role-based access control.

## Features

**Core Functionality**
- 🔒 JWT Authentication (Login/Register)
- 👥 Role-Based Access Control (User, Organizer, Admin)
- 📅 Event Creation & Listing
- 👤 User Profile Management

**Technical Highlights**
- 🚀 Flutter Frontend with Clean Architecture
- 🌐 Node.js/MongoDB Backend API
- 🔄 State Management with Provider
- 🛡️ Secure Storage for Tokens
- 📱 Responsive Mobile UI

## Tech Stack

**Frontend**  
[![Flutter](https://img.shields.io/badge/Flutter-3.13-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-2.19-blue?logo=dart)](https://dart.dev)

**Backend**  
[![Node.js](https://img.shields.io/badge/Node.js-18.x-green?logo=node.js)](https://nodejs.org)
[![MongoDB](https://img.shields.io/badge/MongoDB-6.0-green?logo=mongodb)](https://mongodb.com)

## Installation

### Backend Setup
```bash
git clone https://github.com/yourusername/event-discovery-app.git
cd backend
npm install

Create .env file in backend with
MONGO_URI=mongodb://localhost:27017/event-app
JWT_SECRET=your_jwt_secret_here
JWT_EXPIRES_IN=24h
PORT=5000

npm run dev
```

### Flutter App Setup
change your ip address in flutter/lib/constants/api_constants.dart
Then run this:
```bash
cd ../flutter
flutter pub get
flutter run
```


## Future Roadmap

- 📍 Google Maps integration for event locations
- 🔔 Push notifications for event updates
- 🔍 Advanced event search/filters
- 📊 Admin analytics dashboard
