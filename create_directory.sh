#!/bin/bash

# Base folders
folders=(
  "lib/models"
  "lib/screens"
  "lib/services"
  "lib/widgets"
)

# Create folders
for folder in "${folders[@]}"; do
  mkdir -p $folder
done

# Models
touch lib/models/user_model.dart
touch lib/models/deal_model.dart
touch lib/models/chat_model.dart
touch lib/models/review_model.dart

# Screens
touch lib/screens/home_screen.dart
touch lib/screens/deal_detail_screen.dart
touch lib/screens/chat_screen.dart
touch lib/screens/login_screen.dart
touch lib/screens/signup_screen.dart
touch lib/screens/profile_screen.dart

# Services
touch lib/services/auth_service.dart
touch lib/services/firestore_service.dart

# Widgets
touch lib/widgets/deal_card.dart

# Main file
touch lib/main.dart
touch lib/firebase_options.dart

echo "All folders and files created successfully!"
