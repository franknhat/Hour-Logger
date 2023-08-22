import 'package:flutter_test/flutter_test.dart';
import 'package:hour_logger/categories_lib/json_categories_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:convert';
import 'dart:io';

class MockJsonCategories extends Mock implements JsonCategories {}

// TODO: consider if refactor is needed

void main(){
  var path = '${Directory.current.path}/test.json';
  var file = File(path);

  final jsonFunctions = JsonCategories();
  jsonFunctions.path = path;

  final mockJsonFunctions = MockJsonCategories();

  const testJsonMap = {"categories":[{"name":"trash1", "subcategories":[], "description":''},{"name":"trash2", "subcategories":[{"name":"rubbish", "description":''}], "description":""}]};

  setUp(() { 
    file.createSync();
    file.writeAsStringSync(jsonEncode(testJsonMap));
    jsonFunctions.jsonMap = jsonDecode(jsonEncode(testJsonMap));
  });

  tearDown(() => file.deleteSync());

  test('readJsonFileToMap', () async {    
    expect((await jsonFunctions.readJsonFileToMap('${Directory.current.path}/test.json')).isNotEmpty, true);
  
    expect((await jsonFunctions.readJsonFileToMap('${Directory.current.path}/test.json')), {"categories":[{"name":"trash1", "subcategories":[], "description":''},{"name":"trash2", "subcategories":[{"name":"rubbish", "description":''}], "description":""}]});
  });

  test('parseJsonMap', () async { 
    var map = {"categories":[{"name":"trash1", "subcategories":[], "description":''},{"name":"trash2", "subcategories":[{"name":"rubbish", "description":''}]}]};
    
    expect(jsonFunctions.parseJsonMap(map), {"trash1":[], "trash2":[{"name":"rubbish", "description":""}]});
  });

  test('getCategories', () async {
    //lmao I think im mocking wrong. I think mock is used for dependencies between classes, this calls for spy but its depreciated and in mockito not mocktail from what I can tell
    when(() => mockJsonFunctions.readJsonFileToMap(any())).thenAnswer((invocation) async { return testJsonMap; });
    when(() => mockJsonFunctions.parseJsonMap(any())).thenAnswer((invocation) => {"trash1":[], "trash2":[{"name":"rubbish", "description":""}]});

    when(() => mockJsonFunctions.getCategories()).thenAnswer((invocation) async {return mockJsonFunctions.parseJsonMap(mockJsonFunctions.readJsonFileToMap('something')); });

    expect(await mockJsonFunctions.getCategories(), {"trash1":[], "trash2":[{"name":"rubbish", "description":""}]});
    verify(() => mockJsonFunctions.readJsonFileToMap(any())).called(1);
    verify(() => mockJsonFunctions.parseJsonMap(any())).called(1);
    verify(() => mockJsonFunctions.getCategories()).called(1);
  });

  group('add category to json', (){
    test('add non existing category to json', () async {
      await jsonFunctions.saveCategory('trash3', '');

      var newCategories = jsonDecode(file.readAsStringSync());

      expect(newCategories, {"categories":[{"name":"trash1", "subcategories":[], "description":""},{"name":"trash2", "subcategories":[{"name":"rubbish", "description":""}], "description":""}, {"name":"trash3", "subcategories":[], "description":""}]});
    });

    test('add existing category to json', () async {
      expect(() async => await jsonFunctions.saveCategory('trash1', ''), throwsException);
    });
  });

  group('addSubCategoryToJson', () {
    test('add nonexisting subcategory to existing category', () async {     
      await jsonFunctions.saveSubcategory('trash1', 'yeet', '');

      var contents = jsonDecode(file.readAsStringSync());

      expect(contents, {"categories":[{"name":"trash1","subcategories":[{"name":"yeet", "description":""}], "description":""},{"name":"trash2","subcategories":[{"name":"rubbish", "description":""}], "description":""}]});
    });
    
    test('add existing subcategory to existing category', () async {
      expect(() async => await jsonFunctions.saveSubcategory('trash2','rubbish', ''), throwsException);
    });

    test('add existing subcategory to nonexisting category', () async {
      expect(() async => await jsonFunctions.saveSubcategory('trash5','rubbish', ''), throwsException);
    });
  });
}