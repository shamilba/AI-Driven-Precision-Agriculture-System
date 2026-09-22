import 'package:flutter/material.dart';
import '../home/home_screen.dart';


class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState()
  => _LoginScreenState();

}



class _LoginScreenState
extends State<LoginScreen>{


final _formKey = GlobalKey<FormState>();


final emailController = TextEditingController();

final passwordController = TextEditingController();



@override
Widget build(BuildContext context){


return Scaffold(

body: Padding(

padding:
const EdgeInsets.all(25),


child: Form(

key:_formKey,


child: Column(

mainAxisAlignment:
MainAxisAlignment.center,


children:[


const Icon(

Icons.agriculture,

size:90,

color:Colors.green,

),



const SizedBox(height:20),



const Text(

"AI Precision Agriculture",

style:
TextStyle(

fontSize:25,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:40),



TextFormField(

controller:
emailController,


decoration:

const InputDecoration(

labelText:"Email",

prefixIcon:
Icon(Icons.email),

border:
OutlineInputBorder(),

),



validator:(value){


if(value == null ||
value.isEmpty){

return "Please enter email";

}


if(!value.contains("@")){

return "Enter valid email";

}


return null;

},


),



const SizedBox(height:20),



TextFormField(

controller:
passwordController,


obscureText:true,


decoration:

const InputDecoration(

labelText:"Password",

prefixIcon:
Icon(Icons.lock),

border:
OutlineInputBorder(),

),



validator:(value){


if(value == null ||
value.isEmpty){

return "Please enter password";

}


if(value.length < 6){

return "Password must be 6 characters";

}


return null;

},


),



const SizedBox(height:30),



SizedBox(

width:double.infinity,


child:ElevatedButton(


onPressed:(){


if(_formKey.currentState!.validate()){


Navigator.pushReplacement(

context,

MaterialPageRoute(

builder:(_)=>
const HomeScreen(),

),

);


}


},



child:
const Text("LOGIN"),


),


)



],

),

),

),

);

}

}