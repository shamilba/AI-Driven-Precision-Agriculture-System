class WeatherTranslationService {


static String translateWeather(
String weather,
String language
){


weather = weather.toLowerCase();



Map<String,String> kannada = {


"clear sky":"ಸ್ಪಷ್ಟ ಆಕಾಶ",

"partly cloudy":"ಭಾಗಶಃ ಮೋಡ ಕವಿದಿದೆ",

"cloudy":"ಮೋಡ ಕವಿದಿದೆ",

"rain":"ಮಳೆ",

"fog":"ಮಂಜು",

"drizzle":"ತುಂತುರು ಮಳೆ",

"thunderstorm":"ಗುಡುಗು ಸಹಿತ ಮಳೆ",

};



Map<String,String> hindi = {


"clear sky":"साफ आसमान",

"partly cloudy":"आंशिक रूप से बादल छाए हुए हैं",

"cloudy":"बादल छाए हुए हैं",

"rain":"बारिश",

"fog":"कोहरा",

"drizzle":"बूंदाबांदी",

"thunderstorm":"गरज के साथ बारिश",

};





if(language=="ಕನ್ನಡ"){


return kannada[weather] ?? weather;


}



if(language=="हिन्दी"){


return hindi[weather] ?? weather;


}



return weather
.split(" ")
.map((e)=>
e[0].toUpperCase()+e.substring(1)
)
.join(" ");


}


}