from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import uvicorn
import os

app = FastAPI(title="SA Car Price Prediction API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "SA Car Price Prediction API", "status": "running"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.get("/test")
def test_imports():
    try:
        import numpy as np
        import pandas as pd
        import joblib
        return {
            "numpy": np.__version__,
            "pandas": pd.__version__, 
            "joblib": joblib.__version__,
            "status": "all imports successful"
        }
    except Exception as e:
        return {"error": str(e), "status": "import failed"}

class CarInput(BaseModel):
    brand: str = Field(min_length=1, example="Toyota")
    engine_size: float = Field(ge=1.0, le=6.0, example=2.0)
    is_luxury: int = Field(ge=0, le=1, example=0)

@app.post("/predict")
def predict_car_price(car_input: CarInput):
    try:
        # Try to load models
        import joblib
        import numpy as np
        import pandas as pd
        
        BASE_DIR = os.path.dirname(os.path.abspath(__file__))
        
        model = joblib.load(os.path.join(BASE_DIR, 'best_car_price_model.pkl'))
        scaler = joblib.load(os.path.join(BASE_DIR, 'price_scaler.pkl'))
        encoder = joblib.load(os.path.join(BASE_DIR, 'brand_encoder.pkl'))
        
        # Handle unknown brands
        try:
            brand_encoded = encoder.transform([car_input.brand])[0]
        except ValueError:
            brand_encoded = 0
        
        # Create DataFrame
        features = pd.DataFrame([[brand_encoded, car_input.engine_size, car_input.is_luxury]],
                               columns=["Brand_Encoded", "Engine_Size", "Is_Luxury"])
        
        # Scale and predict
        features_scaled = scaler.transform(features)
        prediction_log = model.predict(features_scaled)[0]
        predicted_price = np.exp(prediction_log)
        
        return {
            "predicted_price_zar": round(max(0, predicted_price), 2),
            "currency": "ZAR"
        }
        
    except FileNotFoundError as e:
        raise HTTPException(status_code=500, detail=f"Model file not found: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Prediction error: {str(e)}")

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
