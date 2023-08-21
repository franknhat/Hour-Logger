interface class StoreCategory{
  Future<Map> getCategories() async { throw Exception('not yet implemented'); }
  Future<void> saveCategory(String category, String description) async { }
  Future<void> saveSubcategory(String category, String subcategory, String description) async { }
}