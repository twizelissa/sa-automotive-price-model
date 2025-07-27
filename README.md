# 🚗 South African Car Price Prediction System

## 📋 **Mission & Problem Statement**

The South African automotive market lacks accessible price prediction tools for consumers and dealers. This system addresses the challenge of determining fair car values by leveraging machine learning to predict vehicle prices based on key features like brand, engine size, and luxury status. Our solution provides instant, accurate price estimates through both API and mobile interfaces, democratizing access to automotive valuation data for the South African market.

## 🔗 **PROJECT LINKS**

- **GitHub Repository**: https://github.com/twizelissa/sa-automotive-price-model
- **Live API Documentation**: https://sa-automotive-price-model.onrender.com/docs
- **Dataset Source**: https://www.kaggle.com/datasets/tamsanqalowan/car-prices-in-south-africa


**Public API**: https://sa-automotive-price-model.onrender.com/predict


## 🎥 **Video Demonstration**

[**Watch Demo Video**](https://www.youtube.com/watch?v=AUM9ZroiLzs) demonstration of the complete system functionality.

## 📱 **How to Run the Mobile App**

### **Quick Start (Recommended)**
1. **Install Flutter**: Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
2. **Clone Repository**: 
   ```bash
   git clone https://github.com/twizelissa/sa-automotive-price-model.git
   cd sa-automotive-price-model/summative/sa_car_price_app
   ```
3. **Get Dependencies**: 
   ```bash
   flutter pub get
   ```
4. **Run the App**: 
   ```bash
   flutter run
   ```

### **Platform-Specific Instructions**

**For Android:**
- Connect Android device or start Android emulator
- Run: `flutter run -d android`

**For iOS (macOS only):**
- Open iOS Simulator
- Run: `flutter run -d ios`

**For Web Browser:**
- Run: `flutter run -d chrome`

**For Desktop:**
- Linux: `flutter run -d linux`
- Windows: `flutter run -d windows`
- macOS: `flutter run -d macos`

### **Troubleshooting**
- Ensure Flutter SDK is in your PATH
- Run `flutter doctor` to check for missing dependencies
- For Android: Ensure Android SDK and emulator are installed

## 📁 **Project Structure**

```
summative/
├── API/                          # FastAPI Backend
│   ├── main.py                   # FastAPI application
│   ├── best_car_price_model.pkl  # Trained ML model
│   ├── requirements.txt          # Python dependencies
│   └── render.yaml              # Render deployment config
├── linear_regression/           # ML Development
│   ├── multivariate.ipynb      # Model training notebook
│   └── car_prices_rsa_update_011.csv # Training dataset
└── sa_car_price_app/           # Flutter Mobile App
    ├── lib/main.dart           # Flutter application code
    └── pubspec.yaml           # Flutter dependencies
```

## 🚀 **API Usage Examples**

### **Test with cURL**
```bash
curl -X POST https://sa-automotive-price-model.onrender.com/predict \
  -H "Content-Type: application/json" \
  -d '{"brand":"Toyota","engine_size":2.0,"is_luxury":0}'
```

### **Expected Response**
```json
{
  "predicted_price_zar": 529122.48,
  "currency": "ZAR"
}
```

### **Input Parameters**
- **brand** (string): Car manufacturer (e.g., "Toyota", "BMW", "Audi")
- **engine_size** (float): Engine size in liters (1.0 - 6.0)
- **is_luxury** (integer): Luxury vehicle flag (0 = No, 1 = Yes)

## 📈 **Technology Stack**

- **Backend**: FastAPI, Python 3.11, Scikit-learn, Joblib
- **Frontend**: Flutter (Dart), Material Design UI
- **Deployment**: Render (API), Cross-platform mobile
- **ML Model**: Decision Tree Regressor with preprocessing

---

*Built with ❤️ for the South African automotive market*


