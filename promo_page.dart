import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

class PromoPage extends StatefulWidget {
  const PromoPage({Key? key}) : super(key: key);

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  List<Product> promoProducts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadPromoItems();
  }

  /// Ambil produk furniture lalu filter diskon >= 20%
  Future<void> _loadPromoItems() async {
    setState(() => loading = true);

    try {
      // Ambil kategori furniture
      final list = await ProductService.getByCategory("furniture");

      promoProducts = list.where((p) {
        if (p.oldPrice == null) return false;
        final diskon = ((p.oldPrice! - p.price) / p.oldPrice!) * 100;
        return diskon >= 20; // promo 20% ke atas
      }).toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load promo products")),
      );
    }

    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  iconTheme: const IconThemeData(color: Colors.white),
  title: const Text(
    "Promo",
    style: TextStyle(color: Colors.white),
  ),
),


      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : promoProducts.isEmpty
              ? const Center(
                  child: Text(
                    "No promo items found",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: promoProducts.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    final p = promoProducts[i];

                    return ProductCard(
                      product: p,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(product: p),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
