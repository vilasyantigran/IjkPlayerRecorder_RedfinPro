#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_PATH="$REPO_ROOT/ios/IJKMediaPlayer/IJKMediaPlayer.xcodeproj"
FRAMEWORK_NAME="IJKMediaFramework"
BUILD_ROOT="${BUILD_ROOT:-$REPO_ROOT/.build/xcframework}"
DIST_DIR="${DIST_DIR:-$REPO_ROOT/dist}"

DEVICE_FFMPEG_LIB="$REPO_ROOT/ios/build/universal/lib/libavcodec.a"
SIMULATOR_FFMPEG_LIB="$REPO_ROOT/ios/build/simulator/lib/libavcodec.a"
if [[ ! -f "$DEVICE_FFMPEG_LIB" || ! -f "$SIMULATOR_FFMPEG_LIB" ]]; then
  cat <<'MESSAGE' >&2
Missing FFmpeg libraries.

Build them first:
  ./init-ios.sh
  cd ios
  ./compile-ffmpeg.sh clean
  ./compile-ffmpeg.sh all
MESSAGE
  exit 1
fi

rm -rf "$BUILD_ROOT"
mkdir -p "$BUILD_ROOT" "$DIST_DIR"

xcodebuild build \
  -project "$PROJECT_PATH" \
  -scheme "$FRAMEWORK_NAME" \
  -configuration Release \
  -sdk iphoneos \
  -destination "generic/platform=iOS" \
  -derivedDataPath "$BUILD_ROOT/derived-device" \
  ARCHS=arm64 \
  VALID_ARCHS=arm64 \
  ONLY_ACTIVE_ARCH=NO \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  CODE_SIGNING_ALLOWED=NO \
  IPHONEOS_DEPLOYMENT_TARGET=12.0 \
  CONFIGURATION_BUILD_DIR="$BUILD_ROOT/build-iphoneos" \
  SYMROOT="$BUILD_ROOT/sym-device" \
  OBJROOT="$BUILD_ROOT/obj-device"

xcodebuild build \
  -project "$PROJECT_PATH" \
  -scheme "$FRAMEWORK_NAME" \
  -configuration Release \
  -sdk iphonesimulator \
  -destination "generic/platform=iOS Simulator" \
  -derivedDataPath "$BUILD_ROOT/derived-sim" \
  ARCHS=arm64 \
  VALID_ARCHS=arm64 \
  ONLY_ACTIVE_ARCH=NO \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  CODE_SIGNING_ALLOWED=NO \
  IPHONEOS_DEPLOYMENT_TARGET=12.0 \
  CONFIGURATION_BUILD_DIR="$BUILD_ROOT/build-iphonesimulator" \
  SYMROOT="$BUILD_ROOT/sym-sim" \
  OBJROOT="$BUILD_ROOT/obj-sim"

rm -rf "$DIST_DIR/$FRAMEWORK_NAME.xcframework"

xcodebuild -create-xcframework \
  -framework "$BUILD_ROOT/build-iphoneos/$FRAMEWORK_NAME.framework" \
  -framework "$BUILD_ROOT/build-iphonesimulator/$FRAMEWORK_NAME.framework" \
  -output "$DIST_DIR/$FRAMEWORK_NAME.xcframework"

echo "Created: $DIST_DIR/$FRAMEWORK_NAME.xcframework"
