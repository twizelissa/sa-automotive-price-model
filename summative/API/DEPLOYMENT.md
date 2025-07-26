# 🚀 Render Deployment Guide for SA Car Price API

## 📋 Pre-deployment Checklist

✅ **Files Required for Deployment:**
- `main.py` - FastAPI application
- `requirements.txt` - Python dependencies  
- `render.yaml` - Render service configuration
- `runtime.txt` - Python version specification
- `best_car_price_model.pkl` - Trained model
- `price_scaler.pkl` - Feature scaler
- `brand_encoder.pkl` - Brand encoder

## 🌐 Deploy to Render

### Option 1: Deploy from GitHub Repository (Recommended)

1. **Push your code to GitHub:**
   ```bash
   git add .
   git commit -m "Add FastAPI deployment files"
   git push origin master
   ```

2. **Create Render Account:**
   - Go to [render.com](https://render.com)
   - Sign up or log in with your GitHub account

3. **Create New Web Service:**
   - Click "New +" → "Web Service"
   - Connect your GitHub repository: `twizelissa/sa-automotive-price-model`
   - Choose the `master` branch
   - Set Root Directory: `summative/API`

4. **Configure Service:**
   - **Name:** `sa-car-price-api`
   - **Region:** Choose closest to your users
   - **Branch:** `master`
   - **Runtime:** `Python 3`
   - **Build Command:** `pip install -r requirements.txt`
   - **Start Command:** `uvicorn main:app --host 0.0.0.0 --port $PORT`

### Option 2: Deploy from Git Repository

1. **Create new Web Service on Render**
2. **Connect Git Repository:**
   - Repository URL: `https://github.com/twizelissa/sa-automotive-price-model`
   - Branch: `master`
   - Root Directory: `summative/API`

## ⚙️ Service Configuration

**Environment Variables:** (Auto-detected from `render.yaml`)
- `PORT` - Auto-assigned by Render
- `PYTHON_VERSION` - 3.10.12

**Scaling:**
- **Free Plan:** Limited to 750 hours/month, sleeps after 15 min of inactivity
- **Paid Plans:** No sleep, custom scaling options

## 🔍 Post-Deployment Testing

Once deployed, your API will be available at:
```
https://sa-car-price-api.onrender.com
```

**Test Endpoints:**

1. **Health Check:**
   ```bash
   curl https://sa-car-price-api.onrender.com/health
   ```

2. **Prediction Test:**
   ```bash
   curl -X POST "https://sa-car-price-api.onrender.com/predict" \
        -H "Content-Type: application/json" \
        -d '{
          "brand": "Toyota",
          "engine_size": 2.0,
          "is_luxury": 0
        }'
   ```

3. **API Documentation:**
   ```
   https://sa-car-price-api.onrender.com/docs
   ```

## 🛠️ Troubleshooting

**Common Issues:**

1. **Build Failures:**
   - Check `requirements.txt` for version conflicts
   - Ensure all model files are committed to repository

2. **Memory Issues:**
   - Model files are large (~25MB total)
   - Consider upgrading to paid plan if needed

3. **Slow Cold Starts:**
   - Free plan: First request after sleep takes ~30 seconds
   - Keep-alive solution: Use a service like UptimeRobot

**Logs Access:**
- Go to Render Dashboard → Your Service → Logs
- Monitor real-time deployment and runtime logs

## 📊 Performance Expectations

**Response Times:**
- **Cold Start:** ~30 seconds (free plan)
- **Warm Requests:** ~200-500ms
- **Model Loading:** ~2-3 seconds

**Limitations (Free Plan):**
- 750 hours/month
- 512 MB RAM
- Sleeps after 15 minutes of inactivity

## 🔄 Updates & Maintenance

**To Update Your API:**
1. Make changes to your code
2. Commit and push to GitHub
3. Render automatically redeploys

**Manual Redeploy:**
- Go to Render Dashboard → Your Service → Manual Deploy

## 📱 Integration Examples

**JavaScript/React:**
```javascript
const predictPrice = async (carData) => {
  const response = await fetch('https://sa-car-price-api.onrender.com/predict', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(carData)
  });
  return response.json();
};
```

**Python:**
```python
import requests

response = requests.post(
    'https://sa-car-price-api.onrender.com/predict',
    json={'brand': 'BMW', 'engine_size': 3.0, 'is_luxury': 1}
)
print(response.json())
```

## 🎯 Success Metrics

Your API is successfully deployed when:
- ✅ Health endpoint returns `{"status": "healthy"}`
- ✅ Prediction endpoint returns price predictions
- ✅ Swagger UI loads at `/docs`
- ✅ No errors in Render logs

---

**Need Help?** 
- Render Documentation: [docs.render.com](https://docs.render.com)
- FastAPI Documentation: [fastapi.tiangolo.com](https://fastapi.tiangolo.com)
