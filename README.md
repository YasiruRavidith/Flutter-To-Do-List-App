# 📝 To-Do App

A beautiful and feature-rich Flutter to-do list application with Firebase integration, Google Sign-In, and smart reminder notifications.

![Flutter](https://img.shields.io/badge/Flutter-3.35.7-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.0-0175C2?logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

- 🔐 **Google Sign-In Authentication** - Secure login with Google account
- 📋 **Todo Management** - Create, edit, complete, and delete tasks
- 🏷️ **8 Categories** - Organize tasks by Pet Care, Shopping, Appointments, Reading, Grocery, Entertainment, Chores, Exercise
- ⏰ **Smart Reminders** - Set alarms for important tasks with date/time picker
- 🔔 **Push Notifications** - Full-screen alarm notifications with sound
- 💾 **Cloud Sync** - All data saved to Firebase Firestore (persists across logins)
- 🎨 **Beautiful UI** - Custom pink and purple theme with Material Icons
- 📱 **Custom App Icon** - Unique branding with custom launcher icon
- 🌐 **Cross-platform** - Works on Android, iOS, Web, Windows, macOS, and Linux

## 📸 Screenshots

<!-- Add your screenshots here -->

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.35.7 or higher)
- Dart SDK (3.9.0 or higher)
- Android Studio / VS Code
- Firebase account
- Google Cloud Console account

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/YasiruRavidith/Flutter-To-Do-List-App.git
   cd Flutter-To-Do-List-App/cute_todo_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   
   ⚠️ **IMPORTANT:** The `google-services.json` file is not included in this repository for security reasons.
   
   You need to create your own Firebase project:
   
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project
   - Add an Android app with package name: `com.yasiru.cute_todo_app`
   - Download `google-services.json`
   - Place it in `android/app/google-services.json`
   
   Enable these Firebase services:
   - ✅ Authentication (Google Sign-In)
   - ✅ Cloud Firestore
   - ✅ Firebase Core

4. **Configure Google Sign-In**
   
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Select your Firebase project
   - Go to **APIs & Services** > **Credentials**
   - Create OAuth 2.0 Client ID for Android
   - Add your SHA-1 certificate fingerprint
   
   Get SHA-1 fingerprint:
   ```bash
   cd android
   ./gradlew signingReport
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

```yaml
dependencies:
  firebase_core: ^4.2.0
  firebase_auth: ^6.1.1
  cloud_firestore: ^6.0.3
  google_sign_in: ^6.2.1
  shared_preferences: ^2.5.3
  flutter_local_notifications: ^18.0.1
  timezone: ^0.9.4

dev_dependencies:
  flutter_launcher_icons: ^0.14.1
```

## 🏗️ Project Structure

```
cute_todo_app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   └── todo_model.dart          # Todo & Category models
│   ├── screens/
│   │   ├── login_screen.dart        # Google Sign-In screen
│   │   └── home_screen.dart         # Main app screen
│   ├── services/
│   │   ├── auth_service.dart        # Authentication logic
│   │   └── notification_service.dart # Alarm & notifications
│   └── widgets/
│       └── todo_card.dart           # Todo item widget
├── android/
│   └── app/
│       ├── google-services.json     # Firebase config (not in repo)
│       └── build.gradle.kts         # Android build config
└── assets/
    └── icon/
        └── to-do.png                # App launcher icon
```

## 🔧 Configuration

### Android Minimum SDK
- **minSdk:** 23 (Android 6.0+)
- **targetSdk:** flutter.targetSdkVersion

### Permissions
The app requires these Android permissions:
- `POST_NOTIFICATIONS` - Show notifications
- `VIBRATE` - Vibrate on alarm
- `RECEIVE_BOOT_COMPLETED` - Restart alarms after reboot
- `SCHEDULE_EXACT_ALARM` - Schedule precise alarms
- `USE_EXACT_ALARM` - Use exact alarm timing
- `WAKE_LOCK` - Wake device for alarms

## 🎨 Customization

### Change App Icon

1. Replace `assets/icon/to-do.png` with your icon (1024x1024 PNG)
2. Run the icon generator:
   ```bash
   flutter pub run flutter_launcher_icons
   ```
3. Rebuild the app

### Change Theme Colors

Edit `lib/screens/home_screen.dart` and `lib/screens/login_screen.dart`:

```dart
primaryColor: Color(0xFF7B68EE)  // Purple
accentColor: Color(0xFFFFB3BA)   // Pink
backgroundColor: Color(0xFFE8E4F3) // Light purple
```

## 📱 Building for Production

### Build APK (Android)

**Standard APK:**
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

**Split APKs (smaller size):**
```bash
flutter build apk --split-per-abi
```
Output: 
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM - most common)
- `app-x86_64-release.apk` (x86 devices)

### Build App Bundle (Google Play)
```bash
flutter build appbundle
```

## 🔐 Security Notes

### API Keys & Secrets

**⚠️ NEVER commit these files to Git:**
- `android/app/google-services.json` (already in `.gitignore`)
- `ios/Runner/GoogleService-Info.plist` (already in `.gitignore`)

If you accidentally exposed keys:
1. Rotate API keys in Google Cloud Console
2. Download new `google-services.json`
3. Force push to remove from Git history (see `SECURITY_FIX_GUIDE.md`)

### Recommended Security Practices

1. **Restrict API Keys** in Google Cloud Console:
   - Application restrictions: Android apps only
   - Add package name: `com.yasiru.cute_todo_app`
   - Add SHA-1 fingerprint
   - API restrictions: Only enable required APIs

2. **Firestore Security Rules:**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId}/{document=**} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

## 🐛 Troubleshooting

### App crashes on startup
- Check `google-services.json` is properly configured
- Verify package name matches: `com.yasiru.cute_todo_app`
- Run `flutter clean` and rebuild

### Google Sign-In not working
- Add SHA-1 fingerprint to Firebase Console
- Enable Google Sign-In in Firebase Authentication
- Check internet connection

### Notifications not showing
- Grant notification permissions in Android settings
- Enable "Alarms & reminders" permission
- Check device is not in Do Not Disturb mode

### Build errors
- Run `flutter clean`
- Delete `build` folder
- Run `flutter pub get`
- Rebuild the app

## 🧪 Testing

Run tests:
```bash
flutter test
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Yasiru Ravidith**
- GitHub: [@YasiruRavidith](https://github.com/YasiruRavidith)
- Email: yasiruravidith123@gmail.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Material Design for beautiful icons
- All contributors and testers

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 Changelog

### Version 1.0.0 (October 27, 2025)
- ✅ Initial release
- ✅ Google Sign-In authentication
- ✅ Todo CRUD operations with 8 categories
- ✅ Firebase Firestore integration
- ✅ Smart reminders with alarms
- ✅ Push notifications
- ✅ Custom app icon
- ✅ Material Icons throughout
- ✅ Multi-platform support

## 🔮 Future Enhancements

- [ ] Recurring reminders
- [ ] Task priorities (High, Medium, Low)
- [ ] Dark mode
- [ ] Offline mode with sync
- [ ] Task sharing
- [ ] Statistics & insights
- [ ] Widget support
- [ ] Voice input
- [ ] Multi-language support

## 📞 Support

If you have any questions or need help, please:
- Open an issue on GitHub
- Email: yasiruravidith123@gmail.com

---

⭐ If you like this project, please give it a star on GitHub!

**Made with ❤️ using Flutter**
