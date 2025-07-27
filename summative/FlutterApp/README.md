# SA Car Price Prediction Flutter App

A Flutter application that predicts car prices for the South African market using machine learning.

## Features

- **Brand Input**: Enter any car brand (Toyota, BMW, Audi, etc.)
- **Engine Size**: Input engine size between 1.0L and 6.0L
- **Luxury Classification**: Select whether the car is a luxury vehicle
- **Real-time Predictions**: Get instant price predictions in ZAR
- **Input Validation**: Form validation with helpful error messages
- **Network Error Handling**: Proper error handling for API calls
- **Clean UI**: Professional Material Design interface

## API Integration

This app connects to the SA Car Price Prediction API deployed on Render:
- **API URL**: `https://sa-automotive-price-model.onrender.com/predict`
- **Method**: POST
- **Request Format**: JSON with brand, engine_size, and is_luxury fields
- **Response**: Predicted price in South African Rand (ZAR)

## Getting Started

### Prerequisites

- Flutter SDK (>=2.19.0)
- Dart SDK
- Android Studio / VS Code with Flutter extension

### Installation

1. Clone or download this Flutter app
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

### Building for Release

**Android APK:**
```bash
flutter build apk --release
```

**iOS (on macOS):**
```bash
flutter build ios --release
```

## Usage

1. **Enter Car Brand**: Type the car manufacturer (e.g., "Toyota", "BMW")
2. **Engine Size**: Input the engine size in liters (1.0 - 6.0)
3. **Luxury Status**: Select "Yes" for luxury vehicles, "No" for standard vehicles
4. **Predict**: Tap the "Predict Price" button to get the estimated price
5. **Clear**: Use the "Clear Form" button to reset all fields

## Example Predictions

- **Toyota 2.0L Non-Luxury**: ~R529,000 ZAR
- **BMW 3.0L Luxury**: ~R1,051,000 ZAR
- **Audi 2.5L Luxury**: ~R800,000+ ZAR

## Technical Details

### Dependencies
- `flutter/material.dart`: UI framework
- `http`: API communication
- `dart:convert`: JSON parsing

### Validation Rules
- Brand: Required, non-empty string
- Engine Size: Must be between 1.0 and 6.0 liters
- Luxury: Binary choice (0 = No, 1 = Yes)

### Error Handling
- Network timeouts (30 seconds)
- API error responses
- Invalid input validation
- Connection failures

## App Architecture

```
lib/
└── main.dart              # Main app entry point and UI
```

### Key Components

- **MyApp**: Main application widget with Material theme
- **CarPredictionPage**: Main screen with prediction form
- **Form Validation**: Input validation for all fields
- **API Service**: HTTP client for FastAPI communication
- **State Management**: StatefulWidget for reactive UI updates

## Customization

### Changing API Endpoint
Update the `apiUrl` constant in `main.dart`:
```dart
static const String apiUrl = 'YOUR_API_ENDPOINT_HERE';
```

### Styling
Modify the theme in `MyApp` widget or individual widget styles for custom appearance.

## Troubleshooting

### Common Issues

1. **Network Error**: Check internet connection and API availability
2. **Timeout**: API might be slow, increase timeout duration
3. **Validation Errors**: Ensure all inputs meet the specified requirements
4. **Build Errors**: Run `flutter clean` then `flutter pub get`

### Testing API Connection

Test the API manually:
```bash
curl -X POST https://sa-automotive-price-model.onrender.com/predict \
  -H "Content-Type: application/json" \
  -d '{"brand":"Toyota","engine_size":2.0,"is_luxury":0}'
```

## License

This project is for educational and demonstration purposes.
