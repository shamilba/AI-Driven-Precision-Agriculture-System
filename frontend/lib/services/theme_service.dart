import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeService extends ChangeNotifier {


bool isDark = false;

bool loaded = false;



ThemeService(){

loadTheme();

}





Future<void> loadTheme() async {


final prefs =
await SharedPreferences.getInstance();



isDark =
prefs.getBool("darkMode") ?? false;



loaded = true;



notifyListeners();


}






Future<void> toggleTheme(bool value) async {


isDark = value;



final prefs =
await SharedPreferences.getInstance();



await prefs.setBool(
"darkMode",
isDark
);



notifyListeners();


}



}