import 'app_en.dart';
import 'app_kn.dart';
import 'app_hi.dart';



class AppLocalizations {


static String translate(
String key,
String language
){


if(language=="ಕನ್ನಡ"){

return kannada[key] ?? key;

}



if(language=="हिन्दी"){

return hindi[key] ?? key;

}



return english[key] ?? key;


}



}