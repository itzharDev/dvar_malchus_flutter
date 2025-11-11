# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

Dvarmalchus Flutter is a Jewish learning app that provides daily Torah content including Dvar Malchus, daily Chumash, Tehillim, Tanya, Rambam, and other Jewish texts. The app features audio playback, offline storage, regional customization (particularly Israel), and progress tracking with Hebrew calendar integration.

## Development Commands

### Core Flutter Commands
```bash
# Run the app in debug mode
fvm flutter run

# Hot reload (when running)
r

# Hot restart (when running)  
R

# Build for different platforms
fvm flutter build apk --release    # Android APK
fvm flutter build ipa --release    # iOS
fvm flutter build web --release    # Web

# Run tests
fvm flutter test

# Analyze code for issues
fvm flutter analyze

# Get dependencies
fvm flutter pub get

# Upgrade dependencies
fvm flutter pub upgrade

# Clean build artifacts
fvm flutter clean
```

### Code Generation
```bash
# Generate JSON serialization and Retrofit API clients
fvm flutter packages pub run build_runner build

# Watch for changes and regenerate automatically
fvm flutter packages pub run build_runner watch

# Clean generated files before regenerating
fvm flutter packages pub run build_runner clean
```

### Asset Management
```bash
# Generate asset constant files (custom script)
./generate_assets.sh
```

### Android Build Commands
```bash
# Build APK
fvm flutter build apk --release

# Build App Bundle
fvm flutter build appbundle --release

# Skip build dependency validation if needed (CI/CD workaround)
fvm flutter build appbundle --release --android-skip-build-dependency-validation
```

### Version Management
```bash
# Current production version: 5.0.2+129
# Previous Google Play version: 5.0.1 (build 128)
# Update version in pubspec.yaml before release builds
```

## Architecture

### State Management
- **BLoC Pattern**: Uses `flutter_bloc` for state management
- **Dependency Injection**: `get_it` service locator pattern
- **Key Cubits**:
  - `DvarmalchusCubit`: Main app logic, content fetching, audio playback
  - `AnalyticsCubit`: Firebase analytics tracking
  - `SettingsCubit`: App settings and preferences
  - `DMPdfViewerCubit`: PDF viewing functionality

### Project Structure
```
lib/
├── core/                     # Core functionality and shared code
│   ├── constants/           # App constants, colors, assets
│   ├── cubit/              # Global state management
│   ├── network/            # API models and responses
│   ├── dm_pdf_viewer/      # Custom PDF viewer component
│   ├── ioc.dart            # Dependency injection setup
│   ├── rest_client.dart    # HTTP client (Retrofit)
│   └── hive_manager.dart   # Local storage management
├── home_page/              # Main app screen
├── settings/               # Settings screen
├── credits/                # Credits screen
├── hashlamot/              # Progress tracking screen
├── firebase_options.dart   # Firebase configuration
└── main.dart              # App entry point
```

### Data Layer
- **Remote**: REST API using Retrofit/Dio for fetching Torah content
- **Local**: Hive for caching, SharedPreferences for settings
- **Audio**: `just_audio` for playing Torah audio content
- **PDF**: Custom PDF viewer for text content

### Key Features
- **Multi-platform**: Android, iOS, Web, macOS, Windows, Linux support
- **Offline-first**: Content cached locally for offline access
- **Hebrew Calendar**: Kosher Dart integration for Jewish dates
- **Audio Playback**: Background audio with controls
- **Regional Content**: Different content based on country (Israel focus)
- **Progress Tracking**: Completion tracking with local storage
- **Custom Fonts**: Orion Hebrew font family

## Important Notes

### Version Compatibility
- **Flutter**: 3.35.6+ (uses modern plugin management)
- **Dart SDK**: `>=2.17.6 <4.0.0` (supports Dart 3.x)
- **Null Safety**: Fully migrated (no legacy flags needed)

### Build Memory Requirements
- **Gradle JVM Heap**: Minimum 4GB (`-Xmx4g`) configured in `android/gradle.properties`
- **MetaSpace**: 512MB (`-XX:MaxMetaspaceSize=512m`) for optimal performance
- **Memory Settings**: `org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError`

