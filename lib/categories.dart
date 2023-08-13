//TODO refactor (consider separating Categories and the json functionality) class should follow SRP
import 'categories_lib/storage_interface.dart';

class Categories{
  static final Categories _categoriesClass = Categories._internal();

  factory Categories(){
    return _categoriesClass;
  }

  Categories._internal();
  ///the lines above made the class a singleton

  
  Map _categories = {};
  Map get categories => _categories;

  Function _saveCategory = (_, __) => {};
  Function _saveSubcategory = (_, __, ___) => {};

  void setStorageMethod(StoreCategory method) async {
    _saveCategory = method.saveCategory;
    _saveSubcategory = method.saveSubcategory;

    _categories = await method.getCategories();
  }

  //TODO use class map categories
  Map addCategory(String categoryName, Map categories){
    if (categories.containsKey(categoryName)){
      throw Exception('This category already exists');
    }
    
    categories[categoryName] = [];

    _saveCategory(categoryName, categories);

    return categories;
  }

  //TODO use class map categories
  Map addSubCategory(Map<String, List> categories, String category, String subcategory){
    if (!categories.containsKey(category)){
      throw Exception('category $category does not exist!');
    }

    if (categories[category]!.contains(subcategory)) {
      throw Exception('subcategory $subcategory already exists in the category $category');
    }

    _saveSubcategory(categories, category, subcategory);

    categories[category]?.add(subcategory);

    return categories;
  }
}