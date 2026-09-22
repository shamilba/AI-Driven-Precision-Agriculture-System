import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../recommendation/recommendation_screen.dart';

class AnalysisLoadingScreen extends StatefulWidget {
  final String crop;

  final int n;
  final int p;
  final int k;

  final double temperature;
  final double humidity;
  final double ph;
  final double rainfall;

  const AnalysisLoadingScreen({
    super.key,
    required this.crop,
    required this.n,
    required this.p,
    required this.k,
    required this.temperature,
    required this.humidity,
    required this.ph,
    required this.rainfall,
  });

  @override
  State<AnalysisLoadingScreen> createState() =>
      _AnalysisLoadingScreenState();
}

class _AnalysisLoadingScreenState
    extends State<AnalysisLoadingScreen> {

  @override
  void initState() {
    super.initState();
    startAnalysis();
  }

  Future<void> startAnalysis() async {
    try {
      // Keep the loading screen visible for 3 seconds
      await Future.delayed(
        const Duration(seconds: 3),
      );

      final result = await ApiService.analyzeCrop(
        crop: widget.crop,
        n: widget.n,
        p: widget.p,
        k: widget.k,
        temperature: widget.temperature,
        humidity: widget.humidity,
        ph: widget.ph,
        rainfall: widget.rainfall,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RecommendationScreen(
            result: result,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Prediction failed: $e",
          ),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.smart_toy,
              size: 90,
              color: Colors.green,
            ),

            const SizedBox(height: 30),

            const Text(
              "AI is analyzing your crop 🌱",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}