### Dependencies
- **State Management**: `flutter_bloc`, `equatable`
- **Networking**: `dio`, `retrofit`, `connectivity_plus`
- **Storage**: `hive`, `shared_preferences`, `flutter_secure_storage`
- **Audio**: `just_audio`
- **Jewish Calendar**: `kosher_dart`
- **Firebase**: `firebase_core`, `firebase_analytics`
- **PDF**: `flutter_pdfview`

### Asset Generation
The project includes a custom script `generate_assets.sh` that automatically generates Dart constants for assets in the `assets/icons/` and `assets/images/` directories. Run this script when adding new assets.

### Debugging
- **Logging**: Uses `fimber` package with colorized console output
- **Analytics**: Firebase Analytics integration for user tracking
- **Error Handling**: Comprehensive error states in Cubits

### Regional Considerations
The app is designed primarily for Jewish users, with special attention to Israeli users. Content is fetched based on country settings, with Israel (`il`) as the default region.

### Android Configuration (Successfully Tested)
- **Flutter Version**: 3.35.6 (managed with FVM) ✅
- **Dart Version**: 3.9.2 (supports SDK constraint `>=2.17.6 <4.0.0`) ✅
- **Kotlin Version**: 1.8.10+ (minimum required by Flutter 3.35.6) ✅
- **Android Gradle Plugin**: 8.1.1+ (working configuration) ✅
- **Gradle Wrapper**: 8.5+ (working with current config) ✅
- **Compile SDK**: Uses Flutter's default (usually 35+) ✅
- **Min SDK**: Uses Flutter's default (usually 21+) ✅
- **Namespace**: Required for AGP 8.x, defined in android block ✅
- **Plugin Management**: Uses declarative plugins syntax (required by Flutter 3.35.6) ✅
- **Java Version**: OpenJDK 21+ (requires Gradle 8.5+) ✅
- **Memory Configuration**: 4GB JVM heap for Gradle builds ✅

**Build Status**: ✅ Successfully building APKs and App Bundles
**Signing Status**: ✅ Configured with correct production keystore (SHA1: 00:B6:73:41:6E:A7:B6:C8:6E:BB:EC:FE:FC:99:6A:AB:F3:C3:17:E2)
**Current Version**: 5.0.2 (build 129) - Ready for Google Play release
**Last Verified**: Current build configuration confirmed working

### Common Build Issues (Resolved)
- **✅ Kotlin Version Error**: Fixed - Updated to 1.8.10 in `android/build.gradle`
- **✅ CI/CD Builds**: Use `--android-skip-build-dependency-validation` flag to bypass version warnings
- **✅ Legacy Null Safety**: Project fully migrated, no legacy flags needed
- **✅ Plugin V1 Embedding**: All plugins upgraded to compatible versions (path_provider_android, shared_preferences_android, url_launcher_android)
- **✅ Memory Issues**: Gradle JVM heap increased to 4GB to prevent OutOfMemoryError during builds
- **✅ Empty Assets Directory**: Assets properly configured and building
- **✅ Firebase/Google Services**: Plugin properly configured at end of `android/app/build.gradle`
- **✅ CompileSdk 35 Compatibility**: AGP 8.1.1+ with namespace declaration working
- **✅ AGP 8.x Compatibility**: Gradle 8.5+ with namespace configuration working
- **✅ Firebase Analytics with AGP 8.x**: `buildFeatures { buildConfig true }` configured
- **✅ Java 21 Compatibility**: Working with Gradle 8.5+

### Current Build Warnings (Non-blocking)
- Version compatibility warnings for Gradle (8.5.0 vs recommended 8.7.0+)
- Android Gradle Plugin warnings (8.1.1 vs recommended 8.6.0+)
- Kotlin version warnings (1.8.10 vs recommended 2.1.0+)

These warnings can be bypassed in CI/CD with `--android-skip-build-dependency-validation` flag.
