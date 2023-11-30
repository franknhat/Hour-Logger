import 'categories_lib/category.dart';

//a wrapper class for the category class. This is basically the list of categories

class Categories{
  static final Categories _categoriesClass = Categories._internal();

  factory Categories(){
    return _categoriesClass;
  }

  Categories._internal();
  ///the lines above made the class a singleton
  
  Map<String, Category> _categories = {};
  Map<String, Category> get categories => Map.unmodifiable(_categories);
  
  //TODO: Create test for this function
  bool addCategory(String name, {String description = ""}){
    if(_categories.containsKey(name)) return false;

    _categories[name] = Category(name, description: description);
    return true;
  }

  //TODO: AddSubcategory
  //TODO: Remove Category
  //TODO: Remove Subcategory
  //TODO: Change description of category
  //TODO: Change description of subcategory
  //TODO: Storage


}