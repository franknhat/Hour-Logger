import 'storage_interface.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'dart:io';

class JsonCategories implements StoreCategory{
  @visibleForTesting
  var path = '${Directory.current.path}/lib/categories_lib/categories.json';

  @visibleForTesting
  Map jsonMap = {};

  @override
  Future<Map> getCategories() async {
    jsonMap = await readJsonFileToMap(path);

    return parseJsonMap(jsonMap);
  }
  
  @override
  Future<void> saveCategory(String category) async {
    categoryChecker(category,
      ifFound: (foundCategoryMap) => throw Exception('category ${foundCategoryMap['name']} is already exists'),
      ifNotFound: (){
        jsonMap['categories']?.add({'name':category, 'subcategories':[]});

        File(path).writeAsStringSync(jsonEncode(jsonMap));
      }
    );
  }
  
  @override
  Future<void> saveSubcategory(String category, String subcategory) async{
    categoryChecker(category, 
      ifNotFound: () => throw Exception('category $category was not found to add the subcategory $subcategory to'),
      ifFound: (foundCategoryMap) {
        if(foundCategoryMap['subcategories'].contains(subcategory)){
          throw Exception('subcategory $subcategory already exists in the category $category');
        }

        foundCategoryMap['subcategories'].add(subcategory);

        File(path).writeAsStringSync(jsonEncode(jsonMap));
      }
    );
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

  void categoryChecker(String category, {required Function ifFound, required Function ifNotFound}){
    for(var categoryList in jsonMap['categories']){
      if(categoryList['name'] == category){
        ifFound(categoryList);
        return;
      }
    }

    ifNotFound();
  }
}