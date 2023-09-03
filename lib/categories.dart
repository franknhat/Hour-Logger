import 'categories_lib/categories_storage_interface.dart';

class Categories{
  static final Categories _categoriesClass = Categories._internal();

  factory Categories(){
    return _categoriesClass;
  }

  Categories._internal();
  ///the lines above made the class a singleton
  
  Map _categories = {};
  Map get categories => _categories;
  //consider adding comment of expected format

  Function _saveCategory = (_, __) => {};
  Function _saveSubcategory = (_, __, ___) => {};

  Future<void> setStorageMethod(StoreCategory method) async {
    _saveCategory = method.saveCategory;
    _saveSubcategory = method.saveSubcategory;

    _categories = await method.getCategories();
    //consider running/making a function to validate the format
  }

  void addCategory(String categoryName, {String description = ''}){
    if (categories.containsKey(categoryName)){
      throw Exception('This category already exists');
    }
    
    _categories[categoryName] = {'subcategories':[], 'description':description};

    _saveCategory(categoryName, description);
  }

  void addSubCategory(String category, String subcategory, {String description = ''}){
    if (!_categories.containsKey(category)){
      throw Exception('category $category does not exist!');
    }

    //Is this part dry/readable?
    if (_categories[category]["subcategories"].indexWhere((someSubcategory) => someSubcategory['name'] == subcategory) != -1) {
      throw Exception('subcategory $subcategory already exists in the category $category');
    }

    _saveSubcategory(category, subcategory, description);

    _categories[category]["subcategories"]?.add({"name":subcategory, "description":description});
  }

  //TODO: Remove categories
  //TODO: Remove subcategories
  //TODO: Change Descriptions
}