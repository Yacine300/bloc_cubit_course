import 'package:bloc_cubit_course/models/product.dart';

class ProductRepository {
  List<Product> _products = [
    Product(
        id: DateTime.now().toString(),
        name: 'product1',
        price: 200,
        rating: 2.0)
  ];

  Future<List<Product>> getProducts() async {
    return _products;
  }

  Future<void> addProduct(Product product) async {
    _products.add(product);
  }

  Future<void> updateProduct(Product product) async {
    //await Future.delayed(const Duration(seconds: 1));
    _products = _products.map((p) => p.id == product.id ? product : p).toList();
  }

  Future<void> deleteProduct(String productId) async {
    _products.removeWhere((product) => product.id == productId);
  }
}
