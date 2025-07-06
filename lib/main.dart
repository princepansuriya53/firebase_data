import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_data/Screens/Auth/login_ui.dart';
import 'package:firebase_data/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(375, 812),
      builder: (_, child) {
        return GetMaterialApp(
          title: 'Firebase Data',
          home: LoginUi(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
