# IMPORTS: FastAPI, CORSMiddleware, HTTPException, Pydantic BaseModel, joblib, numpy, pandas
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import joblib
import numpy as np
import pandas as pd
import uvicorn
import os

# Get the directory where this script is located
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# SETUP: FastAPI app with title "SA Car Price Prediction API", CORS middleware with allow_origins=["*"]
app = FastAPI(title="SA Car Price Prediction API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# PYDANTIC: CarInput class with brand (str, min_length=1, example="Toyota"), engine_size (float, ge=1.0, le=6.0, example=2.0), is_luxury (int, ge=0, le=1, example=0)
class CarInput(BaseModel):
    brand: str = Field(min_length=1, example="Toyota")
    engine_size: float = Field(ge=1.0, le=6.0, example=2.0)
    is_luxury: int = Field(ge=0, le=1, example=0)

# ENDPOINT: POST /predict that loads joblib models, handles unknown brands with try-catch default to 0, creates DataFrame with columns, scales features, predicts log price and converts to actual price with np.exp(), returns {"predicted_price_zar": price, "currency": "ZAR"}
@app.post("/predict")
def predict_car_price(car_input: CarInput):
    try:
        # Load joblib models
        model = joblib.load(os.path.join(BASE_DIR, 'best_car_price_model.pkl'))
        scaler = joblib.load(os.path.join(BASE_DIR, 'price_scaler.pkl'))
        encoder = joblib.load(os.path.join(BASE_DIR, 'brand_encoder.pkl'))
        
        # Handle unknown brands with try-catch default to 0
        try:
            brand_encoded = encoder.transform([car_input.brand])[0]
        except ValueError:
            brand_encoded = 0  # Default for unknown brands
        
        # Create DataFrame with columns ["Brand_Encoded", "Engine_Size", "Is_Luxury"]
        features = pd.DataFrame([[brand_encoded, car_input.engine_size, car_input.is_luxury]],
                               columns=["Brand_Encoded", "Engine_Size", "Is_Luxury"])
        
        # Scale features
        features_scaled = scaler.transform(features)
        
        # Predict log price and convert to actual price with np.exp()
        prediction_log = model.predict(features_scaled)[0]
        predicted_price = np.exp(prediction_log)
        
        # Ensure positive price
        predicted_price = max(0, predicted_price)
        
        # Return {"predicted_price_zar": price, "currency": "ZAR"}
        return {
            "predicted_price_zar": round(predicted_price, 2),
            "currency": "ZAR"
        }
        
    # ERROR HANDLING: FileNotFoundError and prediction errors with HTTP status codes
    except FileNotFoundError as e:
        raise HTTPException(status_code=500, detail=f"Model file not found: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Prediction error: {str(e)}")

@app.get("/")
def read_root():
    return {"message": "SA Car Price Prediction API", "status": "running"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}

# MAIN: uvicorn.run(app, host="0.0.0.0", port=8000) for Render deployment
if __name__ == "__main__":
    import os
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
