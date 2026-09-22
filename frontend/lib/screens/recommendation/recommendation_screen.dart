import 'package:flutter/material.dart';



class RecommendationScreen extends StatelessWidget {


const RecommendationScreen({super.key});



Widget buildCard(

String title,

String value,

IconData icon,

Color color,

){


return Card(

elevation:4,

margin:
const EdgeInsets.only(bottom:15),


shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(18),

),



child:

Padding(

padding:
const EdgeInsets.all(18),



child:

Row(

children:[


Container(

padding:
const EdgeInsets.all(12),


decoration:

BoxDecoration(

color:
color.withOpacity(0.15),

borderRadius:
BorderRadius.circular(15),

),


child:

Icon(

icon,

color:color,

size:30,

),

),



const SizedBox(width:20),



Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[


Text(

title,

style:

const TextStyle(

fontWeight:
FontWeight.bold,

fontSize:16,

),

),



const SizedBox(height:5),



Text(

value,

style:

TextStyle(

color:
Colors.grey[700],

fontSize:15,

),

),



],

)



],

),

),

);

}





@override

Widget build(BuildContext context){



return Scaffold(


appBar:

AppBar(

title:
const Text("AI Prediction"),

),



body:

SingleChildScrollView(


padding:
const EdgeInsets.all(20),



child:

Column(

children:[



const Text(
"AI Crop Analysis Completed ✅",




style:

TextStyle(

fontSize:22,

fontWeight:
FontWeight.bold,

),

),
const SizedBox(height:5),

const Text(
"Based on crop data and environmental conditions",
style: TextStyle(
color: Colors.grey,
),
),



const SizedBox(height:20),



Stack(

alignment:
Alignment.center,


children:[


SizedBox(

height:150,

width:150,


child:

CircularProgressIndicator(

value:0.92,

strokeWidth:12,

color:
Colors.green,

),

),



const Text(

"92%",

style:

TextStyle(

fontSize:32,

fontWeight:
FontWeight.bold,

),

),



],

),



const SizedBox(height:30),



buildCard(

"Health Status",

"Healthy 🌿",

Icons.eco,

Colors.green,

),



buildCard(

"Disease Detection",

"No Disease Found",

Icons.health_and_safety,

Colors.blue,

),



buildCard(

"Yield Prediction",

"4.8 Tons / Hectare",

Icons.bar_chart,

Colors.orange,

),



buildCard(

"Fertilizer Recommendation",

"NPK 20-20-20",

Icons.grass,

Colors.green,

),



buildCard(

"Irrigation Advice",

"Water after 2 Days",

Icons.water_drop,

Colors.cyan,

),



],

),

),

);

}

}