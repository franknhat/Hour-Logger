import 'package:flutter_test/flutter_test.dart';
import 'package:hour_logger/categories_lib/category.dart';

void main(){
  test('canary test', () => expect(true, true));

  group('test category constructor\n', () { 
    testCategoryConstructor();
    testCategoryConstructor(parent: Category('some Parent'));
    testCategoryConstructor(description: 'some sort of description');
    testCategoryConstructor(parent: Category('some Parent'), description: 'some desc');

    test('have constructor fail on nesting too much', () {
      expect(() => testCategoryConstructor(parent: Category('someParent', parent: Category('Some grandparent'))), throwsException);
    });
  });
}

void testCategoryConstructor({Category? parent, String? description}){
  Category cat;
  String name = 'some name';

  if (parent != null && description != null) {
    cat = Category(name, parent: parent, description: description);
  } else if (parent != null) {//and there for description == null
    cat = Category(name, parent: parent);
  } else if (description != null) { //and therefore parent == null
    cat = Category(name, description: description);
  } else {
    cat = Category(name);
  }

  test(' - category constructor w/ {Category Name:$name, Parent:${parent != null}, and Description:${description.toString()}}', () {
    expect(cat.name, name);
    expect(cat.parent, parent);
    expect(cat.description, description??='');
  });
}