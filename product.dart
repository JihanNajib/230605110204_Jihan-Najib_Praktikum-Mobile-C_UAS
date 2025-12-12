class Product {
  final int id;
  final String title;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviews;
  final String description;
  final List<String> colors;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.colors,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> j) {
    return Product(
      id: j['id'] ?? 0,
      title: j['title'] ?? "No title",
      price: (j['price'] as num?)?.toDouble() ?? 0.0,

      // many items in dummyjson furniture have NO discountPercentage
      oldPrice: (j['discountPercentage'] != null)
          ? (j['price'] / (1 - (j['discountPercentage'] / 100))).toDouble()
          : null,

      // many items NO rating
      rating: (j['rating'] as num?)?.toDouble() ?? 4.5,

      // many items NO stock
      reviews: j['stock'] ?? 12,

      description: j['description'] ?? "No description provided",

      // custom colors
      colors: ["#C4A484", "#8B4513", "#000000"],

      // dummyjson furniture: some have thumbnail, some only images
      image: j['thumbnail'] ??
          (j['images'] != null && j['images'].isNotEmpty
              ? j['images'][0]
              : ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "description": description,
        "rating": rating,
        "stock": reviews,
        "thumbnail": image,
      };
}
