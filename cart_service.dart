import '../models/product.dart';

class CartItem {
  Product product;
  int qty;

  CartItem({required this.product, required this.qty});
}

class CartService {
  static final List<CartItem> _items = [];

  static List<CartItem> get items => _items;

  static void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _items[index].qty++;
    } else {
      _items.add(CartItem(product: product, qty: 1));
    }
  }

  static void removeFromCart(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
  }

  static void increaseQty(int productId) {
    final item = _items.firstWhere((i) => i.product.id == productId);
    item.qty++;
  }

  static void decreaseQty(int productId) {
    final item = _items.firstWhere((i) => i.product.id == productId);
    if (item.qty > 1) {
      item.qty--;
    } else {
      _items.remove(item);
    }
  }

  static double get total {
    return _items.fold(0, (sum, item) => sum + (item.product.price * item.qty));
  }
}
