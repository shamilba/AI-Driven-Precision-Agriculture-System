import 'package:flutter/material.dart';
import '../settings/settings_screen.dart';
import '../crop_health/crop_health_screen.dart';
import '../history/history_screen.dart';
import '../profile/profile_screen.dart';
import '../notifications/notification_screen.dart';
import '../../services/user_session.dart';
import '../../services/api_service.dart';
import '../../services/weather_service.dart';
import '../../widgets/analysis_summary_card.dart';
import '../../widgets/recent_analysis_card.dart';

class DashboardScreen extends StatefulWidget {


  const DashboardScreen({
    super.key,
  });



  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();

}




class _DashboardScreenState extends State<DashboardScreen>{

  List<dynamic> recentAnalyses = [];

bool historyLoading = true;



String temperature = "--";

String weatherCondition = "Loading...";

String humidity = "--";



String selectedCrop = "Not analyzed";

String recommendedCrop = "Not analyzed";

String fertilizer = "Not analyzed";

String cropHealth = "Not analyzed";

String irrigation = "Not analyzed";

double yieldPrediction = 0;





@override
void initState(){

super.initState();

loadLatestAnalysis();

loadWeather();

loadRecentAnalyses();

}







Future<void> loadWeather() async {

  try {

    final data = await WeatherService.getWeather();

    final current = data["current"];

    setState(() {

      temperature =
          "${current["temperature_2m"]}°C";

      humidity =
          "${current["relative_humidity_2m"]}%";

      weatherCondition =
          getWeatherName(
            current["weather_code"],
          );

    });

  } catch (e) {

    print(e);

    setState(() {

      temperature = "--";

      humidity = "--";

      weatherCondition = "Unavailable";

    });

  }

}

String getWeatherName(int code) {

  switch (code) {

    case 0:
      return "Clear Sky";

    case 1:
    case 2:
    case 3:
      return "Partly Cloudy";

    case 45:
    case 48:
      return "Fog";

    case 51:
    case 53:
    case 55:
      return "Drizzle";

    case 61:
    case 63:
    case 65:
      return "Rain";

    case 71:
    case 73:
    case 75:
      return "Snow";

    case 95:
      return "Thunderstorm";

    default:
      return "Cloudy";

  }

}








Future<void> loadLatestAnalysis() async {


try{


final data =

await ApiService.getLatestAnalysis(

UserSession.userId!

);



setState((){


selectedCrop =
data["selected_crop"] ??
"Not selected";



recommendedCrop =
data["recommended_crop"] ??
"Not analyzed";



fertilizer =
data["fertilizer"] ??
"Not analyzed";



yieldPrediction =

double.parse(

data["yield_prediction"].toString()

);



cropHealth =
"Healthy";



irrigation =
"Recommended";



});



}

catch(e){


print(
"Analysis error: $e"
);


}



}



Future<void> loadRecentAnalyses() async {


try{


final data =
await ApiService.getHistory(
UserSession.userId!
);



setState((){

recentAnalyses = data;

historyLoading = false;

});


}

catch(e){


print(
"History loading error: $e"
);


setState((){

historyLoading=false;

});


}


}


Future<void> refreshDashboard() async {

  await loadLatestAnalysis();

  setState((){});

}







Widget buildCard({

required IconData icon,

required String title,

required String value,

required Color color,


}){


return Card(


elevation:4,


margin:

const EdgeInsets.only(

bottom:15

),



shape:

RoundedRectangleBorder(

borderRadius:

BorderRadius.circular(18)

),



child:

Padding(

padding:

const EdgeInsets.all(16),



child:

Row(

children:[



Container(

padding:

const EdgeInsets.all(12),



decoration:

BoxDecoration(

color:

color.withOpacity(0.15),


borderRadius:

BorderRadius.circular(15),

),



child:

Icon(

icon,

color:color,

size:30,

),

),



const SizedBox(width:20),




Column(

crossAxisAlignment:

CrossAxisAlignment.start,


children:[


Text(

title,

style:

const TextStyle(

fontWeight:

FontWeight.bold,

fontSize:16,

),

),



const SizedBox(height:5),



Text(

value,

style:

TextStyle(

color:

Colors.grey[700],

),

),


],


),


],


),


),


);


}







@override
Widget build(BuildContext context){



return Scaffold(



appBar:

AppBar(


title:

const Text(
"Farmer Dashboard"
),



actions:[


IconButton(

icon:

const Icon(
Icons.settings
),


onPressed:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>

const SettingsScreen(),

),

);


},

),  


IconButton(

icon:

const Icon(
Icons.notifications
),


onPressed:(){

Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>

const NotificationScreen(),

),

);

},

),



