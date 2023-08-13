import 'storage_interface.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'dart:io';

//TODO Refactor
class JsonCategories implements StoreCategory{
  @visibleForTesting
  var path = '${Directory.current.path}/lib/categories.json';

  @visibleForTesting
  Map jsonMap = {};

  @override
  Future<Map> getCategories() async {
    jsonMap = await readJsonFileToMap(path);

    return parseJsonMap(jsonMap);
  }
  
  @override
  Future<void> saveCategory(String category) async {
    jsonMap['categories']?.add({'name':category, 'subcategories':[]});

    await File(path).writeAsString(jsonEncode(jsonMap));
  }
  
  @override
  Future<void> saveSubcategory(String category, String subcategory) async{
    //TODO implement Json saveSubcategory
    int indexOfCategory = -1;

    for(var i = 0; i < jsonMap.length; i++){
      if( jsonMap['categories'][i]['name'] == category){
        indexOfCategory = i;
        break;
      }
    }

    if (indexOfCategory == -1){
      throw Exception('the category $category does not exist to add a subcategory to');
    }

    if(jsonMap['categories'][indexOfCategory]['subcategories'].contains(subcategory)){
      throw Exception('subcategory $subcategory exists in the category $category');
    }

    jsonMap['categories'][indexOfCategory]['subcategories'].add(subcategory);

    await File(path).writeAsString(jsonEncode(jsonMap));
  }
  
    Future<Map> readJsonFileToMap(String filePath) async {
    var fileData = await File(filePath).readAsString();
  
    return jsonDecode(fileData);
  }

  Map parseJsonMap(dynamic map){
    List<dynamic> listCategories = map["categories"];

    var parsed = {};
    
    for (var element in listCategories) { 
      parsed[element["name"].toString()] = element["subcategories"]; 
    }

    return parsed;
  }
}