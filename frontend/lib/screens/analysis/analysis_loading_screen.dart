import 'dart:async';
import 'package:flutter/material.dart';

import '../recommendation/recommendation_screen.dart';
import '../../services/api_service.dart';

class AnalysisLoadingScreen extends StatefulWidget {
  final String crop;

  final double n;
  final double p;
  final double k;

  final double temperature;
  final double humidity;
  final double ph;
  final double rainfall;

  final String soilType;
  final double soilMoisture;

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
    required this.soilType,
    required this.soilMoisture,
  });

  @override
  State<AnalysisLoadingScreen> createState() =>
      _AnalysisLoadingScreenState();
}

class _AnalysisLoadingScreenState
    extends State<AnalysisLoadingScreen> {

  Timer? timer;

  String message = "Analyzing soil data...";

  @override
  void initState() {
    super.initState();
    startAnalysis();
  }

  void startAnalysis() {
    timer = Timer.periodic(
      const Duration(seconds: 2),
      (t) {
        if (!mounted) {
          t.cancel();
          return;
        }

        setState(() {
          if (message == "Analyzing soil data...") {
            message = "Predicting best crop...";
          } else if (message == "Predicting best crop...") {
            message = "Generating fertilizer...";
          } else if (message == "Generating fertilizer...") {
            message = "Predicting crop yield...";
          } else {
            message = "Preparing report...";
          }
        });
      },
    );

    runAIAnalysis();
  }

  Future<void> runAIAnalysis() async {
    try {
      //-----------------------------------------
      // 1. Crop Prediction
      //-----------------------------------------

      final cropResult = await ApiService.recommendCrop(
        n: widget.n,
        p: widget.p,
        k: widget.k,
        temperature: widget.temperature,
        humidity: widget.humidity,
        ph: widget.ph,
        rainfall: widget.rainfall,
      );

      //-----------------------------------------
      // 2. Fertilizer Prediction
      //-----------------------------------------

      final fertilizerResult =
          await ApiService.recommendFertilizer(
        soilType: widget.soilType,
        soilPh: widget.ph,
        soilMoisture: widget.soilMoisture,
        organicCarbon: 0,
        electricalConductivity: 0,
        nitrogenLevel: widget.n,
        phosphorusLevel: widget.p,
        potassiumLevel: widget.k,
        temperature: widget.temperature,
        humidity: widget.humidity,
        rainfall: widget.rainfall,
        cropType: widget.crop,
        cropGrowthStage: "Vegetative",
        season: "Kharif",
        irrigationType: "Drip",
        previousCrop: widget.crop,
        region: "Karnataka",
        fertilizerUsedLastSeason: 0,
        yieldLastSeason: 0,
      );

      //-----------------------------------------
      // 3. Yield Prediction
      //-----------------------------------------

      final yieldResult =
          await ApiService.recommendYield(
        state: "Karnataka",
        crop: widget.crop,
        season: "Kharif",
        area: 1,
        rainfall: widget.rainfall,
        fertilizer: 50,
        pesticide: 20,
        temperature: widget.temperature,
      );

      //-----------------------------------------
      // Combine everything
      //-----------------------------------------

      final result = {
        "crop_prediction": cropResult,
        "fertilizer_recommendation": fertilizerResult,
        "yield_prediction": yieldResult,
      };

      // -----------------------------------------
// 4. Save Analysis History
// -----------------------------------------

await ApiService.saveAnalysisHistory(

  crop: widget.crop,

  result: result,

  temperature: widget.temperature,

  humidity: widget.humidity,

  rainfall: widget.rainfall,

);

      timer?.cancel();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RecommendationScreen(
            selectedCrop: widget.crop,
            result: result,
            temperature: widget.temperature,
            humidity: widget.humidity,
            rainfall: widget.rainfall,
          ),
        ),
      );
    } catch (e) {
      timer?.cancel();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Analysis Failed\n$e"),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
            const SizedBox(height: 25),
            const Text(
              "AI Crop Analysis",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            const CircularProgressIndicator(),
            const SizedBox(height: 25),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                message,
                key: ValueKey(message),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}