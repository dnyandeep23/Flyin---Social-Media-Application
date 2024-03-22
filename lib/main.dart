import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flyin/pages/HomePage/home.dart';
import 'package:flyin/pages/LoginPage/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flyin/pages/Profile/profilepage.dart';
import 'firebase_options.dart';

late List<CameraDescription> _cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flyin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flyin'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child:
            // Container(height: screenHeight, child: Home(cameras:_cameras))
            Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoginPage(cameras:_cameras),
            // Add other widgets here if needed
          ],
        ),
      ),
    );
  }
}
