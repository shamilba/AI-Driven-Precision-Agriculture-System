import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LanguageService extends ChangeNotifier {


  String _language = "English";


  String get language => _language;



  Future<void> loadLanguage() async {


    final prefs =
    await SharedPreferences.getInstance();


    _language =
        prefs.getString("language") ?? "English";


    notifyListeners();

  }






  Future<void> changeLanguage(String value) async {


    _language = value;


    final prefs =
    await SharedPreferences.getInstance();


    await prefs.setString(
      "language",
      value,
    );


    notifyListeners();


  }


}