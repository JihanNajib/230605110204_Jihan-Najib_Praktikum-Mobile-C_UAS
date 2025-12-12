import 'package:flutter/material.dart';
import '../services/cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final items = CartService.items;

    return Scaffold(
      backgroundColor: const Color(0xFF1E2A38),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Cart",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Text(
                        "Your cart is empty",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (_, i) {
                        final item = items[i];
                        final p = item.product;

                        return Card(
                          color: const Color(0xFF243447),
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Image.network(
                              p.image,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              p.title,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "\$${p.price} x ${item.qty}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      CartService.decreaseQty(p.id);
                                    });
                                  },
                                  icon: const Icon(Icons.remove, color: Colors.white70),
                                ),
                                Text(
                                  "${item.qty}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      CartService.increaseQty(p.id);
                                    });
                                  },
                                  icon: const Icon(Icons.add, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 12),

            // subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Subtotal",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "\$${CartService.total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // tombol checkout
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5DEB3),
                foregroundColor: const Color(0xFF1E2A38),
                minimumSize: const Size.fromHeight(50),
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                if (CartService.items.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(                    
                    const SnackBar(content: Text("Your cart is empty"),
                    backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Order Successful"),
                    content: Text(
                      "Your order totaling \$${CartService.total.toStringAsFixed(2)} has been placed.",
                    style: const TextStyle(
      color: Colors.white,
                    ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          CartService.items.clear(); // kosongkan cart
                          Navigator.pop(context); // tutup dialog
                          Navigator.pop(context); // kembali ke home
                        },
                        child: const Text("OK"),
                      )
                    ],
                  ),
                );
              },
              child: const Text(
                "Proceed to checkout",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
