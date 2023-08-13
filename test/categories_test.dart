import 'package:flutter_test/flutter_test.dart';
import 'package:hour_logger/categories.dart';

void main() async {
  test('canary', () => {
    expect(true, true)
  });

  group('add category', () {
    test('add category existing', () {      
      expect(() => Categories().addCategory('trash1', {'trash1':[], 'trash2':[]}), throwsException);
    });
    test('add new categorg', () {
      var returned = Categories().addCategory('trash3', {'trash1':[], 'trash2':[]});
      
      expect(returned, {'trash1':[], 'trash2':[], 'trash3':[]});
    });
  });

  group('add subcategories', () {
    test('add subcategory to an existing category', () {
      var categories = {'trash1':[], 'trash2':[]};

      expect(Categories().addSubCategory(categories, 'trash1', 'subcategory'), {'trash1':['subcategory'], 'trash2':[]});
    });

    test('try to add existing subcategory to existing category', () {
      var categories = {'trash1':['subcategory'], 'trash2':[]};

      expect(() => Categories().addSubCategory(categories, 'trash1', 'subcategory'), throwsException);
    });

    test('try to add subcategories to nonexisting categories', () {
      var categories = {'trash1':[], 'trash2':[]};

      expect(() => Categories().addSubCategory(categories, 'NonExistant', 'should fail'), throwsException);
    });

    //TODO Mocks for internal functions

 });
}
