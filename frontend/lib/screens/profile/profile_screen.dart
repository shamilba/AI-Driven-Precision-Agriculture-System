import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/user_session.dart';
import '../../services/language_service.dart';
import '../../localization/app_localizations.dart';

import '../auth/login_screen.dart';


class ProfileScreen extends StatelessWidget {
String t(BuildContext context,String key){

  final language =
  Provider.of<LanguageService>(context)
      .language;


  return AppLocalizations.translate(
    key,
    language,
  );

}

const ProfileScreen({
super.key,
});



@override
Widget build(BuildContext context){


return Scaffold(


appBar: AppBar(

title:
Text(
t(context,"farmer_profile")
),

),



body:

Padding(

padding:
const EdgeInsets.all(20),



child:

Column(



children:[



const CircleAvatar(

radius:45,

child:

Icon(

Icons.person,

size:50,

),

),




const SizedBox(height:25),




Card(

child:

ListTile(

leading:
const Icon(
Icons.person
),

title:

Text(
t(context,"name")
),


subtitle:

Text(
UserSession.userName ?? "Farmer"
),


),

),





Card(

child:

ListTile(

leading:
const Icon(
Icons.email
),


title:

Text(
t(context,"email")
),



subtitle:

Text(
UserSession.email ?? ""
),



),

),






const Spacer(),






SizedBox(

width:
double.infinity,


child:

ElevatedButton.icon(



icon:

const Icon(
Icons.logout
),



label:

Text(
t(context,"logout")
),



onPressed:() async {



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



),



);



}


}