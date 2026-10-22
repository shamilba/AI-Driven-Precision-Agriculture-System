import 'package:flutter/material.dart';

import '../home/home_screen.dart';

import 'register_screen.dart';

import '../../services/api_service.dart';
import '../../services/user_session.dart';



class LoginScreen extends StatefulWidget {


  const LoginScreen({
    super.key,
  });



  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();


}





class _LoginScreenState 
extends State<LoginScreen>{



final _formKey =
GlobalKey<FormState>();


final emailController =
TextEditingController();


final passwordController =
TextEditingController();



bool loading = false;






@override
Widget build(BuildContext context){


return Scaffold(



body:

Padding(

padding:
const EdgeInsets.all(25),




child:

Form(

key:_formKey,



child:

Column(



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

labelText:
"Email",

prefixIcon:
Icon(Icons.email),

border:
OutlineInputBorder(),

),





validator:(value){



if(value==null ||
value.isEmpty){


return "Enter email";


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

labelText:
"Password",

prefixIcon:
Icon(Icons.lock),

border:
OutlineInputBorder(),

),




validator:(value){



if(value==null ||
value.isEmpty){


return "Enter password";


}




if(value.length < 6){


return "Minimum 6 characters";


}



return null;



},



),






const SizedBox(height:30),







SizedBox(

width:
double.infinity,



child:

ElevatedButton(




onPressed:

loading

?

null

:

loginUser,






child:



loading

?

const CircularProgressIndicator(

color:
Colors.white,

)



:

const Text(

"LOGIN",

style:

TextStyle(

fontSize:18,

),

),



),



),







const SizedBox(height:10),







TextButton(



onPressed:(){



Navigator.push(



context,



MaterialPageRoute(



builder:(_)=>

const RegisterScreen(),



),



);



},




child:

const Text(

"Create New Account"

),



),





],



),


),


),



);



}







Future<void> loginUser() async {



if(!_formKey.currentState!.validate()){


return;


}




setState((){


loading=true;


});





try{



final result =

await ApiService.login(



email:

emailController.text.trim(),





password:

passwordController.text.trim(),





);







// Store user session


await UserSession.saveUser(



id:

result["user_id"],





name:

result["name"],





userEmail:

emailController.text.trim(),



);






if(!mounted)return;







Navigator.pushReplacement(



context,



MaterialPageRoute(



builder:(_)=>

const HomeScreen(),



),



);






}

catch(e){



if(!mounted)return;



ScaffoldMessenger.of(context)
.showSnackBar(



SnackBar(



content:

Text(

e.toString(),

),



),



);



}






finally{



setState((){


loading=false;


});



}




}





}