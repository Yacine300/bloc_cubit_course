import 'package:bloc/bloc.dart';
import 'package:bloc_cubit_course/models/product.dart';

class NotificationCubit extends Cubit<Map<String, dynamic>> {
  NotificationCubit() : super({});

  void showNotification(String message, {Product? product}) {
    emit({
      'message': message,
      'product': product,
    });
  }

  void clearNotification() {
    emit({});
  }
}
