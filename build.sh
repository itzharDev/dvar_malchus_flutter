#!/bin/bash

# Build script for Dvarmalchus Flutter Android App Bundle
# This script cleans the project and builds a signed release bundle

set -e  # Exit on error

echo "🧹 Cleaning project..."
fvm flutter clean

echo ""
echo "📦 Building signed app bundle..."
fvm flutter build appbundle --release

echo ""
echo "✅ Build complete!"
echo "📍 Location: build/app/outputs/bundle/release/app-release.aab"

# Verify signing
echo ""
echo "🔐 Verifying certificate fingerprint..."
FINGERPRINT=$(unzip -p build/app/outputs/bundle/release/app-release.aab META-INF/UPLOAD.RSA | keytool -printcert | grep "SHA1:" | head -1)
echo "$FINGERPRINT"

if echo "$FINGERPRINT" | grep -q "00:B6:73:41:6E:A7:B6:C8:6E:BB:EC:FE:FC:99:6A:AB:F3:C3:17:E2"; then
    echo "✅ Signed with correct production certificate"
else
    echo "❌ WARNING: Certificate fingerprint does not match production key!"
    exit 1
fi

# Build APK for 16 KB alignment verification
echo ""
echo "📱 Building APK for 16 KB alignment verification..."
fvm flutter build apk --release

# Verify 16 KB alignment
echo ""
echo "📏 Verifying 16 KB page size alignment..."
ZIPALIGN_PATH=$(find ~/Library/Android/sdk/build-tools -name zipalign -type f 2>/dev/null | sort -V | tail -1)

if [ -z "$ZIPALIGN_PATH" ]; then
    echo "⚠️  Warning: zipalign tool not found. Skipping 16 KB alignment check."
    echo "   Install Android SDK Build Tools 35.0.0+ to enable this check."
else
    if "$ZIPALIGN_PATH" -c -P 16 -v 4 build/app/outputs/flutter-apk/app-release.apk > /dev/null 2>&1; then
        echo "✅ APK ZIP alignment: PASSED"
    else
        echo "❌ WARNING: APK is NOT properly aligned for 16 KB page sizes!"
        echo "   This is required for Google Play submission as of Nov 1, 2025."
        exit 1
    fi
fi

# Verify native library ELF alignment
echo ""
echo "🔍 Verifying native library ELF alignment..."
NDK_PATH=$(find ~/Library/Android/sdk/ndk -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sort -V | tail -1)
LLVM_OBJDUMP="$NDK_PATH/toolchains/llvm/prebuilt/darwin-x86_64/bin/llvm-objdump"

if [ ! -f "$LLVM_OBJDUMP" ]; then
    echo "⚠️  Warning: llvm-objdump not found. Skipping ELF alignment check."
else
    # Extract AAB and check critical libraries
    rm -rf /tmp/build_check && mkdir -p /tmp/build_check
    unzip -q build/app/outputs/bundle/release/app-release.aab -d /tmp/build_check 2>/dev/null
    
    FAILED=0
    for lib in libapp.so libflutter.so libc++_shared.so libmodpdfium.so; do
        if [ -f "/tmp/build_check/base/lib/arm64-v8a/$lib" ]; then
            ALIGNMENT=$($LLVM_OBJDUMP -p /tmp/build_check/base/lib/arm64-v8a/$lib 2>/dev/null | grep "LOAD" | head -1 | grep -o "align 2\*\*[0-9]*" | grep -o "[0-9]*$")
            if [ "$ALIGNMENT" -ge "14" ]; then
                echo "  ✅ $lib: aligned (2**$ALIGNMENT = $((2**ALIGNMENT)) bytes)"
            else
                echo "  ❌ $lib: NOT aligned (2**$ALIGNMENT = $((2**ALIGNMENT)) bytes) - needs 2**14 or higher"
                FAILED=1
            fi
        fi
    done
    
    rm -rf /tmp/build_check
    
    if [ $FAILED -eq 1 ]; then
        echo ""
        echo "❌ ERROR: Some libraries are not 16 KB aligned!"
        echo "   Make sure you're using flutter_pdfview ^1.4.3 or higher."
        exit 1
    fi
fi

echo ""
echo "📋 Copying to Desktop..."
cp build/app/outputs/bundle/release/app-release.aab ~/Desktop/
echo "✅ Bundle copied to ~/Desktop/app-release.aab"
