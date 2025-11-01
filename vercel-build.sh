#!/bin/bash

# Stop on error
set -e

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Enable web and build
flutter config --enable-web
flutter pub get
flutter build web --release
