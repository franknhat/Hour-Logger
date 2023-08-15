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

  Function _saveCategory = (_) => {};
  Function _saveSubcategory = (_, __) => {};

  Future<void> setStorageMethod(StoreCategory method) async {
    _saveCategory = method.saveCategory;
    _saveSubcategory = method.saveSubcategory;

    _categories = await method.getCategories();
  }

  void addCategory(String categoryName){
    if (categories.containsKey(categoryName)){
      throw Exception('This category already exists');
    }
    
    _categories[categoryName] = [];

    _saveCategory(categoryName);
  }

  void addSubCategory(String category, String subcategory){
    if (!_categories.containsKey(category)){
      throw Exception('category $category does not exist!');
    }

    if (_categories[category]!.contains(subcategory)) {
      throw Exception('subcategory $subcategory already exists in the category $category');
    }

    _saveSubcategory(category, subcategory);

    _categories[category]?.add(subcategory);
  }
}