import 'package:flutter/material.dart';

import '../../services/analysis_session.dart';


class NotificationScreen extends StatelessWidget {


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
"🌱 Fertilizer Recommendation",

"message":
"Apply ${AnalysisSession.fertilizer} for better growth",

});


}



// Yield notification

if(AnalysisSession.yieldPrediction < 3){


notifications.add({

"title":
"⚠ Yield Alert",

"message":
"Expected yield is low. Improve soil nutrients.",

});


}



// Irrigation notification

if(AnalysisSession.irrigation == "Recommended"){


notifications.add({

"title":
"💧 Irrigation Reminder",

"message":
"Your crop may need water soon.",

});


}




return Scaffold(


appBar:

AppBar(

title:
const Text(
"Notifications"
),

),



body:

notifications.isEmpty

?


const Center(

child:

Text(

"No new notifications",

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

item["title"]!,

style:

const TextStyle(

fontWeight:

FontWeight.bold,

),

),



subtitle:

Text(

item["message"]!,

),



),



);



},



),



);


}


}