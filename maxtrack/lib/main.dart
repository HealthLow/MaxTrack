import 'package:flutter/material.dart';
import 'package:maxtrack/services/database_helper.dart';
import 'package:maxtrack/screens/add_food_screen.dart';

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

// Imports at the top of main.dart should remain the same.
// main() function and MyApp class remain the same.

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('MaxTrack'),
      ),
      // We are removing the floatingActionButton.
      // Instead, we will build our menu in the body.
      body: Padding(
        // Add some padding around the entire column.
        padding: const EdgeInsets.all(16.0),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Button 1: Log Food --- (with updated style)
                ElevatedButton(
                  onPressed: () { /* ... */ },
                  style: ElevatedButton.styleFrom(
                    // Get the primary color from the theme and make it 50% transparent
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    textStyle: const TextStyle(fontSize: 30),
                  ),
                  child: const Text('Log Food'),
                ),
                const SizedBox(height: 16),

                // --- Button 2: Add New Food --- (with updated style)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddFoodScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    // Get the primary color from the theme and make it 50% transparent
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    textStyle: const TextStyle(fontSize: 30),
                  ),
                  child: const Text('Add New Food'),
                ),
                const SizedBox(height: 16),

                // --- Button 3: Set Diet --- (with updated style)
                ElevatedButton(
                  onPressed: () { /* ... */ },
                  style: ElevatedButton.styleFrom(
                    // Get the primary color from the theme and make it 50% transparent
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    textStyle: const TextStyle(fontSize: 30),
                  ),
                  child: const Text('Set Diet'),
                ),
                const SizedBox(height: 16),

                // --- Button 4: Food History --- (with updated style)
                ElevatedButton(
                  onPressed: () { /* ... */ },
                  style: ElevatedButton.styleFrom(
                    // Get the primary color from the theme and make it 50% transparent
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    textStyle: const TextStyle(fontSize: 30),
                  ),
                  child: const Text('Food History'),
                ),

                // --- THIS IS THE NEW PART ---
                const Spacer(), // <-- ADD THIS SPACER WIDGET

                // --- Button 5: Import/Export Profile ---
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement Import/Export functionality
                    logger.d('Import/Export button pressed!');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    textStyle: const TextStyle(fontSize: 25),
                    // Let's give it a different color to distinguish it
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                  child: const Text('Import/Export Profile'),
                ),
                // --- END OF NEW PART ---
              ],
            ),
      ),
    );
  }
}