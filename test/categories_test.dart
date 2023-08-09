import 'dart:convert';

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
    
    expect((await readJsonFileToMap('${Directory.current.path}/test.json')).isNotEmpty, true);
  
    file.delete();
  });

  test('parseJsonMap', () async { 
    var map = {"categories":[{"name":"trash1", "subcategories":[]},{"name":"trash2", "subcategories":["rubbish"]}]};
    
    expect(parseJsonMap(map), {"trash1":[], "trash2":["rubbish"]});
  });

  group('add category', () {
    test('add category existing', () {      
      expect(() => addCategory('trash1', {'trash1':[], 'trash2':[]}, (_, __) => {}), throwsException);
    });
    test('add new categorg', () {
      var returned = addCategory('trash3', {'trash1':[], 'trash2':[]}, (_, __) => {});
      
      expect(returned, {'trash1':[], 'trash2':[], 'trash3':[]});
    });
  });

  test('add category to json', () async {
    var categories = {'trash1':[], 'trash2':[]};
    file.writeAsString(categories.toString());

    addCategoryToJson('trash3', categories, path);

    var newCategories = await file.readAsString();

    expect(newCategories.contains('trash1'), true);
    expect(newCategories.contains('trash2'), true);
    expect(newCategories.contains('trash3'), true);

    file.delete();
  });
}