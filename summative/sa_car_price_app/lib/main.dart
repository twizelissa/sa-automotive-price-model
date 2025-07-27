// IMPORTS: flutter/material.dart, http package for API calls, dart:convert for JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

// SETUP: MaterialApp with title "SA Car Price Prediction", home screen CarPredictionPage
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SA Car Price Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CarPredictionPage(),
    );
  }
}

class CarPredictionPage extends StatefulWidget {
  const CarPredictionPage({super.key});

  @override
  State<CarPredictionPage> createState() => _CarPredictionPageState();
}

class _CarPredictionPageState extends State<CarPredictionPage> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _engineSizeController = TextEditingController();
  
  // Luxury dropdown state
  int _isLuxury = 0;
  
  // Loading and result states
  bool _isLoading = false;
  String _result = '';
  String _errorMessage = '';

  // API endpoint - replace with your deployed URL
  static const String apiUrl = 'https://sa-automotive-price-model.onrender.com/predict';
  static const String fallbackApiUrl = 'http://sa-automotive-price-model.onrender.com/predict'; // HTTP fallback

  @override
  void dispose() {
    _brandController.dispose();
    _engineSizeController.dispose();
    super.dispose();
  }

  // INPUT VALIDATION: Brand required and non-empty, engine size between 1.0-6.0
  String? _validateBrand(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Brand is required and cannot be empty';
    }
    return null;
  }

  String? _validateEngineSize(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Engine size is required';
    }
    
    final double? engineSize = double.tryParse(value);
    if (engineSize == null) {
      return 'Please enter a valid number';
    }
    
    if (engineSize < 1.0 || engineSize > 6.0) {
      return 'Engine size must be between 1.0 and 6.0';
    }
    
    return null;
  }

  // API INTEGRATION: POST request to FastAPI endpoint with retry logic
  Future<void> _predictPrice() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '';
      _errorMessage = '';
    });

    // Try both HTTPS and HTTP endpoints
    final List<String> apiUrls = [apiUrl, fallbackApiUrl];
    
    for (int urlIndex = 0; urlIndex < apiUrls.length; urlIndex++) {
      String currentUrl = apiUrls[urlIndex];
      int maxRetries = 2;
      
      for (int currentRetry = 0; currentRetry <= maxRetries; currentRetry++) {
        try {
          // Create HTTP client with longer timeout
          final client = http.Client();
          
          // Send JSON with brand, engine_size, is_luxury fields
          final response = await client.post(
            Uri.parse(currentUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'User-Agent': 'Flutter App',
            },
            body: json.encode({
              'brand': _brandController.text.trim(),
              'engine_size': double.parse(_engineSizeController.text.trim()),
              'is_luxury': _isLuxury,
            }),
          ).timeout(Duration(seconds: 30)); // 30 second timeout

          client.close(); // Close the client

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final double price = data['predicted_price_zar'].toDouble();
            
            setState(() {
              // OUTPUT DISPLAY: Show predicted price in ZAR format
              _result = 'Predicted Price: R${price.toStringAsFixed(2)} ZAR';
              _isLoading = false;
              _errorMessage = '';
            });
            
            // FUNCTIONALITY: Clear form after prediction
            _clearForm();
            return; // Success, exit completely
          } else {
            // Handle API errors
            try {
              final errorData = json.decode(response.body);
              setState(() {
                _errorMessage = errorData['detail'] ?? 'Prediction failed (Status: ${response.statusCode})';
                _isLoading = false;
              });
            } catch (e) {
              setState(() {
                _errorMessage = 'Server error (Status: ${response.statusCode})';
                _isLoading = false;
              });
            }
            return; // API error, don't retry
          }
        } catch (e) {
          String errorMsg = e.toString();
          
          // If this is the last retry for the last URL, show final error
          if (urlIndex == apiUrls.length - 1 && currentRetry == maxRetries) {
            setState(() {
              if (errorMsg.contains('TimeoutException') || errorMsg.contains('timeout')) {
                _errorMessage = 'Server timeout: Unable to connect after trying both secure and standard connections.';
              } else if (errorMsg.contains('SocketException') || errorMsg.contains('NetworkException')) {
                _errorMessage = 'Network error: Please check your internet connection. Tried both HTTPS and HTTP.';
              } else if (errorMsg.contains('HandshakeException') || errorMsg.contains('TlsException')) {
                _errorMessage = 'SSL error: Secure connection failed. Please try again or check network settings.';
              } else {
                _errorMessage = 'Connection failed: ${errorMsg.length > 80 ? errorMsg.substring(0, 80) + "..." : errorMsg}';
              }
              _isLoading = false;
            });
            return;
          }
          
          // Wait before retry (only if not the last attempt)
          if (currentRetry < maxRetries) {
            await Future.delayed(Duration(seconds: 2));
          }
        }
      }
    }
  }

  // FUNCTIONALITY: Clear form after prediction
  void _clearForm() {
    _brandController.clear();
    _engineSizeController.clear();
    setState(() {
      _isLuxury = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // UI COMPONENTS: AppBar with title
      appBar: AppBar(
        title: const Text('SA Car Price Prediction'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        // STYLING: Clean Material Design, proper spacing
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Text(
                'Predict Your Car Price',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // UI COMPONENTS: 3 input fields - Brand TextFormField
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Car Brand',
                  hintText: 'e.g., Toyota, BMW, Audi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_car),
                ),
                validator: _validateBrand,
              ),
              const SizedBox(height: 20),

              // Engine size TextFormField with number input
              TextFormField(
                controller: _engineSizeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Engine Size (L)',
                  hintText: 'e.g., 2.0, 3.5',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.settings),
                  suffixText: 'L',
                ),
                validator: _validateEngineSize,
              ),
              const SizedBox(height: 20),

              // Luxury dropdown with Yes/No options
              DropdownButtonFormField<int>(
                value: _isLuxury,
                decoration: const InputDecoration(
                  labelText: 'Luxury Vehicle',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star),
                ),
                items: const [
                  DropdownMenuItem(value: 0, child: Text('No')),
                  DropdownMenuItem(value: 1, child: Text('Yes')),
                ],
                onChanged: (int? value) {
                  setState(() {
                    _isLuxury = value ?? 0;
                  });
                },
              ),
              const SizedBox(height: 30),

              // "Predict Price" ElevatedButton with loading state
              ElevatedButton(
                onPressed: _isLoading ? null : _predictPrice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Predicting...'),
                        ],
                      )
                    : const Text(
                        'Predict Price',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
              const SizedBox(height: 20),

              // Clear button
              if (!_isLoading)
                TextButton(
                  onPressed: () {
                    _clearForm();
                    setState(() {
                      _result = '';
                      _errorMessage = '';
                    });
                  },
                  child: const Text('Clear Form'),
                ),
              const SizedBox(height: 20),

              // Result display Card
              if (_result.isNotEmpty)
                Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _result,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

              // Error message display
              if (_errorMessage.isNotEmpty)
                Card(
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _errorMessage,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // Information card
              Card(
                color: Colors.blue[50],
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info,
                        color: Colors.blue,
                        size: 30,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'This app predicts car prices for the South African market using machine learning.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
