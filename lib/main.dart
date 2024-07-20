import 'package:bloc_cubit_course/blocs/products/product_bloc.dart';
import 'package:bloc_cubit_course/blocs/products/product_event.dart';
import 'package:bloc_cubit_course/cubits/notifications/notification_cubit.dart';
import 'package:bloc_cubit_course/repositories/product_repository.dart';
import 'package:bloc_cubit_course/views/product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (ctx) =>
                ProductBloc(ProductRepository())..add(LoadProducts())),
        BlocProvider(create: (ctx) => NotificationCubit())
      ],
      child: MaterialApp(
        title: 'Bloc E-Commerce App',
        debugShowCheckedModeBanner: false,
        theme: FlexThemeData.light(
          appBarStyle: FlexAppBarStyle.scaffoldBackground,
          scaffoldBackground: const Color.fromARGB(255, 251, 245, 217),
          scheme: FlexScheme.bigStone,
        ),
        // The Mandy red, dark theme.
        darkTheme: FlexThemeData.dark(
            appBarStyle: FlexAppBarStyle.scaffoldBackground,
            scheme: FlexScheme.damask,
            scaffoldBackground: const Color.fromARGB(255, 16, 0, 104)),
        home: const ProductListScreen(),
      ),
    );
  }
}
