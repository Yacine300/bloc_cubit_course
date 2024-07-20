// lib/widgets/product_item.dart
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final Function(Product) onDelete;
  final Function(Product) onUpdate;
  final int tabItem;

  const ProductItem(
      {super.key,
      required this.product,
      required this.onDelete,
      required this.tabItem,
      required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text('\$${product.price}'),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.update,
              ),
              onPressed: () => onUpdate(product),
            ),
            Opacity(
              opacity: tabItem == 0 ? 1 : 0.2,
              child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                  ),
                  onPressed: () => tabItem == 0 ? onDelete(product) : null),
            ),
          ],
        ),
      ),
    );
  }
}
