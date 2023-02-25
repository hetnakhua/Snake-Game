import 'package:flutter/material.dart';
import 'package:snake_game/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBtaXDYhGezhXIkItR8ErtNHY5ZnTSEw4g",
      authDomain: "snake-game-eb86a.firebaseapp.com",
      projectId: "snake-game-eb86a",
      storageBucket: "snake-game-eb86a.appspot.com",
      messagingSenderId: "832816934087",
      appId: "1:832816934087:web:2b62f17c0e9ca8f49122e2",
      measurementId: "G-2EY2NPFYGT",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(brightness: Brightness.dark),
    );
  }
}
