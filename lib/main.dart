import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_admin_panel/screen/products/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:grocery_admin_panel/home_screen/home_provider.dart';
import 'package:grocery_admin_panel/home_screen/home_screen.dart';
import 'firebase_options.dart';
import 'package:grocery_admin_panel/screen/categories/category_provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: false,
      splitScreenMode: true,
      fontSizeResolver: (fontSize, instance) => fontSize.toDouble(),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'poppins',
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}



