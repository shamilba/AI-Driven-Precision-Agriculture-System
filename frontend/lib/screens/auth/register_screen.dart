import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import 'login_screen.dart';



class RegisterScreen extends StatefulWidget {


  const RegisterScreen({
    super.key,
  });



  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();


}





class _RegisterScreenState 
extends State<RegisterScreen>{



final _formKey =
GlobalKey<FormState>();



final nameController =
TextEditingController();


final emailController =
TextEditingController();


final passwordController =
TextEditingController();


final locationController =
TextEditingController();



bool loading = false;




@override
Widget build(BuildContext context){


return Scaffold(



appBar:

AppBar(

title:
const Text(
"Create Account"
),

),




body:

Padding(

padding:
const EdgeInsets.all(25),



child:

Form(

key:_formKey,



child:

SingleChildScrollView(


child:

Column(



mainAxisAlignment:
MainAxisAlignment.center,



children:[



const SizedBox(height:30),



const Icon(

Icons.agriculture,

size:90,

color:Colors.green,

),




const SizedBox(height:20),




const Text(

"Farmer Registration",

style:

TextStyle(

fontSize:25,

fontWeight:
FontWeight.bold,

),

),




const SizedBox(height:35),





TextFormField(

controller:
nameController,


decoration:

const InputDecoration(

labelText:
"Name",

prefixIcon:
Icon(Icons.person),

border:
OutlineInputBorder(),

),



validator:(value){


if(value==null ||
value.isEmpty){

return "Enter name";

}


return null;


},


),





const SizedBox(height:15),





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






const SizedBox(height:15),






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





const SizedBox(height:15),






TextFormField(

controller:
locationController,


decoration:

const InputDecoration(

labelText:
"Location",

prefixIcon:
Icon(Icons.location_on),

border:
OutlineInputBorder(),

),



validator:(value){


if(value==null ||
value.isEmpty){

return "Enter location";

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
registerUser,




child:

loading

?

const CircularProgressIndicator(
color:Colors.white,
)


:

const Text(

"REGISTER",

style:

TextStyle(

fontSize:18,

),

),



),


),






const SizedBox(height:15),






TextButton(


onPressed:(){


Navigator.pushReplacement(

context,

MaterialPageRoute(

builder:(_)=>

const LoginScreen(),

),

);


},



child:

const Text(

"Already have account? Login"

),



),




],



),


),


),


),



);



}





Future<void> registerUser() async {



if(!_formKey.currentState!.validate()){

return;

}




setState((){

loading=true;

});





try{


await ApiService.register(


name:
nameController.text.trim(),



email:
emailController.text.trim(),



password:
passwordController.text.trim(),



location:
locationController.text.trim(),



);





if(!mounted)return;



ScaffoldMessenger.of(context)
.showSnackBar(


const SnackBar(

content:

Text(

"Registration successful"

),

),


);





Navigator.pushReplacement(

context,

MaterialPageRoute(

builder:(_)=>

const LoginScreen(),

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