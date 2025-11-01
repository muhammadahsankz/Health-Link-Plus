#!/bin/bash

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Enable web
flutter config --enable-web

# Get packages and build
flutter pub get
flutter build web --release
