import 'package:flutter/material.dart';


class HistoryScreen extends StatelessWidget {


const HistoryScreen({super.key});


@override
Widget build(BuildContext context){


return Scaffold(

appBar:

AppBar(

title:
const Text("Analysis History"),

),



body:

ListView(

padding:
const EdgeInsets.all(20),



children:[



Card(

child:

ListTile(

leading:

const Icon(

Icons.eco,

color:
Colors.green,

),



title:

const Text(
"Rice Analysis",
),



subtitle:

const Text(

"Healthy | 4.8 Tons/Hectare",

),


),

),



Card(

child:

ListTile(

leading:

const Icon(

Icons.grass,

color:
Colors.orange,

),



title:

const Text(
"Wheat Analysis",
),



subtitle:

const Text(

"Good Condition | 4.2 Tons/Hectare",

),


),

),



],

),

);

}

}