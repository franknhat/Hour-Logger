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

  setUp(() { 
    file.createSync();
    file.writeAsStringSync(testJsonMap.toString());
    jsonFunctions.jsonMap = jsonDecode(jsonEncode(testJsonMap));
  });

  tearDown(() => file.deleteSync());

  test('readJsonFileToMap', () async {
    file.writeAsStringSync('{"categories":[{"name":"trash1", "subcategories":[]},{"name":"trash2", "subcategories":["rubbish"]}]}');
    
    expect((await jsonFunctions.readJsonFileToMap('${Directory.current.path}/test.json')).isNotEmpty, true);
  
    expect((await jsonFunctions.readJsonFileToMap('${Directory.current.path}/test.json')), {'categories':[{'name':'trash1', 'subcategories':[]},{'name':'trash2', 'subcategories':['rubbish']}]});
  });

  test('parseJsonMap', () async { 
    var map = {"categories":[{"name":"trash1", "subcategories":[]},{"name":"trash2", "subcategories":["rubbish"]}]};
    
    expect(jsonFunctions.parseJsonMap(map), {"trash1":[], "trash2":["rubbish"]});
  });

  //TODO MOCK OR SPY THIS
  test('getCategories', () async {
    file.writeAsStringSync('{"categories":[{"name":"trash1", "subcategories":[]},{"name":"trash2", "subcategories":["rubbish"]}]}');

    expect(await jsonFunctions.getCategories(), {"trash1":[], "trash2":["rubbish"]});

  });

  group('add category to json', (){
    test('add non existing category to json', () async {
      await jsonFunctions.saveCategory('trash3');

      var newCategories = jsonDecode(file.readAsStringSync());

      expect(newCategories, {"categories":[{"name":"trash1", "subcategories":[]},{"name":"trash2", "subcategories":["rubbish"]}, {"name":"trash3", "subcategories":[]}]});
    });

    test('add existing category to json', () async {
      expect(() async => await jsonFunctions.saveCategory('trash1'), throwsException);
    });
  });

  //TODO add more test cases for this senario
  group('addSubCategoryToJson', () {
    test('add nonexisting subcategory to existing category', () async {     
      await jsonFunctions.saveSubcategory('trash1', 'yeet');

      var contents = jsonDecode(file.readAsStringSync());

      expect(contents, {"categories":[{"name":"trash1","subcategories":["yeet"]},{"name":"trash2","subcategories":["rubbish"]}]});
    });
    
    test('add existing subcategory to existing category', () async {
      expect(() async => await jsonFunctions.saveSubcategory('trash2','rubbish'), throwsException);
    });

    test('add existing subcategory to nonexisting category', () async {
      expect(() async => await jsonFunctions.saveSubcategory('trash5','rubbish'), throwsException);
    });
  });
}