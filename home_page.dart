import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';
import 'cart_page.dart';
import '../services/cart_service.dart';
import 'promo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  bool loading = true;

  final searchCtrl = TextEditingController();

  final List<String> categories = [
    "furniture",
    "kitchen-accessories",
    "home-decoration",
    "furniture-office",
  ];

  String selectedCategory = "furniture";

  @override
  void initState() {
    super.initState();
    _loadCategory(selectedCategory);
  }

  Future<void> _loadCategory(String category) async {
    setState(() => loading = true);
    try {
      products = await ProductService.getByCategory(category);
      print("Jumlah produk yang berhasil dimuat: ${products.length}");
    } catch (e) {
      print("ERROR LOADING DATA: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed loading category")),
      );
    }
    setState(() => loading = false);
  }

  Future<void> _onSearch(String q) async {
    if (q.trim().isEmpty) return _loadCategory(selectedCategory);

    setState(() => loading = true);
    products = await ProductService.searchProducts(q);
    setState(() => loading = false);
  }

  int cartCount() => CartService.items.fold(0, (s, i) => s + i.qty);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,//

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Furni Store',
          style: GoogleFonts.playfairDisplay(
            color: theme.primaryColor,//
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // CART BADGE
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                  setState(() {});
                },
                icon: Icon(Icons.shopping_cart, color: theme.primaryColor),
              ),
              if (cartCount() > 0)
                Positioned(
                  right: 6,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      cartCount().toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          )
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () => _loadCategory(selectedCategory),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SEARCH BAR
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.black54),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: searchCtrl,
                          onSubmitted: _onSearch,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration.collapsed(
                            hintText: "Search products...",
                            hintStyle: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _onSearch(searchCtrl.text),
                        icon: const Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // CATEGORY TITLE + VIEW ALL REMOVED HERE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // CATEGORY CHIPS
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((c) {
                    final isSelected = c == selectedCategory;
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedCategory = c);
                        _loadCategory(c);
                      },
                      child: Chip(
                        label: Text(
                          c,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF1E2A38),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor:
                            isSelected ? Colors.orange : theme.primaryColor,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // BANNER PROMO
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Focus on sofas!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF1E2A38),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Up to 30% off on selected sofas for a limited time.',
                        style: TextStyle(color: Colors.black87),
                      ),
                      const SizedBox(height: 8),

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => PromoPage()),
                            );
                          },
                          child: const Text(
                            'See more →',
                            style: TextStyle(
                              color: Colors.orange,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),
                const SizedBox(height: 20),

                // NEW PRODUCTS TITLE
                Text(
                  'Newly added products',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 12),

                // PRODUCT LIST
                if (loading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                else if (products.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(
                      child: Text(
                        "No products found",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 260,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final p = products[i];
                        return ProductCard(
                          product: p,
                          onTap: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailPage(product: p),
                              ),
                            );

                            if (updated is Product) {
                              setState(() => products[i] = updated);
                            } else {
                              _loadCategory(selectedCategory);
                            }
                          },
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