IconButton(

icon:

const Icon(
Icons.person
),


onPressed:(){

Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>

const ProfileScreen(),

),

);

},

),


],



),






body:

SingleChildScrollView(



padding:

const EdgeInsets.all(20),



child:

Column(



crossAxisAlignment:

CrossAxisAlignment.start,



children:[




Container(


width:

double.infinity,

padding:

const EdgeInsets.all(20),



decoration:

BoxDecoration(


gradient:

const LinearGradient(

colors:[

Colors.green,

Colors.lightGreen,

],

),


borderRadius:

BorderRadius.circular(20),

),



child:

Column(

crossAxisAlignment:

CrossAxisAlignment.start,



children:[



Text(

"Welcome ${UserSession.userName ?? "Farmer"} 🌾",

style:

const TextStyle(

color:Colors.white,

fontSize:24,

fontWeight:

FontWeight.bold,

),

),



const SizedBox(height:10),




const Text(

"Monitor your crops with AI",

style:

TextStyle(

color:Colors.white,

fontSize:16,

),

),



],



),



),





const SizedBox(height:25),







Card(

elevation:4,


child:

ListTile(


leading:

const CircleAvatar(

backgroundColor:Colors.blue,

child:

Icon(

Icons.cloud,

color:Colors.white,

),

),



title:

const Text(

"Weather",

style:

TextStyle(

fontWeight:

FontWeight.bold,

),

),



subtitle: Text(

  "$temperature | $weatherCondition\nHumidity: $humidity",

),



),


),


const SizedBox(height:15),

AnalysisSummaryCard(

  crop:selectedCrop,

  recommendedCrop:recommendedCrop,

  fertilizer:fertilizer,

  yieldValue:
  yieldPrediction.toString(),

),



const SizedBox(height:20),



buildCard(

icon:Icons.grass,

title:"Selected Crop",

value:selectedCrop,

color:Colors.green,

),




buildCard(

icon:Icons.auto_awesome,

title:"AI Recommended Crop",

value:recommendedCrop,

color:Colors.teal,

),




buildCard(

icon:Icons.eco,

title:"Crop Health",

value:cropHealth,

color:Colors.green,

),





buildCard(

icon:Icons.bar_chart,

title:"Yield Prediction",

value:"$yieldPrediction Tons/Hectare",

color:Colors.blue,

),





buildCard(

icon:Icons.grass,

title:"Fertilizer",

value:fertilizer,

color:Colors.orange,

),





buildCard(

icon:Icons.water_drop,

title:"Irrigation",

value:irrigation,

color:Colors.cyan,

),


RecentAnalysisCard(

  analyses: recentAnalyses,

),

const SizedBox(height:20),


Card(

elevation:4,


child:

ListTile(


leading:

const CircleAvatar(

child:

Icon(Icons.history),

),



title:

const Text(

"Previous Analysis"

),



subtitle:

const Text(

"View your past AI recommendations"

),



trailing:

const Icon(

Icons.arrow_forward_ios,

),




onTap:(){



Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>

const HistoryScreen(),

),

);


},



),


),





const SizedBox(height:25),





SizedBox(

width:

double.infinity,


child:

ElevatedButton(


onPressed: () async {

  await Navigator.push(

    context,

    MaterialPageRoute(

      builder: (_) => const CropHealthScreen(),

    ),

  );

  await refreshDashboard();

},



child:

const Text(

"Analyze Crop 🌱",

style:

TextStyle(

fontSize:18,

),

),



),


),



],


),


),


);



}


}