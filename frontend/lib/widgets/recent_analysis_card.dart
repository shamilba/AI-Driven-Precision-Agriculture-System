import 'package:flutter/material.dart';


class RecentAnalysisCard extends StatelessWidget {


final List<dynamic> analyses;


const RecentAnalysisCard({

super.key,

required this.analyses,

});



@override
Widget build(BuildContext context){


return Card(

elevation:4,


shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(18),

),



child:

Padding(

padding:
const EdgeInsets.all(16),



child:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[


const Text(

"📜 Recent Analyses",

style:

TextStyle(

fontSize:20,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:15),



...analyses.take(3).map((item){


return ListTile(

contentPadding:
EdgeInsets.zero,


leading:

const CircleAvatar(

child:

Icon(Icons.eco),

),



title:

Text(

item["selected_crop"] ?? "",

),



subtitle:

Text(

"AI Crop: ${item["recommended_crop"]}\n"
"Yield: ${item["yield_prediction"]} Tons/Ha",

),



);


}).toList(),



],


),


),


);



}

}