import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MyApp now ONLY sets up the top-level app information, including the theme.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 82, 171, 187)),
        useMaterial3: true,
      ),
      // The 'home' is now a new, separate widget.
      home: const HomePage(),
    );
  }
}

// HomePage contains the actual screen layout.
// Its 'build' method will have a context that is INSIDE the MaterialApp.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Now, when we call Theme.of(context), it works!
    // It looks "up" the tree, finds the MaterialApp, and gets the correct theme.
    return Scaffold(
      appBar: AppBar(
        // This line is now able to find your custom teal color scheme.
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('MaxTrack')
      ),
      body: const Center(
        child: Text('Hello, User')
      ),
    );
  }
}