class CategoryModel {
  final String id;
  final String name;
  final String icon; // emoji veya icon kodu

  CategoryModel({required this.id, required this.name, required this.icon});
}

class DefaultCategories {
  static List<CategoryModel> categories = [
    CategoryModel(id: "market", name: "Market", icon: "🛒"),
    CategoryModel(id: "cafe", name: "Kafe", icon: "☕"),
    CategoryModel(id: "transport", name: "Ulaşım", icon: "🚌"),
    CategoryModel(id: "rent", name: "Kira", icon: "🏠"),
    CategoryModel(id: "bills", name: "Faturalar", icon: "💡"),
    CategoryModel(id: "entertainment", name: "Eğlence", icon: "🎮"),
    CategoryModel(id: "other", name: "Diğer", icon: "📦"),
  ];
}
