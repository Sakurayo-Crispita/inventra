#!/bin/bash

# Pre-requisites for Vercel
# Clones Flutter if not present (using depth 1 for speed)
if [ ! -d "flutter" ]; then
  echo "Cloning Flutter SDK..."
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable
fi

# Add Flutter to path
export PATH="$PATH:`pwd`/flutter/bin"

# Enable web support
echo "Enabling web support..."
flutter config --enable-web

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Build the web app
echo "Building for Web (Release)..."
flutter build web --release --base-href /

echo "Build completed successfully!"
