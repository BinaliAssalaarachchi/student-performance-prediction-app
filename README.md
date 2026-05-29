# SmartStudy Flutter

An intelligent study planning and performance tracking app built with Flutter.

## 📋 Overview

SmartStudy is a comprehensive student app that helps you:
- Track your academic performance with AI/ML predictions
- Generate personalized study schedules
- Manage your subjects and study goals
- Monitor your progress over time

## ✨ Features

- 🔐 **Secure Authentication** - Register and login securely
- 📊 **Performance Analytics** - AI-powered performance predictions based on your scores
- 📅 **Smart Scheduling** - Generate optimized study schedules
- 👤 **User Profile** - Manage your account and preferences
- 🎨 **Beautiful UI** - Clean, intuitive interface with responsive design
- ⚡ **Real-time Updates** - Instant feedback and notifications

## 🏗️ Project Structure

```
lib/
├── models/          # Data models
├── providers/       # State management (Provider)
├── services/        # API communication
├── main.dart        # App entry point
├── dashboard_screen.dart
├── performance_analytics_screen.dart
├── study_schedule_screen.dart
├── profile_screen.dart
└── theme.dart       # UI theme
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1+)
- Dart SDK (latest)
- Android Studio or Xcode

### Installation

1. **Clone the repository**
   ```bash
   cd smart_study_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🔗 Backend Integration

This app connects to a Flask backend. Make sure the backend is running:

```bash
cd ../student_performance_app/backend/student_performance_app_backend
python app.py
```

The backend handles:
- User authentication (register/login)
- Performance prediction using ML
- Study schedule generation and storage

## 📱 Screens

| Screen | Description |
|--------|-------------|
| **Home** | Landing page with app introduction |
| **Login** | User authentication |
| **Register** | New user registration |
| **Dashboard** | Overview with stats and activities |
| **Analytics** | Performance prediction and tracking |
| **Schedule** | Study schedule creation and management |
| **Profile** | User settings and account management |

## 🎯 How to Use

1. **Register** - Create a new account with email and password
2. **Login** - Sign in to your account
3. **View Dashboard** - Check your performance overview
4. **Add Performance Data** - Enter your test scores and info
5. **Get Predictions** - AI predicts your performance
6. **Create Schedule** - Add subjects and generate study schedule
7. **Monitor Progress** - Track your improvement over time

## 🛠️ Development

### File Organization

- **Models** (`lib/models/`) - Data structures for User, Performance, Schedule
- **Providers** (`lib/providers/`) - State management with Provider package
- **Services** (`lib/services/`) - API service for backend communication
- **Screens** - Individual screen widgets

### State Management

Using **Provider** package for reactive state management:
- `AuthProvider` - Manages user authentication and session
- `PerformanceProvider` - Manages performance data and predictions

### API Communication

All API calls are centralized in `ApiService`:
- Registration
- Login/Logout
- Performance prediction
- Schedule generation

## 🎨 Theme

The app uses a cohesive color scheme defined in `theme.dart`:
- **Light Blue** - Background
- **Button Blue** - CTAs and primary actions
- **Dark Blue** - Text and headers
- **Highlight Blue** - Accents

## 📚 Dependencies

Key packages:
- `provider` - State management
- `http` - HTTP client for API calls
- `firebase_core` & `firebase_auth` - Firebase services
- `google_sign_in` - Google authentication support

For full list, see `pubspec.yaml`

## 🔧 Configuration

### API Base URL
Edit in `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://10.0.2.2:5000';
```

### Theme Colors
Edit in `lib/theme.dart`:
```dart
class AppColors {
  static const Color lightBlue = Color(0xFFD4EBFD);
  // ... other colors
}
```

## 🐛 Troubleshooting

**Q: Backend connection fails**
- A: Ensure Flask server is running on `localhost:5000`

**Q: Login always fails**
- A: Check backend database is connected and running

**Q: UI not updating**
- A: Run `flutter clean` then `flutter pub get`

## 📖 For More Information

- See [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md) for detailed development documentation
- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Documentation](https://pub.dev/packages/provider)

## 📝 License

This project is part of the BCS Smart Study initiative.

---

**Happy Studying! 🎓**
