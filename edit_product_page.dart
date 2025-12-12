import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({required this.product, Key? key}) : super(key: key);

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController descCtrl;
  late TextEditingController imageCtrl;

  bool loading = false;
  String imagePreview = "";

  @override
  void initState() {
    super.initState();

    titleCtrl = TextEditingController(text: widget.product.title);
    priceCtrl = TextEditingController(text: widget.product.price.toString());
    descCtrl = TextEditingController(text: widget.product.description);
    imageCtrl = TextEditingController(text: widget.product.image);

    imagePreview = widget.product.image;

    imageCtrl.addListener(() {
      setState(() => imagePreview = imageCtrl.text.trim());
    });
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    priceCtrl.dispose();
    descCtrl.dispose();
    imageCtrl.dispose();
    super.dispose();
  }

  bool _isValidUrl(String s) {
    return s.startsWith("http://") || s.startsWith("https://");
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final updated = Product(
      id: widget.product.id,
      title: titleCtrl.text.trim(),
      price: double.tryParse(priceCtrl.text.trim()) ?? widget.product.price,
      description: descCtrl.text.trim(),
      image: imageCtrl.text.trim(),

      // FIX WAJIB
      rating: widget.product.rating,
      reviews: widget.product.reviews,
      colors: widget.product.colors,

      // Jika tidak ada category di model, hapus ini
      // category: widget.product.category,
    );

    try {
      final res = await ProductService.updateProduct(widget.product.id, updated);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Product updated!")));

      Navigator.pop(context, res);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update product")),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Widget _inputField(String label, TextEditingController ctrl,
      {TextInputType type = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        keyboardType: type,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return "Required";
          if (label == "Price" && double.tryParse(v.trim()) == null) {
            return "Must be a number";
          }
          if (label == "Image URL" && !_isValidUrl(v.trim())) {
            return "Enter a valid URL";
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E4C3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C293A),
        elevation: 0,
        title: const Text(
          "Edit Product",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _inputField("Title", titleCtrl),
              _inputField("Price", priceCtrl, type: TextInputType.number),
              _inputField("Image URL", imageCtrl),

              if (imagePreview.isNotEmpty) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imagePreview,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 150,
                      color: Colors.grey,
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),
              _inputField("Description", descCtrl, maxLines: 4),

              const SizedBox(height: 25),

              loading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C293A),
                        ),
                        onPressed: _updateProduct,
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
