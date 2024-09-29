class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final String category;
  final double? discount;
  final int salesCount; // إضافة عدد المبيعات

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.category,
    this.discount,
    this.salesCount = 0, // قيمة افتراضية
  });

  double get discountedPrice => 
      discount != null ? price - (price * discount! / 100) : price;
}