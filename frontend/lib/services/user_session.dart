import 'package:shared_preferences/shared_preferences.dart';


class UserSession {


static int? userId;

static String? userName;

static String? email;



// SAVE USER

static Future<void> saveUser({

required int id,

required String name,

required String userEmail,


}) async {


final prefs =
await SharedPreferences.getInstance();



await prefs.setInt(
"user_id",
id
);


await prefs.setString(
"user_name",
name
);



await prefs.setString(
"email",
userEmail
);



userId = id;

userName = name;

email = userEmail;


}





// LOAD USER WHEN APP STARTS

static Future<void> loadUser() async {


final prefs =
await SharedPreferences.getInstance();



userId =
prefs.getInt(
"user_id"
);



userName =
prefs.getString(
"user_name"
);



email =
prefs.getString(
"email"
);



}





// LOGOUT

static Future<void> logout() async {


final prefs =
await SharedPreferences.getInstance();



await prefs.clear();



userId = null;

userName = null;

email = null;


}



}