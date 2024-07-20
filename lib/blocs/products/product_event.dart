import 'package:bloc_cubit_course/models/product.dart';

abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class AddProduct extends ProductEvent {
  final Product product;

  AddProduct(this.product);
}

class UpdateProduct extends ProductEvent {
  final Product product;

  UpdateProduct(this.product);
}

class DeleteProduct extends ProductEvent {
  final String productId;

  DeleteProduct(this.productId);
}
