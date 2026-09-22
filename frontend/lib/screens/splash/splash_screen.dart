import 'dart:async';
import 'package:flutter/material.dart';
import '../auth/login_screen.dart';


class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState()
  => _SplashScreenState();

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

body:Container(

width:double.infinity,


decoration:
const BoxDecoration(

gradient:
LinearGradient(

begin:Alignment.topCenter,

end:Alignment.bottomCenter,


colors:[

Colors.green,

Color(0xffE8F5E9),

],

),

),



child:Column(

mainAxisAlignment:
MainAxisAlignment.center,


children:[



Container(

padding:
const EdgeInsets.all(25),


decoration:
const BoxDecoration(

color:Colors.white,

shape:BoxShape.circle,

),


child:
const Icon(

Icons.agriculture,

size:90,

color:Colors.green,

),

),



const SizedBox(height:30),



const Text(

"AI-Driven\nPrecision Agriculture",

textAlign:
TextAlign.center,


style:
TextStyle(

fontSize:28,

fontWeight:
FontWeight.bold,

color:Colors.white,

),

),



const SizedBox(height:15),



const Text(

"Smart farming with Artificial Intelligence",

textAlign:
TextAlign.center,


style:
TextStyle(

fontSize:16,

color:Colors.white,

),

),



const SizedBox(height:40),



const CircularProgressIndicator(

color:Colors.white,

)



],

),

),

);

}

}