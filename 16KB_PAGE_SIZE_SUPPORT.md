# 16 KB Page Size Support Implementation

## Overview
This document describes the implementation of 16 KB page size support for the Dvarmalchus Flutter app, which is required by Google Play starting November 1st, 2025 for all apps targeting Android 15+ devices.

## Changes Made

### 1. Android Gradle Plugin (AGP) Update
- **Updated from**: 8.1.1
- **Updated to**: 8.7.3
- **Location**: `android/settings.gradle`
- **Reason**: AGP 8.7.3+ automatically handles 16 KB alignment for native libraries

### 2. Gradle Wrapper Update
- **Updated from**: 8.5
- **Updated to**: 8.9
- **Location**: `android/gradle/wrapper/gradle-wrapper.properties`
- **Reason**: Gradle 8.9 is required for AGP 8.7.3

### 3. Kotlin Version Update
- **Updated from**: 1.8.10
- **Updated to**: 2.1.0
- **Locations**: 
  - `android/settings.gradle`
  - `android/app/build.gradle`
- **Reason**: Latest stable Kotlin version with improved compatibility

### 4. Native Library Configuration
**Location**: `android/app/build.gradle`

Added NDK ABI filters in `defaultConfig`:
```gradle
ndk {
    abiFilters 'armeabi-v7a', 'arm64-v8a', 'x86', 'x86_64'
}
```

### 5. Packaging Options
**Location**: `android/app/build.gradle`

Added packaging configuration:
```gradle
packagingOptions {
    jniLibs {
        // Use uncompressed native libraries for better 16 KB page size support
        // This requires AGP 8.5.1+ for proper 16 KB alignment
        useLegacyPackaging = false
    }
}
```

**Key Points**:
- `useLegacyPackaging = false` enables uncompressed native libraries
- AGP 8.7.3 automatically aligns these libraries on 16 KB boundaries
- Uncompressed libraries provide better performance and smaller app installation size

## Verification

### Automated Build Script
The project includes an updated `build.sh` script that automatically:
1. Cleans the project
2. Builds the signed app bundle
3. Verifies the production certificate
4. Builds the APK
5. **Verifies 16 KB page size alignment**
6. Copies the bundle to Desktop

```bash
./build.sh
# Output includes:
# ✓ Built build/app/outputs/bundle/release/app-release.aab (58.6MB)
# ✓ Signed with correct production certificate
# ✓ Built build/app/outputs/flutter-apk/app-release.apk (80.6MB)
# ✓ APK is properly aligned for 16 KB page sizes
# ✓ Bundle copied to ~/Desktop/app-release.aab
```

### Manual Build Verification
You can also build manually:
```bash
# APK build
fvm flutter build apk --release
# Output: ✓ Built build/app/outputs/flutter-apk/app-release.apk (80.6MB)

# App Bundle build
fvm flutter build appbundle --release
# Output: ✓ Built build/app/outputs/bundle/release/app-release.aab (58.6MB)
```

### Manual 16 KB Alignment Verification
```bash
zipalign -c -P 16 -v 4 app-release.apk
# Output: Verification successful
```

## Benefits of 16 KB Page Size Support

Based on Android's testing data:
- **3-30% lower app launch times** under memory pressure
- **4.56% reduction** in power draw during app launch
- **4.48-6.60% faster** camera launch times
- **8% improvement** in system boot time

## Google Play Requirement

Starting **November 1st, 2025**, all new apps and updates to existing apps submitted to Google Play and targeting Android 15 (API level 35) and higher **must support 16 KB page sizes** on 64-bit devices.

This app now meets this requirement and is ready for submission to Google Play.

## Testing on 16 KB Devices

To test the app on a device with 16 KB page sizes:

1. **Verify device page size**:
   ```bash
   adb shell getconf PAGE_SIZE
   # Should return: 16384 for 16 KB devices
   ```

2. **Verify APK alignment**:
   ```bash
   zipalign -c -P 16 -v 4 app-release.apk
   # Should show: Verification successful
   ```

3. **Test on supported devices**:
   - Android 15 emulator with 16 KB system image
   - Pixel 8/8 Pro/8a (Android 15 QPR1+)
   - Pixel 9/9 Pro/9 Pro XL (Android 15 QPR2 Beta 2+)

## References

- [Android Developer Guide: Support 16 KB page sizes](https://developer.android.com/guide/practices/page-sizes)
- [Google Play Policy Announcement](https://android-developers.googleblog.com/)

## Plugin Compatibility

### flutter_pdfview
The app uses `flutter_pdfview: ^1.4.3` which includes native libraries with 16 KB page size support.

**Important**: Version 1.4.0-1.4.2 do NOT support 16 KB page sizes. You must use version 1.4.3 or higher.

If you were previously using an older version and Google Play Console shows "Your app does not support 16 KB memory page sizes", upgrade to 1.4.3:

```yaml
# pubspec.yaml
dependencies:
  flutter_pdfview: ^1.4.3  # Must be 1.4.3+
```

Then clean and rebuild:
```bash
fvm flutter clean
fvm flutter pub get
fvm flutter build appbundle --release
```

## Notes

- This app uses Flutter framework and plugins, which may contain native libraries
- AGP 8.7.3 automatically handles the 16 KB alignment for all native libraries
- All plugins have been verified to support 16 KB page sizes
- The configuration is compatible with all existing Android devices (4 KB page sizes)
