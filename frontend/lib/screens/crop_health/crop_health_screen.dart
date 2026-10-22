import 'package:flutter/material.dart';

import '../analysis/analysis_loading_screen.dart';


class CropHealthScreen extends StatefulWidget {

  const CropHealthScreen({super.key});


  @override
  State<CropHealthScreen> createState() =>
      _CropHealthScreenState();

}



class _CropHealthScreenState extends State<CropHealthScreen>{


final formKey = GlobalKey<FormState>();


String selectedCrop = "Rice";

String selectedSoil = "Loamy";



final crops = [

  "Rice",
  "Wheat",
  "Maize",
  "Tomato",
  "Potato"

];


final soils = [

  "Loamy",
  "Clay",
  "Sandy",
  "Black"

];



// Controllers

final nController = TextEditingController();

final pController = TextEditingController();

final kController = TextEditingController();

final temperatureController =
TextEditingController();

final humidityController =
TextEditingController();

final phController =
TextEditingController();

final rainfallController =
TextEditingController();

final moistureController =
TextEditingController();





@override
Widget build(BuildContext context){


return Scaffold(


appBar: AppBar(

backgroundColor: Colors.green,

title: const Text(

"Crop Analysis",

style: TextStyle(
fontWeight: FontWeight.bold,
),

),

),



body: Padding(

padding:
const EdgeInsets.all(16),



child: Form(

key: formKey,


child: SingleChildScrollView(


child: Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children: [



const Text(

"Analyze Your Crop 🌱",

style: TextStyle(

fontSize:26,

fontWeight: FontWeight.bold,

),

),



const SizedBox(height:8),



const Text(

"Enter farm details to get AI based recommendations",

style: TextStyle(

color: Colors.grey,

),

),



const SizedBox(height:20),





// ===========================
// CROP INFORMATION
// ===========================


buildSectionCard(

title:"Crop Information",

icon:Icons.agriculture,


children:[


DropdownButtonFormField<String>(

value:selectedCrop,


decoration:
inputDecoration(
"Select Crop",
Icons.grass,
),


items:crops.map((crop){


return DropdownMenuItem(

value:crop,

child:Text(crop),

);


}).toList(),



onChanged:(value){

setState((){

selectedCrop=value!;

});

},


),



const SizedBox(height:15),



DropdownButtonFormField<String>(

value:selectedSoil,


decoration:
inputDecoration(
"Soil Type",
Icons.landscape,
),


items:soils.map((soil){


return DropdownMenuItem(

value:soil,

child:Text(soil),

);


}).toList(),



onChanged:(value){

setState((){

selectedSoil=value!;

});

},


),


],


),





// ===========================
// SOIL NUTRIENTS
// ===========================


buildSectionCard(

title:"Soil Nutrients 🧪",

icon:Icons.science,


children:[


buildField(

controller:nController,

label:"Nitrogen (N)",

icon:Icons.science,

hint:"Recommended: 0 - 140 kg/ha",

min:0,

max:140,

),



const SizedBox(height:15),



buildField(

controller:pController,

label:"Phosphorus (P)",

icon:Icons.science,

hint:"Recommended: 5 - 145 kg/ha",

min:5,

max:145,

),



const SizedBox(height:15),



buildField(

controller:kController,

label:"Potassium (K)",

icon:Icons.science,

hint:"Recommended: 5 - 205 kg/ha",

min:5,

max:205,

),


],

),






// ===========================
// ENVIRONMENT
// ===========================


buildSectionCard(

title:"Environmental Conditions 🌦",

icon:Icons.cloud,


children:[


buildField(

controller:temperatureController,

label:"Temperature",

icon:Icons.thermostat,

hint:"Recommended: 15 - 40 °C",

min:15,

max:40,

),



const SizedBox(height:15),



buildField(

controller:humidityController,

label:"Humidity",

icon:Icons.water_drop,

hint:"Recommended: 20 - 100 %",

min:20,

max:100,

),



const SizedBox(height:15),



buildField(

controller:rainfallController,

label:"Rainfall",

icon:Icons.cloud,

hint:"Recommended: 20 - 300 mm",

min:20,

max:300,

),


],


),






// ===========================
// SOIL CONDITION
// ===========================


buildSectionCard(

title:"Soil Condition 💧",

icon:Icons.water,


children:[


buildField(

controller:phController,

label:"Soil pH",

icon:Icons.landscape,

hint:"Recommended: 3.5 - 9.5",

min:3.5,

max:9.5,

),



const SizedBox(height:15),



buildField(

controller:moistureController,

label:"Soil Moisture",

icon:Icons.water,

hint:"Recommended: 10 - 80 %",

min:10,

max:80,

),


],


),






const SizedBox(height:10),



SizedBox(

width:double.infinity,


child:ElevatedButton(


style:
ElevatedButton.styleFrom(

backgroundColor:
Colors.green,


padding:
const EdgeInsets.symmetric(
vertical:15,
),


shape:
RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(15),

),

),



onPressed:analyzeCrop,


child:const Text(

"Analyze Crop 🌱",

style:TextStyle(

fontSize:18,

color:Colors.white,

fontWeight:FontWeight.bold,

),

),



),

),



],

),

),

),

),

);

}







Widget buildSectionCard({

required String title,

required IconData icon,

required List<Widget> children,

}){


return Card(

elevation:4,

margin:
const EdgeInsets.only(
bottom:20,
),


shape:
RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(20),

),


child:Padding(

padding:
const EdgeInsets.all(16),


child:Column(


crossAxisAlignment:
CrossAxisAlignment.start,


children:[



Row(

children:[


Icon(

icon,

color:Colors.green,

),


const SizedBox(width:10),



Text(

title,

style:
const TextStyle(

fontSize:20,

fontWeight:
FontWeight.bold,

),

),


],

),



const SizedBox(height:15),



...children,


],


),


),


);


}








Widget buildField({

required TextEditingController controller,

required String label,

required IconData icon,

required String hint,

double? min,

double? max,

}){


return TextFormField(


controller:controller,


keyboardType:
TextInputType.number,


validator:(value){


if(value==null || value.isEmpty){

return "Required field";

}



double number =
double.tryParse(value) ?? -1;



if(min!=null && max!=null){


if(number < min || number > max){

return "Enter value between $min - $max";

}

}


return null;


},


decoration:
InputDecoration(


labelText:label,

helperText:hint,


prefixIcon:
Icon(icon),


border:
OutlineInputBorder(

borderRadius:
BorderRadius.circular(15),

),


),


);


}






InputDecoration inputDecoration(

String label,

IconData icon

){

return InputDecoration(

labelText:label,

prefixIcon:
Icon(icon),


border:
OutlineInputBorder(

borderRadius:
BorderRadius.circular(15),

),

);

}







Future<void> analyzeCrop() async {


if(!formKey.currentState!.validate()){

return;

}



Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>AnalysisLoadingScreen(


crop:selectedCrop,


n:double.parse(
nController.text
),

p:double.parse(
pController.text
),

k:double.parse(
kController.text
),


temperature:double.parse(
temperatureController.text
),


humidity:double.parse(
humidityController.text
),


ph:double.parse(
phController.text
),


rainfall:double.parse(
rainfallController.text
),


soilType:selectedSoil,


soilMoisture:double.parse(
moistureController.text
),


),


),

);


}



}