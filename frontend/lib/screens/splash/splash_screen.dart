import 'dart:async';

import 'package:flutter/material.dart';

import '../auth/login_screen.dart';



class SplashScreen extends StatefulWidget {


const SplashScreen({
super.key,
});



@override
State<SplashScreen> createState() =>
_SplashScreenState();


}




class _SplashScreenState
extends State<SplashScreen>{



@override
void initState(){

super.initState();


Timer(

const Duration(seconds:3),

(){


Navigator.pushReplacement(

context,

MaterialPageRoute(

builder:(_)=>

const LoginScreen(),

),

);


},

);


}




@override
Widget build(BuildContext context){


return Scaffold(


body:

Center(


child:

Column(

mainAxisAlignment:

MainAxisAlignment.center,


children:[



const Icon(

Icons.agriculture,

size:100,

color:Colors.green,

),



const SizedBox(height:20),



const Text(

"AI Precision Agriculture",

style:

TextStyle(

fontSize:26,

fontWeight:

FontWeight.bold,

),

),



const SizedBox(height:10),



const Text(

"Smart Farming with AI",

style:

TextStyle(

fontSize:16,

),

),



const SizedBox(height:30),



const CircularProgressIndicator(),



],


),



),


);


}


}