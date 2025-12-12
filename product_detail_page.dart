import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/cart_service.dart';
import 'edit_product_page.dart';
import 'cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({required this.product, Key? key}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Product _product;
  String selectedColor = '';

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    if (_product.colors.isNotEmpty) selectedColor = _product.colors.first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = _product;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: p.image.isNotEmpty
                      ? Image.network(
                          p.image,
                          height: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(height: 220, color: Colors.grey),
                        )
                      : Container(height: 220, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 16),

              // Title & price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      p.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (p.oldPrice != null)
                        Text(
                          '\$${p.oldPrice!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      Text(
                        '\$${p.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Rating
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orangeAccent, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '${p.rating} (${p.reviews} reviews)',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                p.description,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              // Colors
              Text(
                'Available Colors',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: p.colors.map((hex) {
                  final color = _hexToColor(hex);
                  final isSelected = hex == selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => selectedColor = hex),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: isSelected ? Colors.orangeAccent : Colors.transparent,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: color,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // Add to cart
              ElevatedButton.icon(
                  onPressed: () {
                    CartService.addToCart(widget.product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Added to cart")),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text("Add to Cart"),
                ),
              const SizedBox(height: 30),

              // Edit button
              TextButton(
                onPressed: () async {
                  final updated = await Navigator.push<Product?>(
                    context,
                    MaterialPageRoute(builder: (_) => EditProductPage(product: _product)),
                  );

                  if (updated != null && mounted) {
                    setState(() => _product = updated);
                    // return updated to caller so HomePage can update list
                    Navigator.pop(context, updated);
                  }
                },
                child: const Text(
                  "Edit Product",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Delete button
              TextButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Product"),
                      content: const Text("Are you sure you want to delete this item?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    final success = await ProductService.deleteProduct(_product.id);
                    if (!mounted) return;
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Product deleted successfully")));
                      Navigator.pop(context); // pop detail
                      // parent HomePage will detect null/refresh
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to delete product")));
                    }
                  }
                },
                child: const Text(
                  "Delete Product",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
