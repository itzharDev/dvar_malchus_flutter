# Setup Instructions for Contributors

Thank you for contributing to Dvarmalchus Flutter! This document will help you set up the project for local development.

## Prerequisites

- Flutter 3.35.6+ (managed with FVM recommended)
- Dart SDK 2.17.6+
- Android Studio / Xcode for mobile development
- Firebase account (for full functionality)

## Required Configuration Files

The following files are not included in the repository for security reasons and must be created:

### 1. Firebase Configuration

You need to set up your own Firebase project and add the configuration files:

#### Android: `android/app/google-services.json`
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use an existing one
3. Add an Android app with package name: `com.zooz.dvarmalchus` (or check `android/app/build.gradle` for the actual applicationId)
4. Download `google-services.json` and place it in `android/app/`

#### iOS: `ios/Runner/GoogleService-Info.plist`
1. In the same Firebase project, add an iOS app
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/` and `macos/Runner/`

#### Generate Dart configuration:
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Generate firebase_options.dart
flutterfire configure
```

This will create `lib/firebase_options.dart` automatically.

### 2. Android Signing Configuration (Optional - only for release builds)

For release builds, you need to create a keystore and configure signing:

1. Create a keystore:
```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Create `android/key.properties` (use `android/key.properties.example` as template):
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

**Note**: For debug builds and testing, you don't need the keystore configuration.

## Installation Steps

1. Clone the repository:
```bash
git clone <repository-url>
cd dvarmalchus_flutter_public
```

2. Install FVM (optional but recommended):
```bash
# Install FVM
brew install fvm  # macOS
# or visit https://fvm.app/docs/getting_started/installation

# Use Flutter version specified in project
fvm install
fvm use 3.35.6
```

3. Get Flutter dependencies:
```bash
fvm flutter pub get
# or just: flutter pub get
```

4. Run code generation:
```bash
fvm flutter packages pub run build_runner build
```

5. Run the app:
```bash
fvm flutter run
# or just: flutter run
```

## Troubleshooting

### Missing Firebase Configuration
If you see errors about missing Firebase configuration, make sure you've completed step 1 above.

### Build Errors
- Run `fvm flutter clean` and try again
- Make sure you're using the correct Flutter version
- Check that all configuration files are in place

### Android Build Issues
- Minimum SDK: Check Flutter's default (usually 21+)
- Ensure you have at least 4GB RAM available for Gradle builds
- Java 21+ required for current Gradle configuration

## Contributing

Once you have the project running:
1. Create a new branch for your feature/fix
2. Make your changes
3. Test thoroughly
4. Submit a pull request

For more details on the project architecture, see `WARP.md`.
