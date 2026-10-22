import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'services/theme_service.dart';



void main(){


runApp(


ChangeNotifierProvider(


create:(_)=>

ThemeService(),



child:

const AgricultureApp(),


),


);



}






class AgricultureApp extends StatelessWidget {


const AgricultureApp({

super.key,

});




@override
Widget build(BuildContext context){



return Consumer<ThemeService>(


builder:(context,theme,child){


if(!theme.loaded){

return const MaterialApp(

home:

Scaffold(

body:

Center(

child:

CircularProgressIndicator(),

),

),

);

}


return MaterialApp(


debugShowCheckedModeBanner:false,



theme:

ThemeData(

primarySwatch:
Colors.green,

brightness:
Brightness.light,

),




darkTheme:

ThemeData(

brightness:
Brightness.dark,

primarySwatch:
Colors.green,

),




themeMode:

theme.isDark

?

ThemeMode.dark

:

ThemeMode.light,





home:

const SplashScreen(),



);



},



);



}



}