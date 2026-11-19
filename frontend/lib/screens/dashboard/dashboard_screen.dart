import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings/settings_screen.dart';
import '../crop_health/crop_health_screen.dart';
import '../history/history_screen.dart';
import '../profile/profile_screen.dart';
import '../notifications/notification_screen.dart';
import '../../services/weather_translation_service.dart';
import '../../services/weather_service.dart';
import '../../services/user_session.dart';

import '../../localization/app_localizations.dart';
import '../../services/language_service.dart';



class DashboardScreen extends StatefulWidget {


  const DashboardScreen({
    super.key,
  });



  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();


}





class _DashboardScreenState
extends State<DashboardScreen>{



String t(BuildContext context,String key){


final language =

Provider.of<LanguageService>(context)
.language;



return AppLocalizations.translate(
key,
language
);


}






String temperature = "--";


String weatherCondition =
"Loading...";


String humidity =
"--";






@override
void initState(){


super.initState();


loadWeather();


}







Future<void> loadWeather() async {



try{


final data =

await WeatherService.getWeather();



final current =

data["current"];





setState((){


temperature =

"${current["temperature_2m"]}°C";



humidity =

"${current["relative_humidity_2m"]}%";



weatherCondition =

getWeatherName(

current["weather_code"],

);



});



}

catch(e){


setState((){


temperature="--";

humidity="--";

weatherCondition="unavailable";


});


}



}







String getWeatherName(int code){



switch(code){


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



case 95:

return "Thunderstorm";



default:

return "Cloudy";


}



}







Future<void> refreshDashboard() async {


await loadWeather();


}







@override
Widget build(BuildContext context){

final language =
Provider.of<LanguageService>(context)
.language;

return Scaffold(



appBar:

AppBar(



title:

Text(

t(context,"dashboard"),

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


"${t(context,"welcome")} ${UserSession.userName ?? t(context,"farmer")}",



style:

const TextStyle(


color:

Colors.white,


fontSize:

24,


fontWeight:

FontWeight.bold,


),


),





const SizedBox(height:10),




Text(

t(context,"monitor"),

style:

const TextStyle(

color:

Colors.white,

fontSize:

16,

),

),




],



),


),




const SizedBox(height:20),
            SizedBox(

              width:

              double.infinity,



              child:

              ElevatedButton.icon(



                icon:

                const Icon(

                  Icons.analytics,

                ),




                label:

                Text(

                  t(context,"analyze"),

                  style:

                  const TextStyle(

                    fontSize:18,

                    fontWeight:

                    FontWeight.bold,

                  ),

                ),




                onPressed:() async {



                  await Navigator.push(



                    context,



                    MaterialPageRoute(



                      builder:(_)=>

                      const CropHealthScreen(),



                    ),



                  );




                  await refreshDashboard();



                },



              ),



            ),





            const SizedBox(height:20),







            Card(



              elevation:4,



              child:

              ListTile(



                leading:

                const CircleAvatar(


                  backgroundColor:

                  Colors.blue,


                  child:

                  Icon(

                    Icons.cloud,

                    color:

                    Colors.white,

                  ),


                ),




                title:

                Text(

                  t(context,"weather"),

                  style:

                  const TextStyle(

                    fontWeight:

                    FontWeight.bold,

                  ),

                ),




                subtitle:

                Text(

                  "$temperature | ${
WeatherTranslationService.translateWeather(weatherCondition,language)}\n"
"${t(context,"humidity")}: $humidity",
                ),



              ),



            ),







            const SizedBox(height:20),








            Card(



              elevation:4,



              child:

              ListTile(



                leading:

                const CircleAvatar(



                  child:

                  Icon(

                    Icons.history,

                  ),



                ),




                title:

                Text(

                  t(context,"history"),

                ),





                subtitle:

                Text(

                  t(context,"view_past_recommendations"),

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





          ],



        ),



      ),



    );



  }



}