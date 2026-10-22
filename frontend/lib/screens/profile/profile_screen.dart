import 'package:flutter/material.dart';

import '../../services/user_session.dart';
import '../auth/login_screen.dart';



class ProfileScreen extends StatelessWidget {


const ProfileScreen({
super.key,
});



@override
Widget build(BuildContext context){


return Scaffold(


appBar: AppBar(

title:
const Text(
"Farmer Profile"
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

const Text(
"Name"
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

const Text(
"Email"
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

const Text(
"Logout"
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