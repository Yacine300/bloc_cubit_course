import 'package:bloc_cubit_course/blocs/products/product_bloc.dart';
import 'package:bloc_cubit_course/blocs/products/product_event.dart';
import 'package:bloc_cubit_course/blocs/products/product_state.dart';
import 'package:bloc_cubit_course/cubits/notifications/notification_cubit.dart';
import 'package:bloc_cubit_course/models/product.dart';
import 'package:bloc_cubit_course/views/product_detail_view.dart';
import 'package:bloc_cubit_course/widgets.dart/one_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_tabListener);
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabListener);
    _tabController.dispose();
    super.dispose();
  }

  void _tabListener() {
    setState(() {}); // Rebuild to show/hide FAB based on tab index
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Define the number of tabs
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _tabController.index == 0
                ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProductDetailScreen(),
                    ),
                  )
                : null;
          },
          child: Icon(
            Icons.add,
            color: _tabController.index == 0
                ? const Color.fromARGB(255, 250, 220, 155)
                : const Color.fromARGB(255, 250, 220, 155).withOpacity(0.2),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('BlocBuilder vs BlocSelector'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'BlocBuilder'),
              Tab(text: 'BlocSelector'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildProductListTab(context),
            _buildFilteredProductListTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListTab(BuildContext context) {
    return BlocListener<NotificationCubit, Map<String, dynamic>>(
      listener: (context, message) {
        _customSnackBarListener(context, message);
      },
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return ProductItem(
                  tabItem: _tabController.index,
                  product: state.products[index],
                  onUpdate: (product) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final TextEditingController nameController =
                            TextEditingController(text: product.name);
                        final TextEditingController priceController =
                            TextEditingController(
                                text: product.price.toString());

                        return AlertDialog(
                          title: const Text('Update Product'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                    labelText: 'Product Name'),
                              ),
                              TextField(
                                controller: priceController,
                                decoration: const InputDecoration(
                                    labelText: 'Product Price'),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                final updatedProduct = Product(
                                  id: product.id,
                                  rating: 1.5,
                                  name: nameController.text,
                                  price: double.parse(priceController.text),
                                );
                                BlocProvider.of<ProductBloc>(context)
                                    .add(UpdateProduct(updatedProduct));
                                Navigator.of(context).pop();
                                BlocProvider.of<NotificationCubit>(context)
                                    .showNotification('Update',
                                        product: product);
                              },
                              child: const Text('Update'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDelete: (product) {
                    BlocProvider.of<ProductBloc>(context)
                        .add(DeleteProduct(product.id));
                    BlocProvider.of<NotificationCubit>(context)
                        .showNotification('Delete', product: product);
                  },
                );
              },
            );
          } else if (state is ProductError) {
            return const Center(child: Text('Error loading products'));
          }
          return const Center(child: Text('No products available'));
        },
      ),
    );
  }

  Widget _buildFilteredProductListTab(BuildContext context) {
    return BlocListener<NotificationCubit, Map<String, dynamic>>(
      listener: (context, message) {
        _customSnackBarListener(context, message);
      },
      child: BlocSelector<ProductBloc, ProductState, List<Product>>(
        selector: (state) {
          if (state is ProductLoaded) {
            // Assuming you need to filter products here
            // For now, just return all products
            return state.products;
          }
          return [];
        },
        builder: (context, products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductItem(
                tabItem: 1,
                product: product,
                onUpdate: (product) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final TextEditingController nameController =
                          TextEditingController(text: product.name);
                      final TextEditingController priceController =
                          TextEditingController(text: product.price.toString());

                      return AlertDialog(
                        title: const Text('Update Product'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                  labelText: 'Product Name'),
                            ),
                            TextField(
                              controller: priceController,
                              decoration: const InputDecoration(
                                  labelText: 'Product Price'),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              final updatedProduct = Product(
                                id: product.id,
                                rating: 1.5,
                                name: nameController.text,
                                price: double.parse(priceController.text),
                              );
                              BlocProvider.of<ProductBloc>(context)
                                  .add(UpdateProduct(updatedProduct));
                              Navigator.of(context).pop();
                              BlocProvider.of<NotificationCubit>(context)
                                  .showNotification('Update', product: product);
                            },
                            child: const Text('Update'),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDelete: (product) {
                  BlocProvider.of<ProductBloc>(context).add(
                    DeleteProduct(product.id),
                  );
                  BlocProvider.of<NotificationCubit>(context)
                      .showNotification('Delete', product: product);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _customSnackBarListener(
      BuildContext context, Map<String, dynamic> notification) {
    final String message = notification['message'] ?? '';
    final Product? product = notification['product'];

    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              if (message == 'Add') {
                BlocProvider.of<ProductBloc>(context).add(
                  DeleteProduct(product!.id),
                );
              } else if (message == 'Update') {
                BlocProvider.of<ProductBloc>(context).add(
                  UpdateProduct(product!),
                );
              } else {
                BlocProvider.of<ProductBloc>(context).add(
                  AddProduct(product!),
                );
              }
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }
}
