import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/language_service.dart';
import '../profile/profile_screen.dart';
import '../../services/user_session.dart';
import '../../services/theme_service.dart';
import '../auth/login_screen.dart';

import '../../localization/app_localizations.dart';

class SettingsScreen extends StatefulWidget {


  const SettingsScreen({
    super.key,
  });



  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();


}





class _SettingsScreenState
extends State<SettingsScreen>{
  String t(BuildContext context,String key){

  final language =
  Provider.of<LanguageService>(context)
      .language;


  return AppLocalizations.translate(
    key,
    language,
  );

}


bool notifications = true;



@override
Widget build(BuildContext context){



return Scaffold(



appBar:

AppBar(

title:

Text(
t(context,"settings")
),

),





body:

ListView(

padding:

const EdgeInsets.all(20),



children:[





// ==========================
// PROFILE
// ==========================


Card(

child:

ListTile(

leading:

const Icon(
Icons.person
),



title:

Text(
t(context,"profile")
),



subtitle:

Text(

UserSession.userName ??
"Farmer"

),



trailing:

const Icon(
Icons.arrow_forward_ios
),



onTap:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(_)=>

const ProfileScreen(),

),

);


},



),


),





// ==========================
// DARK MODE
// ==========================


Card(

child:

SwitchListTile(


secondary:

const Icon(
Icons.dark_mode
),



title:

Text(
t(context,"dark_mode")
),



value:

Provider.of<ThemeService>(context)
.isDark,



onChanged:(value){


Provider.of<ThemeService>(

context,

listen:false

)
.toggleTheme(value);



},



),


),





// ==========================
// NOTIFICATIONS
// ==========================


Card(

child:

SwitchListTile(


secondary:

const Icon(
Icons.notifications
),



title:

Text(
t(context,"notifications")
),



value:

notifications,



onChanged:(value){


setState((){


notifications=value;


});


},



),


),





// ==========================
// LANGUAGE
// ==========================


Card(

child:

Consumer<LanguageService>(


builder:(context,languageService,child){


return ListTile(



leading:

const Icon(
Icons.language
),



title:

Text(
t(context,"language")
),



subtitle:

Text(

languageService.language

),



onTap:(){



showDialog(


context:context,


builder:(context){



return AlertDialog(



title:

Text(
t(context,"select_language")
),



content:

Column(


mainAxisSize:

MainAxisSize.min,


children:[



"English",

"ಕನ್ನಡ",

"हिन्दी",


].map((lang){



return RadioListTile<String>(


title:

Text(lang),



value:

lang,



groupValue:

languageService.language,



onChanged:(value){



if(value!=null){



languageService
.changeLanguage(value);



Navigator.pop(context);



}



},



);



}).toList(),



),



);



},



);



},



);



},



),



),





// ==========================
// LOGOUT
// ==========================


Card(

child:

ListTile(


leading:

const Icon(
Icons.logout
),



title:

Text(
t(context,"logout")
),



onTap:() async {



await UserSession.logout();



if(!context.mounted)return;

Navigator.pushAndRemoveUntil(
context,

MaterialPageRoute(

builder:(_)=>

const LoginScreen(),

),

(route)=>false,

);



},



),


),





],


),



);



}



}