import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {

  final Map<String,dynamic> result;

  const RecommendationScreen({
    super.key,
    required this.result,
  });


  Widget buildResultCard(
      String title,
      String value,
      IconData icon,
      Color color) {

    return Card(
      elevation: 3,
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

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Analysis Result",
        ),
      ),


      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

  buildResultCard(
    "Crop Health",
    result["health"]?.toString() ?? "Unknown",
    Icons.local_florist,
    Colors.green,
  ),

  buildResultCard(
    "Disease Status",
    result["disease"]?.toString() ?? "Unknown",
    Icons.warning,
    Colors.red,
  ),

  buildResultCard(
    "Recommended Crop",
    result["recommended_crop"]?.toString() ?? "Not Available",
    Icons.grass,
    Colors.green,
  ),

  buildResultCard(
    "Yield Prediction",
    result["yield_prediction"] != null
        ? "${result["yield_prediction"]} Tons/Hectare"
        : "Not Available",
    Icons.bar_chart,
    Colors.blue,
  ),

  buildResultCard(
    "Fertilizer",
    result["recommended_fertilizer"]?.toString() ?? "Not Available",
    Icons.eco,
    Colors.orange,
  ),

  buildResultCard(
    "Irrigation",
    result["irrigation"]?.toString() ?? "Not Available",
    Icons.water_drop,
    Colors.cyan,
  ),

],

        ),

      ),

    );
  }
}