# Dvarmalchus Flutter

A Jewish learning app providing daily Torah content including Dvar Malchus, daily Chumash, Tehillim, Tanya, Rambam, and other Jewish texts. The app features audio playback, offline storage, regional customization (particularly for Israel), and progress tracking with Hebrew calendar integration.

## Features

- 📖 Daily Torah content (Dvar Malchus, Chumash, Tanya, Rambam, etc.)
- 🎵 Audio playback with background support
- 📱 Multi-platform support (Android, iOS, Web, macOS, Windows, Linux)
- 🔄 Offline-first architecture with local caching
- 📅 Hebrew calendar integration (Kosher Dart)
- 🌍 Regional content customization
- ✅ Progress tracking and completion status
- 🎨 Custom Hebrew fonts (Orion)

## Getting Started for Contributors

⚠️ **Important**: This repository does not include sensitive configuration files. Before you can run the app, you need to set up Firebase and signing configuration.

📋 **See [SETUP.md](SETUP.md) for complete setup instructions.**

### Quick Start

1. Clone the repository
2. Follow the setup instructions in [SETUP.md](SETUP.md)
3. Run `fvm flutter pub get`
4. Run `fvm flutter packages pub run build_runner build`
5. Run `fvm flutter run`

### Build Commands

```bash
# Debug build (no keystore needed)
fvm flutter run

# Release builds (requires keystore configuration - see SETUP.md)
fvm flutter build apk --release    # Android APK
fvm flutter build appbundle --release  # Android App Bundle
fvm flutter build ios --release    # iOS
```

**Note**: The `--no-sound-null-safety` flag is no longer needed as the project is fully migrated to null safety.

## Architecture

- **State Management**: BLoC pattern with flutter_bloc
- **Dependency Injection**: get_it
- **Networking**: Retrofit + Dio
- **Local Storage**: Hive + SharedPreferences
- **Audio**: just_audio
- **PDF Viewing**: Custom PDF viewer component

For detailed architecture information, see [WARP.md](WARP.md).

## Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Issues and Bug Reports

If you encounter any issues or bugs, please open an issue on GitHub with:
- Description of the problem
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Device/OS information

## License

[Add your license here]

## Acknowledgments

Built with Flutter and powered by the Jewish community's commitment to daily Torah learning.
