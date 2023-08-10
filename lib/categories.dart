import 'dart:convert';
import 'dart:io';

//TODO consider turning this into a class, specifically a static and singleton class
//TODO refactor

final path = '${Directory.current.path}/lib/categories.json';

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

Future<Map> getCategories() async{
  var rawData = await readJsonFileToMap(path);

  return parseJsonMap(rawData);
}

Map addCategory(String categoryName, Map categories, Function storeCategory){
  if (categories.containsKey(categoryName)){
    throw Exception('This category already exists');
  }
  
  categories[categoryName] = [];

  storeCategory(categoryName, categories);

  return categories;
}

void addCategoryToJson(String categoryName, Map categories, [String? filePath]){
  var categoriesJson = {};

  List categoriesList = [];

  for (var category in categories.keys){
    categoriesList.add({'name':category, 'subcategories':categories[category]});
  }

  categoriesList.add({'name': categoryName, 'subcategories':[]});

  categoriesJson['categories'] = categoriesList;

  var usePath = (filePath == null) ? path: filePath;

  File(usePath).writeAsString(jsonEncode(categoriesJson));
}

Map addSubCategory(Map<String, List> categories, String category, String subcategory, Function saveSubcategory){
  if (!categories.containsKey(category)){
    throw Exception('category $category does not exist!');
  }

  if (categories[category]!.contains(subcategory)) {
    throw Exception('subcategory $subcategory already exists in the category $category');
  }

  saveSubcategory(categories, category, subcategory);

  categories[category]?.add(subcategory);

  return categories;
}

void addSubCategoryToJson(Map<String, List> categories, String category, String subcategory, [String? filePath]){
  var categoriesJson = {};

  List categoriesList = [];

  categories[category]?.add(subcategory);

  for (var category in categories.keys){
    categoriesList.add({'name':category, 'subcategories':categories[category]});
  }
  
  categoriesJson['categories'] = categoriesList;

  var usePath = (filePath == null) ? path: filePath;

  File(usePath).writeAsString(jsonEncode(categoriesJson));
}