import 'package:flutter_test/flutter_test.dart';
import 'package:hour_logger/categories_lib/json_storage.dart';
import 'dart:convert';
import 'dart:io';

void main(){
  var path = '${Directory.current.path}/test.json';
  var file = File(path);

  var jsonFunctions = JsonCategories();
  jsonFunctions.path = path;

  const testJsonMap = {"categories":[{"name":"trash1", "subcategories":[]},{"name":"trash2", "subcategories":["rubbish"]}]};

  setUp(() => file.writeAsString(testJsonMap.toString()));

  tearDown(() => file.deleteSync());

  test('readJsonFileToMap', () async {
    file.writeAsString('{"categories":[{"name":"trash1", "subcategories":[]},{"name":"trash2", "subcategories":["rubbish"]}]}');
    
    expect((await jsonFunctions.readJsonFileToMap('${Directory.current.path}/test.json')).isNotEmpty, true);
  
    expect((await jsonFunctions.readJsonFileToMap('${Directory.current.path}/test.json')), {'categories':[{'name':'trash1', 'subcategories':[]},{'name':'trash2', 'subcategories':['rubbish']}]});
  });

  test('parseJsonMap', () async { 
    var map = {"categories":[{"name":"trash1", "subcategories":[]},{"name":"trash2", "subcategories":["rubbish"]}]};
    
    expect(jsonFunctions.parseJsonMap(map), {"trash1":[], "trash2":["rubbish"]});
  });

  //TODO MOCK OR SPY THIS
  test('getCategories', () async {
    file.writeAsString('{"categories":[{"name":"trash1", "subcategories":[]},{"name":"trash2", "subcategories":["rubbish"]}]}');

    expect(await jsonFunctions.getCategories(), {"trash1":[], "trash2":["rubbish"]});

  });

  //TODO add more test cases for this senario
  test('add category to json', () async {
    //since the test map is nested, we cant do a normal deep copy else the test cases affect eachother still
    jsonFunctions.jsonMap = json.decode(jsonEncode(testJsonMap));

    await jsonFunctions.saveCategory('trash3');

    var newCategories = jsonDecode(await file.readAsString());

    expect(newCategories, {"categories":[{"name":"trash1", "subcategories":[]},{"name":"trash2", "subcategories":["rubbish"]}, {"name":"trash3", "subcategories":[]}]});
  });

  //TODO add more test cases for this senario
  test('addSubCategoryToJson', () async {
    //since the test map is nested, we cant do a normal deep copy else the test cases affect eachother still
    jsonFunctions.jsonMap = json.decode(jsonEncode(testJsonMap));
    
    await jsonFunctions.saveSubcategory('trash1', 'yeet');

    var contents = jsonDecode(await file.readAsString());

    expect(contents, {"categories":[{"name":"trash1","subcategories":["yeet"]},{"name":"trash2","subcategories":["rubbish"]}]});
  });
}