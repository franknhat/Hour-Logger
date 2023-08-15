import 'package:flutter_test/flutter_test.dart';
import 'package:hour_logger/categories.dart';
import 'package:hour_logger/categories_lib/storage_interface.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements StoreCategory {}

void main() async {
  final storage = MockStorage();

  setUp(() async {
    when(() => storage.getCategories()).thenAnswer((invocation) async { return {"trash1":[], "trash2":["rubbish"]}; });
    await Categories().setStorageMethod(storage);
  });

  tearDown(() => reset(storage)); 

  test('canary', () => {
    expect(true, true)
  });

  test('setStorageMethod calls get getCategories', () async {        
    verify(() => storage.getCategories()).called(1);
    expect(Categories().categories, {"trash1":[], "trash2":["rubbish"]});
  });

  group('add category', () {
    test('add category existing', () { 
      when(() => storage.saveCategory(any())).thenAnswer((invocation) async {});
      
      expect(() => Categories().addCategory('trash1'), throwsException);
      //should throw before even getting to storage.saveCategory
      verifyNever(() => storage.saveCategory(any()));
    });
    test('add new categorg', () async {
      when(() => storage.saveCategory(any())).thenAnswer((invocation) async {});

      Categories().addCategory('trash3');
      
      expect(Categories().categories, {'trash1':[], 'trash2':['rubbish'], 'trash3':[]});
      verify(() => storage.saveCategory(any())).called(1);
    });
  });

  group('add subcategories', () {
    setUp(() => when(() => storage.saveSubcategory(any(), any())).thenAnswer((invocation) async {}));
    
    test('add subcategory to an existing category', () {
      Categories().addSubCategory('trash1', 'subcategory');

      expect(Categories().categories, {'trash1':['subcategory'], 'trash2':['rubbish']});
      verify(() => storage.saveSubcategory(any(), any())).called(1);
    });

    test('try to add existing subcategory to existing category', () {
      expect(() => Categories().addSubCategory('trash2', 'rubbish'), throwsException);
      //should throw before even getting to storage.saveSubcategory
      verifyNever(() => storage.saveSubcategory(any(), any()));
    });

    test('try to add subcategories to nonexisting categories', () {
      expect(() => Categories().addSubCategory('NonExistant', 'should fail'), throwsException);
      //should throw before even getting to storage.saveSubcategory
      verifyNever(() => storage.saveSubcategory(any(), any()));
    });
 });
}
