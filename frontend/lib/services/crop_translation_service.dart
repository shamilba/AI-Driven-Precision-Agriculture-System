class CropTranslationService {


static String translateCrop(
String crop,
String language
){


crop = crop.toLowerCase();



Map<String,String> kannada = {


"rice":"ಅಕ್ಕಿ",

"wheat":"ಗೋಧಿ",

"maize":"ಮೆಕ್ಕೆಜೋಳ",

"corn":"ಮೆಕ್ಕೆಜೋಳ",

"tomato":"ಟೊಮೆಟೊ",

"potato":"ಆಲೂಗಡ್ಡೆ",

"mango":"ಮಾವು",

"banana":"ಬಾಳೆಹಣ್ಣು",

"mothbeans":"ಮೊತ್ ಬೀನ್ಸ್",

"blackgram":"ಉದ್ದಿನ ಬೇಳೆ",

"pigeonpeas":"ತೊಗರಿ ಬೇಳೆ",

"chickpea":"ಕಡಲೆ",

"lentil":"ಮಸೂರ ಬೇಳೆ",

"cotton":"ಹತ್ತಿ",

"soybean":"ಸೋಯಾಬೀನ್",

"groundnut":"ಕಡಲೆಕಾಯಿ",

};



Map<String,String> hindi = {


"rice":"चावल",

"wheat":"गेहूं",

"maize":"मक्का",

"corn":"मक्का",

"tomato":"टमाटर",

"potato":"आलू",

"mango":"आम",

"banana":"केला",

"mothbeans":"मोठ बीन्स",

"blackgram":"उड़द दाल",

"pigeonpeas":"अरहर दाल",

"chickpea":"चना",

"lentil":"मसूर दाल",

"cotton":"कपास",

"soybean":"सोयाबीन",

"groundnut":"मूंगफली",

};





if(language=="ಕನ್ನಡ"){


return kannada[crop] ?? crop;


}



if(language=="हिन्दी"){


return hindi[crop] ?? crop;


}



return crop[0].toUpperCase()+crop.substring(1);


}


}