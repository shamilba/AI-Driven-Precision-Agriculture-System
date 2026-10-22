import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/user_session.dart';


class HistoryScreen extends StatefulWidget {

  const HistoryScreen({super.key});


  @override
  State<HistoryScreen> createState() =>
      _HistoryScreenState();

}



class _HistoryScreenState extends State<HistoryScreen>{


  List<dynamic> history = [];

  bool loading = true;



  @override
  void initState(){

    super.initState();

    loadHistory();

  }




  Future<void> loadHistory() async {


    if(UserSession.userId == null){


      setState((){

        loading = false;

      });


      return;

    }



    try{


      final data =
      await ApiService.getHistory(

        UserSession.userId!,

      );



      setState((){


        history = data;

        loading = false;


      });



    }


    catch(e){



      setState((){


        loading = false;


      });



      ScaffoldMessenger.of(context)
      .showSnackBar(


        const SnackBar(

          content:

          Text(
            "Failed to load history"
          ),

        ),


      );


    }


  }





  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar: AppBar(

        title:

        const Text(
          "Previous Analysis"
        ),

      ),




      body:



      loading


      ?


      const Center(

        child:

        CircularProgressIndicator(),

      )



      :



      history.isEmpty



      ?



      const Center(

        child:

        Text(

          "No previous analysis available",

          style:

          TextStyle(

            fontSize:18,

          ),

        ),

      )



      :



      ListView.builder(


        padding:

        const EdgeInsets.all(16),



        itemCount:

        history.length,



        itemBuilder:(context,index){



          final item = history[index];



          return Card(


            elevation:4,


            margin:

            const EdgeInsets.only(

              bottom:15,

            ),



            shape:

            RoundedRectangleBorder(

              borderRadius:

              BorderRadius.circular(15),

            ),



            child:

            Padding(


              padding:

              const EdgeInsets.all(16),



              child:

              Column(


                crossAxisAlignment:

                CrossAxisAlignment.start,



                children:[



                  Text(


                    "Crop: ${item["selected_crop"]}",



                    style:

                    const TextStyle(


                      fontSize:18,


                      fontWeight:

                      FontWeight.bold,


                    ),


                  ),




                  const SizedBox(height:10),




                  Text(

                    "AI Suggested Crop: ${item["recommended_crop"]}",

                  ),




                  Text(

                    "Fertilizer: ${item["fertilizer"]}",

                  ),




                  Text(

                    "Expected Yield: ${item["yield_prediction"]} Tons/Ha",

                  ),




                  Text(

                    "Temperature: ${item["temperature"]} °C",

                  ),




                  Text(

                    "Humidity: ${item["humidity"]} %",

                  ),




                  Text(

                    "Rainfall: ${item["rainfall"]} mm",

                  ),



                ],


              ),


            ),


          );


        },


      ),



    );


  }


}