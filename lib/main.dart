import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyAiceVC1V-WtvzbzYFJLNBJImXKd3a1BzM',
    appId: '1:519442447738:android:7a0ae4b70b6c18aa03eac3',
    messagingSenderId: '519442447738',
    projectId: 'fcmtest-27376',
    storageBucket: 'fcmtest-27376.firebasestorage.app',
  ));
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  String _token = '';

  void getToken() {
    setState(() {
      _token = FirebaseApi().getToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Device Token:',
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SelectableText(
                _token,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            ElevatedButton(onPressed: getToken, child: const Text('Get Token')),
          ],
        ),
      ),
    );
  }
}
