class Category{
  final String name;
  String description;
  final Map<String, Category> _subcategories = {};
  Category? parent;

  //Category must be initalized with a name and optionally a parent (that doesnt have its own parent) and description (else will be set to nothing)
  Category(this.name, {this.parent, this.description = ''}){
    if(parent?.parent != null){
      throw Exception('category class cannot have a grandparent');      
    }
  }
  
  //TODO: Test this function
  bool addSubcategory(String subcategoryName, {String description = ""}){
    if(parent != null || _subcategories.containsKey(name)) return false;

    _subcategories[subcategoryName] = Category(subcategoryName, parent: this);
    return true;
  }

  //TODO: Test this function
  void removeSubcategory(String subcategoryName){
    _subcategories.remove(subcategoryName);
  }

  //TODO: Test this function
  void changeDescription(String newDescription){
    description = newDescription;
  }

  //returns an immutable copy of subcategories.
  //TODO: Test this function
  Map<String, Category> get subcategories => Map.unmodifiable(_subcategories);

  //TODO: Test this function
  bool isSubcategory(){ return parent != null; }
}