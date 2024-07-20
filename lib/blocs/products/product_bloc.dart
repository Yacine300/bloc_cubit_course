import 'package:bloc_cubit_course/models/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../repositories/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductLoading()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final List<Product> products = await productRepository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onAddProduct(AddProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await productRepository.addProduct(event.product);
      final List<Product> products = await productRepository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onUpdateProduct(UpdateProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await productRepository.updateProduct(event.product);
      final List<Product> products = await productRepository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onDeleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    try {
      await productRepository.deleteProduct(event.productId);
      final List<Product> products = await productRepository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
