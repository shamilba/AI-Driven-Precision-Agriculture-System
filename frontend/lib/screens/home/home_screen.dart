import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';
import '../profile/profile_screen.dart';
import '../history/history_screen.dart';


class HomeScreen extends StatefulWidget {

const HomeScreen({super.key});


@override
State<HomeScreen> createState()
=> _HomeScreenState();

}



class _HomeScreenState
extends State<HomeScreen>{


int index=0;



final pages=[

const DashboardScreen(),

const HistoryScreen(),

const ProfileScreen(),

];



@override
Widget build(BuildContext context){


return Scaffold(


body:
pages[index],



bottomNavigationBar:
BottomNavigationBar(


currentIndex:index,


selectedItemColor:
Colors.green,


onTap:(value){


setState((){

index=value;

});


},



items:[


const BottomNavigationBarItem(

icon:
Icon(Icons.dashboard),

label:"Dashboard",

),



const BottomNavigationBarItem(

icon:
Icon(Icons.history),

label:"History",

),



const BottomNavigationBarItem(

icon:
Icon(Icons.person),

label:"Profile",

),


],

),

);

}

}