import 'package:flutter/material.dart';


class ProfileScreen extends StatelessWidget {

const ProfileScreen({super.key});


@override
Widget build(BuildContext context){


return Scaffold(

appBar:
AppBar(

title:
const Text("Profile"),

),



body:
Center(

child:
Column(

mainAxisAlignment:
MainAxisAlignment.center,


children:[


const CircleAvatar(

radius:50,

child:
Icon(

Icons.person,

size:60,

),

),



const SizedBox(height:20),



const Text(

"Farmer User",

style:
TextStyle(

fontSize:24,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:10),



const Text(

"AI Agriculture Member",

),

],

),

),

);

}

}