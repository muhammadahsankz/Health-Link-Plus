#!/bin/bash
set -e

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Enable web support
flutter config --enable-web
flutter pub get

# Build Flutter web app with JS backend instead of WASM
flutter build web --release --web-renderer canvaskit --no-wasm
