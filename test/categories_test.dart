import 'package:flutter_test/flutter_test.dart';
import 'package:hour_logger/categories.dart';
import 'dart:io';

void main(){
  var path = '${Directory.current.path}/test.json';
  var file = File(path);

  test('canary', () => {
    expect(true, true)
  });

  test('readJsonFileToMap', () async {
    file.writeAsString('{"categories":[{"name":"trash1", "subcategories":[]},{"name":"trash2", "subcategories":["rubbish"]}]}');
    
    expect((await Categories().readJsonFileToMap('${Directory.current.path}/test.json')).isNotEmpty, true);
  
    file.delete();
  });

  test('parseJsonMap', () async { 
    var map = {"categories":[{"name":"trash1", "subcategories":[]},{"name":"trash2", "subcategories":["rubbish"]}]};
    
    expect(Categories().parseJsonMap(map), {"trash1":[], "trash2":["rubbish"]});
  });

  group('add category', () {
    test('add category existing', () {      
      expect(() => Categories().addCategory('trash1', {'trash1':[], 'trash2':[]}, (_, __) => {}), throwsException);
    });
    test('add new categorg', () {
      var returned = Categories().addCategory('trash3', {'trash1':[], 'trash2':[]}, (_, __) => {});
      
      expect(returned, {'trash1':[], 'trash2':[], 'trash3':[]});
    });
  });

  test('add category to json', () async {
    var categories = {'trash1':[], 'trash2':[]};
    file.writeAsString(categories.toString());

    await Categories().addCategoryToJson('trash3', categories, path);

    var newCategories = await file.readAsString();

    expect(newCategories.contains('trash1'), true);
    expect(newCategories.contains('trash2'), true);
    expect(newCategories.contains('trash3'), true);

    file.delete();
  });

  group('add subcategories', () {
    test('add subcategory to an existing category', () {
      var categories = {'trash1':[], 'trash2':[]};

      expect(Categories().addSubCategory(categories, 'trash1', 'subcategory', (_, __, ___) => {}), {'trash1':['subcategory'], 'trash2':[]});
    });

    test('try to add existing subcategory to existing category', () {
      var categories = {'trash1':['subcategory'], 'trash2':[]};

      expect(() => Categories().addSubCategory(categories, 'trash1', 'subcategory', (_, __, ___) => {}), throwsException);
    });

    test('try to add subcategories to nonexisting categories', () {
      var categories = {'trash1':[], 'trash2':[]};

      expect(() => Categories().addSubCategory(categories, 'NonExistant', 'should fail', (_, __, ___) => {}), throwsException);
    });

    test('addSubCategoryToJson', () async {
      var categories = {'trash1':[], 'trash2':[]};
      
      await Categories().addSubCategoryToJson(categories, 'trash1', 'yeet', path);

      var contents = await file.readAsString();

      expect(contents.contains('yeet'), true);
      expect(contents, '{"categories":[{"name":"trash1","subcategories":["yeet"]},{"name":"trash2","subcategories":[]}]}');

      file.delete();
    });
 });
}
