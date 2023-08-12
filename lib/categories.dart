//TODO refactor (consider separating Categories and the json functionality) class should follow SRP

class Categories{
  static final Categories _categoriesClass = Categories._internal();

  factory Categories(){
    return _categoriesClass;
  }

  Categories._internal();
  ///the lines above made the class a singleton

  Set _categories = {};
  Set get categories => _categories;

  Map _subcategories = {};
  Map get subcategories => _subcategories;

  Function? _readCategoreies;
  Function? _parseCategoreies;
  Function? _saveCategories;

  set readCategoreies(Function readCategoreies){
    _readCategoreies = readCategoreies;
  }

  set parseCategoreies(Function parseCategoreies){
    _parseCategoreies = parseCategoreies;
  }

  set saveCategories(Function saveCategories){
    _saveCategories = saveCategories;
  }

  Map addCategory(String categoryName, Map categories, Function storeCategory){
    if (categories.containsKey(categoryName)){
      throw Exception('This category already exists');
    }
    
    categories[categoryName] = [];

    storeCategory(categoryName, categories);

    return categories;
  }

  Map addSubCategory(Map<String, List> categories, String category, String subcategory, Function saveSubcategory){
    if (!categories.containsKey(category)){
      throw Exception('category $category does not exist!');
    }

    if (categories[category]!.contains(subcategory)) {
      throw Exception('subcategory $subcategory already exists in the category $category');
    }

    saveSubcategory(categories, category, subcategory);

    categories[category]?.add(subcategory);

    return categories;
  }
}