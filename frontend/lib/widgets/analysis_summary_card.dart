import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/app_localizations.dart';
import '../services/language_service.dart';



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





String t(BuildContext context,String key){


final language =

Provider.of<LanguageService>(context)
.language;



return AppLocalizations.translate(

key,

language,

);



}





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




Text(

"🌱 ${t(context,"latest_analysis")}",


style:

const TextStyle(

fontSize:20,

fontWeight:

FontWeight.bold,

),

),





const SizedBox(height:15),






Text(

"${t(context,"selected_crop")}: $crop"

),





Text(

"${t(context,"recommended_crop")}: $recommendedCrop"

),






Text(

"${t(context,"fertilizer")}: $fertilizer"

),






Text(

"${t(context,"expected_yield")}: $yieldValue Tons/Ha"

),




],



),



),



);



}



}