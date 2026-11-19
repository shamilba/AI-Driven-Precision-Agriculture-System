import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/analysis_session.dart';

import '../../localization/app_localizations.dart';
import '../../services/language_service.dart';

class NotificationScreen extends StatelessWidget {
  String t(BuildContext context,String key){

  final language =
  Provider.of<LanguageService>(context)
      .language;


  return AppLocalizations.translate(
    key,
    language,
  );

}


const NotificationScreen({
super.key,
});



@override
Widget build(BuildContext context){


List<Map<String,String>> notifications = [];



// Fertilizer notification

if(AnalysisSession.fertilizer != "Not analyzed"){


notifications.add({

"title":
"fertilizer_notification",

"message":
"apply_fertilizer",

});


}



// Yield notification

if(AnalysisSession.yieldPrediction < 3){


notifications.add({

"title":
"yield_alert",

"message":
"low_yield",

});


}



// Irrigation notification

if(AnalysisSession.irrigation == "Recommended"){


notifications.add({

"title":
"irrigation_reminder",

"message":
"water_reminder",

});


}




return Scaffold(


appBar:

AppBar(

title:
Text(
t(context,"notifications")
),

),



body:

notifications.isEmpty

?


Center(

child:

Text(

t(context,"no_notifications"),


style:

TextStyle(

fontSize:18,

),

),

)



:

ListView.builder(


padding:

const EdgeInsets.all(20),



itemCount:

notifications.length,



itemBuilder:(context,index){



final item =
notifications[index];



return Card(


elevation:4,


margin:

const EdgeInsets.only(

bottom:15

),



child:

ListTile(


title:

Text(

t(context,item["title"]!),


style:

const TextStyle(

fontWeight:

FontWeight.bold,

),

),



subtitle:

Text(

t(context,item["message"]!),


),



),



);



},



),



);


}


}