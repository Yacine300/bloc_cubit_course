import 'package:bloc_cubit_course/blocs/products/product_bloc.dart';
import 'package:bloc_cubit_course/blocs/products/product_event.dart';
import 'package:bloc_cubit_course/cubits/notifications/notification_cubit.dart';
import 'package:bloc_cubit_course/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product? product;

  const ProductDetailScreen({super.key, this.product});

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.product?.name ?? '',
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: widget.product?.price.toString() ?? '',
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => _price = double.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Product myProduct = Product(
                        id: DateTime.now().toString(),
                        name: _name,
                        price: _price,
                        rating: 1.5);
                    if (widget.product == null) {
                      BlocProvider.of<ProductBloc>(context)
                          .add(AddProduct(myProduct));
                      BlocProvider.of<NotificationCubit>(context)
                          .showNotification('Add', product: myProduct);
                    } else {
                      BlocProvider.of<ProductBloc>(context).add(UpdateProduct(
                          Product(
                              id: widget.product!.id,
                              name: _name,
                              price: _price,
                              rating: 1.5)));
                      BlocProvider.of<NotificationCubit>(context)
                          .showNotification('Update', product: myProduct);
                    }

                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
