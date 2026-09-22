import 'package:flutter/material.dart';



class AboutScreen extends StatelessWidget {


const AboutScreen({super.key});


@override

Widget build(BuildContext context){


return Scaffold(

appBar:

AppBar(

title:
const Text("About"),

),



body:

Padding(

padding:
const EdgeInsets.all(20),


child:

Column(

children:[



const Icon(

Icons.agriculture,

size:100,

color:Colors.green,

),



const SizedBox(height:20),



const Text(

"AI-Driven Precision Agriculture System",

textAlign:
TextAlign.center,


style:

TextStyle(

fontSize:24,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:20),



const Text(

"This application uses Artificial Intelligence to monitor crop health, predict yield and provide smart farming recommendations.",

textAlign:
TextAlign.center,

style:

TextStyle(

fontSize:16,

),

),

]

),

),

);

}

}