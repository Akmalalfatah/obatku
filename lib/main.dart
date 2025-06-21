import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:obatku/firebase_options.dart';
import 'package:obatku/pages/splash_screen.dart';
import 'package:obatku/pages/upload_medicines.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await MedicineUploader.uploadMedicines();
  runApp(const MyApp());
}

class InitFirebase extends StatelessWidget {
  const InitFirebase({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        }
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Firebase init failed: ${snapshot.error}'),
              ),
            ),
          );
        }

        return const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ObatKu',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
