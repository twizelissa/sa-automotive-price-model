# SA Car Price Prediction API

A FastAPI application for predicting South African car prices using machine learning models.

## Features

- **POST /predict**: Predict car price based on brand, engine size, and luxury status
- **GET /**: API information and status
- **GET /health**: Health check endpoint
- CORS enabled for all origins
- Error handling for missing models and prediction errors

## Installation

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Ensure model files are present:
- `best_car_price_model.pkl`
- `price_scaler.pkl`
- `brand_encoder.pkl`

## Usage

### Start the API server:
```bash
python main.py
```

The API will be available at `http://localhost:8000`

### API Documentation:
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

### Example Request:
```bash
curl -X POST "http://localhost:8000/predict" \
     -H "Content-Type: application/json" \
     -d '{
       "brand": "Toyota",
       "engine_size": 2.0,
       "is_luxury": 0
     }'
```

### Example Response:
```json
{
  "predicted_price_zar": 185420.75,
  "currency": "ZAR"
}
```

## Model Input Parameters

- **brand** (string): Car brand name (e.g., "Toyota", "BMW")
- **engine_size** (float): Engine size in liters (1.0 - 6.0)
- **is_luxury** (integer): 1 for luxury brands, 0 for non-luxury (0 or 1)

## Deployment

This API is configured for deployment on Render.com with:
- Host: `0.0.0.0`
- Port: `8000`
- CORS enabled for all origins

## Error Handling

- **500**: Model file not found
- **400**: Invalid input or prediction error

## Model Information

The API uses a machine learning model trained on South African car data with features:
- Brand encoding
- Engine size
- Luxury brand indicator

The model predicts log-transformed prices and converts them back to ZAR currency.
