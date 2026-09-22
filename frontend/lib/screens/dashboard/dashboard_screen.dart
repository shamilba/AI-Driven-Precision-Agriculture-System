import 'package:flutter/material.dart';
import '../crop_health/crop_health_screen.dart';


class DashboardScreen extends StatelessWidget {

  const DashboardScreen({super.key});


  Widget buildCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {

    return Container(

      margin: const EdgeInsets.only(bottom: 15),

      child: Card(

        elevation: 4,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),

        child: Padding(

          padding: const EdgeInsets.all(16),

          child: Row(

            children: [

              Container(

                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(

                  color: color.withOpacity(0.15),

                  borderRadius:
                  BorderRadius.circular(15),

                ),

                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),

              ),


              const SizedBox(width: 20),


              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(

                    title,

                    style: const TextStyle(

                      fontSize: 16,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),


                  const SizedBox(height: 5),


                  Text(

                    value,

                    style: TextStyle(

                      color: Colors.grey[700],

                      fontSize: 15,

                    ),

                  ),

                ],

              )

            ],

          ),

        ),

      ),

    );

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title:
        const Text("Farmer Dashboard"),

      ),


      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),


        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children: [


            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(20),


              decoration: BoxDecoration(

                gradient:
                const LinearGradient(

                  colors: [

                    Colors.green,

                    Colors.lightGreen,

                  ],

                ),


                borderRadius:
                BorderRadius.circular(20),

              ),


              child: const Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [


                  Text(

                    "Welcome Farmer 🌾",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize: 24,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),


                  SizedBox(height:10),


                  Text(

                    "Monitor your crops with AI",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize:16,

                    ),

                  ),


                ],

              ),

            ),



            const SizedBox(height:25),


            Card(

elevation:4,

shape: RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(18),

),


child:

ListTile(

leading:

const CircleAvatar(

backgroundColor:
Colors.blue,

child:

Icon(

Icons.cloud,

color:
Colors.white,

),

),



title:

const Text(

"Weather",

style:

TextStyle(

fontWeight:
FontWeight.bold,

),

),



subtitle:

const Text(

"28°C | Sunny",

),



),

),



            buildCard(

              icon: Icons.eco,

              title:"Crop Health",

              value:"Healthy",

              color:Colors.green,

            ),



            buildCard(

              icon:Icons.bar_chart,

              title:"Yield Prediction",

              value:"4.8 Tons/Hectare",

              color:Colors.blue,

            ),



            buildCard(

              icon:Icons.water_drop,

              title:"Irrigation",

              value:"Required in 2 Days",

              color:Colors.cyan,

            ),



            buildCard(

              icon:Icons.grass,

              title:"Fertilizer",

              value:"NPK Recommended",

              color:Colors.orange,

            ),



            const SizedBox(height:20),



            SizedBox(

              width:double.infinity,


              child: ElevatedButton(

                onPressed: () {


                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder:(_)=>
                      const CropHealthScreen(),

                    ),

                  );


                },


                child:
                const Text(
                  "Analyze Crop 🌱",
                  style:
                  TextStyle(fontSize:18),
                ),

              ),

            )


          ],

        ),

      ),

    );

  }

}