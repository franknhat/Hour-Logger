import 'dart:convert';
import 'dart:io';

final path = Directory.current.path + '/lib/categories.json';

Future<Map> readJsonFileToMap(String filePath) async {
  var fileData = await File(filePath).readAsString();
  
  return jsonDecode(fileData);
}

Map parseJsonMap(dynamic map){
  List<dynamic> listCategories = map["categories"];

  var parsed = new Map();
  
  for (var element in listCategories) { 
    parsed[element["name"].toString()] = element["subcategories"]; 
  }

  return parsed;
}

Future<Map> getCategories() async{
  var rawData = await readJsonFileToMap(path);

  return parseJsonMap(rawData);
}