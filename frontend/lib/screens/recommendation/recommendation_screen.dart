import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {
  final Map<String,dynamic> result;
final String selectedCrop;

final double temperature;
final double humidity;
final double rainfall;

  const RecommendationScreen({
  super.key,
  required this.result,
  required this.selectedCrop,
  required this.temperature,
  required this.humidity,
  required this.rainfall,
});

  Widget buildResultCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(result);

    final cropResult = result["crop_prediction"] ?? {};
    final fertilizerResult =
        result["fertilizer_recommendation"] ?? {};

    final aiCrop =
        cropResult["recommended_crop"]?.toString() ??
            "Not Available";

    final fertilizer =
        fertilizerResult["recommended_fertilizer"]?.toString() ??
            "Not Available";

    final yieldResult =
    result["yield_prediction"] ?? {};

    final bool sameCrop =
        aiCrop.toLowerCase() == selectedCrop.toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Recommendation"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Icon(
              Icons.smart_toy,
              size: 80,
              color: Colors.green,
            ),

            const SizedBox(height: 15),

            const Text(
              "AI Analysis Completed",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            buildResultCard(
              "Selected Crop",
              selectedCrop,
              Icons.agriculture,
              Colors.green,
            ),

            buildResultCard(
              "AI Suggested Crop",
              aiCrop,
              Icons.grass,
              Colors.teal,
            ),

            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.tips_and_updates,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        sameCrop
                            ? "Excellent! The AI recommends continuing with $selectedCrop because the soil nutrients and climate are suitable."
                            : "The AI suggests growing $aiCrop instead of $selectedCrop because it is expected to perform better under the given soil and climate conditions.",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            buildResultCard(
              "Expected Soil Condition",
              "Suitable based on AI soil analysis",
              Icons.landscape,
              Colors.brown,
            ),

            buildResultCard(
  "Climate Analysis",
  "Temperature: ${temperature.toString()}°C\n"
  "Humidity: ${humidity.toString()}%\n"
  "Rainfall: ${rainfall.toString()} mm\n\n"
  "Condition: Suitable climate conditions for crop growth.",
  Icons.cloud,
  Colors.blue,
),

            buildResultCard(
              "Recommended Fertilizer",
              fertilizer,
              Icons.eco,
              Colors.orange,
            ),

            buildResultCard(

  "Expected Yield",

  "${yieldResult["predicted_yield_tons_per_hectare"] ?? "N/A"} Tons/hectare\n"
  "Estimated Production: "
  "${yieldResult["estimated_total_production_tons"] ?? "N/A"} Tons",

  Icons.bar_chart,

  Colors.purple,

),

            const SizedBox(height: 20),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "AI Recommendations",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text("• Selected Crop : $selectedCrop"),

                    Text("• AI Suggested Crop : $aiCrop"),

                    Text(
                        "• Apply Fertilizer : $fertilizer"),

                    const Text(
                        "• Maintain proper irrigation."),

                    const Text(
                        "• Monitor soil moisture regularly."),

                    const Text(
                        "• Continue regular crop health monitoring."),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}