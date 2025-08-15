Project Title
Work Spot - Coworking space booking mobile application

Overview
This project demonstrates key app features including search, map view, booking, notifications, local data storage and mock API integration.

Features
Splash Screen
Displays the app logo on launch for a smooth user experience.

Home Screen
Search branches by name, city, or branch.
Filter results by city and price.
Lists branches using the Mick API.

Map View
Shows all branches located on Google Maps using the Google Maps Flutter package.
Secured API key management with the flutter_dotenv package.

Space Details Screen
Provides detailed information about selected branches.

Booking Screen
Allows users to select date and time for bookings.
Bookings are stored locally using Hive for offline access.
Booking integrates with a mock API to simulate backend interaction.
Shows a notification when a booking is completed.

My Bookings Screen
Lists all bookings with their status from local Hive storage.
Includes a delete option that triggers a notification upon deletion.

Notifications
Implemented using the flutter_local_notifications package for local notifications, including booking confirmations and deletion alerts.
the page listing all notifications from local storage

State Management
Utilizes Riverpod for managing app state efficiently and reactively.

Installation
Clone the repository:

bash
git clone [GitHub Repository Link]
cd [repo_folder]
Install dependencies:

bash
flutter pub get
Run the app:

bash
flutter run
Notifications - Local notifications are implemented with flutter_local_notifications.

Firebase push notifications are not integrated due to the need for Cloud Functions and billing.
Backend interaction is simulated with a mock API and local Hive storage.

Configuration
No special API keys or setup required for local notifications.
For Google Maps, secure your API key using flutter_dotenv and place it in the .env file.

Firebase connection is currently included.

