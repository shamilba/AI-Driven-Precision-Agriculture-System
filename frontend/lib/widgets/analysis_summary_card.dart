import 'package:flutter/material.dart';


class AnalysisSummaryCard extends StatelessWidget {


final String crop;

final String recommendedCrop;

final String fertilizer;

final String yieldValue;



const AnalysisSummaryCard({

super.key,

required this.crop,

required this.recommendedCrop,

required this.fertilizer,

required this.yieldValue,

});




@override
Widget build(BuildContext context){


return Card(

elevation:5,


shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(20),

),



child:

Padding(

padding:
const EdgeInsets.all(20),



child:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children:[


const Text(

"🌱 Latest AI Analysis",

style:

TextStyle(

fontSize:20,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:15),



Text(
"Selected Crop: $crop"
),


Text(
"Recommended Crop: $recommendedCrop"
),


Text(
"Fertilizer: $fertilizer"
),


Text(
"Expected Yield: $yieldValue Tons/Ha"
),



],

),


),


);



}

}