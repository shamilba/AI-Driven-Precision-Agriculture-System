import 'package:flutter/material.dart';

import '../analysis/analysis_loading_screen.dart';


class CropHealthScreen extends StatefulWidget {

  const CropHealthScreen({super.key});


  @override
  State<CropHealthScreen> createState() =>
      _CropHealthScreenState();

}



class _CropHealthScreenState 
extends State<CropHealthScreen>{


final formKey = GlobalKey<FormState>();


String selectedCrop = "Rice";

String selectedSoil = "Loamy";


bool loading = false;



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

title: const Text(
"Crop Analysis",
),

),



body: Padding(


padding: const EdgeInsets.all(20),



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

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:10),



const Text(

"Enter soil and environmental details for AI prediction",

style: TextStyle(

color: Colors.grey,

),

),



const SizedBox(height:25),




// CROP DROPDOWN


DropdownButtonFormField<String>(


value:selectedCrop,


decoration: InputDecoration(

labelText:"Select Crop",

prefixIcon:
const Icon(Icons.grass),


border: OutlineInputBorder(

borderRadius:
BorderRadius.circular(15),

),

),



items:

crops.map((crop){


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



const SizedBox(height:20),





// SOIL DROPDOWN


DropdownButtonFormField<String>(


value:selectedSoil,


decoration: InputDecoration(

labelText:"Soil Type",

prefixIcon:
const Icon(Icons.landscape),


border: OutlineInputBorder(

borderRadius:
BorderRadius.circular(15),

),

),



items:

soils.map((soil){


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



const SizedBox(height:20),





buildField(

controller:nController,

label:"Nitrogen (N)",

icon:Icons.science,

),



const SizedBox(height:20),



buildField(

controller:pController,

label:"Phosphorus (P)",

icon:Icons.science,

),



const SizedBox(height:20),



buildField(

controller:kController,

label:"Potassium (K)",

icon:Icons.science,

),



const SizedBox(height:20),



buildField(

controller:temperatureController,

label:"Temperature",

icon:Icons.thermostat,

),



const SizedBox(height:20),



buildField(

controller:humidityController,

label:"Humidity",

icon:Icons.water_drop,

),



const SizedBox(height:20),



buildField(

controller:phController,

label:"Soil pH",

icon:Icons.landscape,

),



const SizedBox(height:20),



buildField(

controller:moistureController,

label:"Soil Moisture",

icon:Icons.water,

),



const SizedBox(height:20),



buildField(

controller:rainfallController,

label:"Rainfall",

icon:Icons.cloud,

),





const SizedBox(height:30),





SizedBox(


width:double.infinity,


child:ElevatedButton(


onPressed: analyzeCrop,



child:


const Text(

"Analyze with AI 🤖",

style:TextStyle(

fontSize:18,

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






Widget buildField({


required TextEditingController controller,


required String label,


required IconData icon,


}){


return TextFormField(


controller:controller,


keyboardType:
TextInputType.number,



validator:(value){


if(value==null || value.isEmpty){


return "Required field";


}


return null;


},



decoration:InputDecoration(


labelText:label,


prefixIcon:Icon(icon),



border:OutlineInputBorder(

borderRadius:
BorderRadius.circular(15),

),


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


builder: (_) => AnalysisLoadingScreen(



crop:selectedCrop,



n:int.parse(
nController.text
),



p:int.parse(
pController.text
),



k:int.parse(
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