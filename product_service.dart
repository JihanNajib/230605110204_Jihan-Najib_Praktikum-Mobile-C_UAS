import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String baseUrl = "https://dummyjson.com/products";

  // Get furniture category products
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse("$baseUrl/category/furniture"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List products = jsonData["products"] ?? [];
      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products: ${response.statusCode}");
    }
  }

  // Get all products (View All)
  // GET all products
static Future<List<Product>> fetchAll() async {
  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List items = data["products"] ?? [];
    return items.map((e) => Product.fromJson(e)).toList();
  } else {
    throw Exception("Failed to fetch all products");
  }
}


  // GET by category (dynamic)
  static Future<List<Product>> getByCategory(String category) async {
    final url = "$baseUrl/category/$category";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List products = jsonData["products"] ?? [];
      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load category products");
    }
  }

  // Search
  static Future<List<Product>> searchProducts(String q) async {
    final response = await http.get(Uri.parse("$baseUrl/search?q=$q"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List products = jsonData["products"] ?? [];
      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to search products");
    }
  }

  // Create
  static Future<Product> createProduct(Product p) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(p.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to create product");
    }
  }

  // Update
  static Future<Product> updateProduct(int id, Product p) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(p.toJson()),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to update product");
    }
  }

  // Delete
  static Future<bool> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    return response.statusCode == 200;
  }
  
}

