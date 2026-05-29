# SmartStudy Flutter Frontend - Development Guide

## ✅ What's Been Developed

Your Flutter app now has a complete, production-ready frontend with the following features:

### 📱 **Screens & Features**

#### 1. **Home Screen** (`home_screen.dart`)
- Landing page with app branding
- Quick access to Login and Register

#### 2. **Authentication**
- **Login Screen** (`login_screen.dart`) - Email/password authentication
- **Register Screen** (`register_screen.dart`) - New user registration
- Both screens use the `AuthProvider` for state management

#### 3. **Dashboard** (`dashboard_screen.dart`)
- **Bottom Navigation Bar** with 4 tabs:
  - Home (Dashboard overview)
  - Analytics (Performance tracking)
  - Schedule (Study planner)
  - Profile (User settings)

#### 4. **Dashboard Home Tab**
- Welcome greeting with user name
- Quick stats cards (Goal %, Study Days, Avg Score, Hours Today)
- Recent activities feed
- Study tips and recommendations

#### 5. **Performance Analytics Screen** (`performance_analytics_screen.dart`)
- Input form for student performance data:
  - Demographics (Gender, Ethnicity, Parental Education, Lunch Type)
  - Test Preparation Course
  - Test Scores (Math, Reading, Writing)
- ML prediction integration with backend
- Visual score display with progress bar
- Color-coded score feedback (green/orange/red)

#### 6. **Study Schedule Screen** (`study_schedule_screen.dart`)
- Add subjects/topics with study hours
- Visual list of scheduled subjects
- Generate smart study schedule (sends to backend)
- Success notifications

#### 7. **User Profile & Settings** (`profile_screen.dart`)
- User avatar with initials
- Display user name and email
- Settings items (Notifications, Language, Theme)
- Logout button

---

## 🏗️ **Architecture**

### **Services** (`lib/services/`)
- **`api_service.dart`** - Centralized API client for all backend communication
  - `/register` - User registration
  - `/login` - User authentication
  - `/logout` - Session termination
  - `/predict-performance` - ML performance prediction
  - `/generate-schedule` - Smart study schedule generation

### **Models** (`lib/models/`)
- **`user_model.dart`** - User data structure
- **`performance_model.dart`** - Performance prediction & student data
- **`schedule_model.dart`** - Study schedule tasks

### **State Management** (`lib/providers/`)
- **`auth_provider.dart`** - Handles authentication state and user session
- **`performance_provider.dart`** - Manages performance predictions and schedules

### **UI Theme** (`theme.dart`)
- Consistent color scheme
- Pre-defined `AppColors` class

---

## 🎯 **Key Features Implemented**

✅ **User Authentication**
- Registration with validation
- Secure login with email/password
- Session management
- Logout functionality

✅ **State Management**
- Provider package for reactive UI
- Centralized auth & performance providers
- Automatic UI updates

✅ **Performance Tracking**
- AI/ML-powered performance prediction
- Input form with validation
- Visual score representation

✅ **Study Schedule**
- Add multiple subjects with hours
- Generate personalized schedules
- Backend integration

✅ **User Profile**
- View account information
- Settings management
- Logout

✅ **Responsive UI**
- Clean, modern design
- Bottom navigation
- Error handling & loading states
- Success notifications

---

## 🚀 **Running the App**

### Prerequisites
```bash
# Ensure Flutter is installed
flutter --version

# Get dependencies
flutter pub get
```

### Run on Emulator/Device
```bash
# Run the app
flutter run

# Run with specific device
flutter run -d <device_id>
```

### Build APK
```bash
# Build release APK
flutter build apk --release
```

---

## 🔧 **Backend Configuration**

The app connects to Flask backend at: `http://10.0.2.2:5000`

**Backend endpoints used:**
- `POST /register` - Register new user
- `POST /login` - Login user
- `POST /logout` - Logout user
- `POST /predict-performance` - Get performance prediction
- `POST /generate-schedule` - Save study schedule

**Important:** The backend must be running for the app to work. Ensure:
1. Flask server is running on `localhost:5000`
2. Database is properly configured
3. ML model is loaded

---

## 📝 **Project Structure**

```
smart_study_flutter/
├── lib/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── performance_model.dart
│   │   └── schedule_model.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   └── performance_provider.dart
│   ├── services/
│   │   └── api_service.dart
│   ├── main.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── dashboard_screen.dart
│   ├── performance_analytics_screen.dart
│   ├── study_schedule_screen.dart
│   ├── profile_screen.dart
│   └── theme.dart
├── assets/
│   └── images/
│       └── logo.png
├── pubspec.yaml
└── README.md
```

---

## 📦 **Dependencies**

Key packages in `pubspec.yaml`:
- `flutter` - UI framework
- `provider: ^6.1.1` - State management
- `http: ^0.13.6` - API calls
- `firebase_core` - Firebase integration
- `firebase_auth` - Firebase authentication
- `google_sign_in` - Google authentication

---

## 🎨 **Theming**

The app uses a consistent blue color scheme:
- **Light Blue** (`#D4EBFD`) - Background
- **Blue** (`#8CA8D4`) - Primary
- **Button Blue** (`#4D648D`) - CTAs
- **Dark Blue** (`#203864`) - Text
- **Highlight Blue** (`#AED2F2`) - Accents

To customize, edit `theme.dart`.

---

## 🔄 **Next Steps** (Optional Enhancements)

1. **Add Data Persistence** - Implement local storage for offline access
2. **Enhanced Charts** - Add performance charts using `fl_chart`
3. **Notifications** - Push notifications for study reminders
4. **Dark Mode** - Add dark theme support
5. **Real-time Sync** - WebSocket for live updates
6. **Offline Mode** - Work without backend connection
7. **Export Data** - PDF reports of performance
8. **Social Features** - Compare with friends, leaderboards

---

## 🐛 **Troubleshooting**

### App won't connect to backend
- Check if Flask server is running: `python app.py`
- Verify backend is on `localhost:5000`
- Check firewall settings
- Test API manually: `curl http://localhost:5000/`

### Login/Register fails
- Verify email format
- Check password requirements (min 6 chars)
- Ensure backend database is configured
- Check error messages in debug console

### UI glitches or loading issues
- Run `flutter clean` then `flutter pub get`
- Restart the emulator
- Check console for error messages
- Verify all imports are correct

---

## 📞 **Support**

For issues or questions:
1. Check the error messages in the console
2. Review the backend logs
3. Verify API endpoint configurations
4. Test API calls manually using Postman/curl

---

**Happy Studying! 🎓**
