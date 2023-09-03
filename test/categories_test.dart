import 'package:flutter_test/flutter_test.dart';
import 'package:hour_logger/categories.dart';
import 'package:hour_logger/categories_lib/categories_storage_interface.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements StoreCategory {}

void main() async {
  final storage = MockStorage();

  setUp(() async {
    when(() => storage.getCategories()).thenAnswer((invocation) async { return {"trash1":{"subcategories":[], "description":""}, "trash2":{"subcategories":[{"name":"rubbish", "description":""}], "description":""}}; });
    await Categories().setStorageMethod(storage);
  });

  tearDown(() => reset(storage)); 

  test('canary', () => {
    expect(true, true)
  });

  test('setStorageMethod calls get getCategories\n', () async {        
    verify(() => storage.getCategories()).called(1);
    expect(Categories().categories, {"trash1":{"subcategories":[], "description":""}, "trash2":{"subcategories":[{"name":"rubbish", "description":""}], "description":""}});
  });

  group('add category:\n', () {
    test(' - add category existing\n', () { 
      when(() => storage.saveCategory(any(), any())).thenAnswer((invocation) async {});
      
      expect(() => Categories().addCategory('trash1'), throwsException);
      //should throw before even getting to storage.saveCategory
      verifyNever(() => storage.saveCategory(any(), any()));
    });
    test(' - add new category\n', () async {
      when(() => storage.saveCategory(any(), any())).thenAnswer((invocation) async {});

      Categories().addCategory('trash3');
      
      expect(Categories().categories, {"trash1":{"subcategories":[], "description":""}, "trash2":{"subcategories":[{"name":"rubbish", "description":""}], "description":""}, "trash3":{"subcategories":[], "description":""}});
      verify(() => storage.saveCategory(any(), any())).called(1);
    });
  });

  group('add subcategories:\n', () {
    setUp(() => when(() => storage.saveSubcategory(any(), any(), any())).thenAnswer((invocation) async {}));
    
    test(' - add subcategory to an existing category\n', () {
      Categories().addSubCategory('trash1', 'subcategory');

      expect(Categories().categories, {"trash1":{"subcategories":[{'name':'subcategory', 'description':''}], "description":""}, "trash2":{"subcategories":[{"name":"rubbish", "description":""}], "description":""}});
      verify(() => storage.saveSubcategory(any(), any(), any())).called(1);
    });

    test(' - try to add existing subcategory to existing category\n', () {
      expect(() => Categories().addSubCategory('trash2', 'rubbish'), throwsException);
      //should throw before even getting to storage.saveSubcategory
      verifyNever(() => storage.saveSubcategory(any(), any(), any()));
    });

    test(' - try to add subcategories to nonexisting categories\n', () {
      expect(() => Categories().addSubCategory('NonExistant', 'should fail'), throwsException);
      //should throw before even getting to storage.saveSubcategory
      verifyNever(() => storage.saveSubcategory(any(), any(), any()));
    });
 });
}
