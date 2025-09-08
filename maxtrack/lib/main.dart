import 'package:flutter/material.dart';
import 'package:maxtrack/services/database_helper.dart'; // <-- New import

// This is the new main() function
Future<void> main() async {
  // Ensure Flutter is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database by getting the instance.
  // This will call the _initDatabase() function the first time.
  await DatabaseHelper.instance.database;

  // Then run the app.
  runApp(const MyApp());
}

// This is your existing MyApp class, unchanged.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 82, 171, 187)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// This is your existing HomePage class, unchanged.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('MaxTrack'), // I noticed you changed this, which is great!
      ),
      body: const Center(
        child: Text('Hello, User'), // And this too!
      ),
    );
  }
}