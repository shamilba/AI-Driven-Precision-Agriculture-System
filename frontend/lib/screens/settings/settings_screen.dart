import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../profile/profile_screen.dart';
import '../../services/user_session.dart';
import '../../services/theme_service.dart';
import '../auth/login_screen.dart';



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


bool notifications = true;



@override
Widget build(BuildContext context){



return Scaffold(



appBar:

AppBar(

title:

const Text(
"Settings"
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

const Text(
"Profile"
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

const Text(
"Dark Mode"
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

const Text(
"Notifications"
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

ListTile(


leading:

const Icon(
Icons.language
),



title:

const Text(
"Language"
),



subtitle:

const Text(
"English"
),



onTap:(){



showDialog(

context: context,

builder:(context){


return AlertDialog(


title:

const Text(
"Language"
),



content:

const Text(
"More languages will be added soon."
),



actions:[


TextButton(

onPressed:(){

Navigator.pop(context);

},

child:

const Text(
"OK"
),

),


],


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

const Text(
"Logout"
),



onTap:() async {



await UserSession.logout();



if(!mounted)return;



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