import 'package:flutter/material.dart';
import '../analysis/analysis_loading_screen.dart';
import '../../services/api_service.dart';

class CropHealthScreen extends StatefulWidget {
  

  const CropHealthScreen({super.key});


  @override
  State<CropHealthScreen> createState()
  => _CropHealthScreenState();

}



class _CropHealthScreenState
extends State<CropHealthScreen>{
  final ApiService apiService = ApiService();


final _formKey = GlobalKey<FormState>();


String selectedCrop = "Rice";


final crops = [

  "Rice",
  "Wheat",
  "Maize",
  "Tomato",
  "Potato"

];



final locationController = TextEditingController();

final soilController = TextEditingController();

final areaController = TextEditingController();



@override
Widget build(BuildContext context){


return Scaffold(

appBar: AppBar(

title: const Text("Crop Analysis"),

),



body: Padding(

padding: const EdgeInsets.all(20),



child: Form(

key: _formKey,


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

"Provide crop details for AI prediction",

style: TextStyle(

color: Colors.grey,

),

),



const SizedBox(height:25),



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



TextFormField(

controller:
locationController,


decoration: InputDecoration(

labelText:"Farm Location",

prefixIcon:
const Icon(Icons.location_on),


border:OutlineInputBorder(

borderRadius:
BorderRadius.circular(15),

),

),



validator:(value){


if(value==null || value.isEmpty){

return "Please enter farm location";

}


return null;

},


),



const SizedBox(height:20),



TextFormField(

controller:
soilController,


decoration: InputDecoration(

labelText:"Soil Type",

prefixIcon:
const Icon(Icons.landscape),


border:OutlineInputBorder(

borderRadius:
BorderRadius.circular(15),

),

),



validator:(value){


if(value==null || value.isEmpty){

return "Please enter soil type";

}


return null;

},


),



const SizedBox(height:20),



TextFormField(

controller:
areaController,


keyboardType:
TextInputType.number,


decoration: InputDecoration(

labelText:"Farm Area (acres)",

prefixIcon:
const Icon(Icons.square_foot),


border:OutlineInputBorder(

borderRadius:
BorderRadius.circular(15),

),

),



validator:(value){


if(value==null || value.isEmpty){

return "Please enter farm area";

}


return null;

},


),



const Spacer(),



SizedBox(

width:double.infinity,


child:ElevatedButton(


onPressed:() async {


if(_formKey.currentState!.validate()){


await apiService.analyzeCrop();



Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>

const AnalysisLoadingScreen(),

),

);


}


},



child:const Text(

"Analyze with AI 🤖",

style:

TextStyle(

fontSize:18,

),

),



),


)



],

),

),

),

);

}

}