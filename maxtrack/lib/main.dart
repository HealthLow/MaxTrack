import 'package:flutter/material.dart';
import 'package:maxtrack/services/database_helper.dart';
import 'package:maxtrack/screens/add_food_screen.dart';
import 'package:maxtrack/screens/log_food_screen.dart';
import 'package:logger/logger.dart';

//main() function
Future<void> main() async {
  // Ensure Flutter is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database by getting the instance.
  // This will call the _initDatabase() function the first time.
  await DatabaseHelper.instance.database;

  // Then run the app.
  runApp(const MyApp());
}

final _logger = Logger();

//MyApp class
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('MaxTrack'),
      ),
      //Build menu in the body.
      body: Padding(
        // Add some padding around the entire column.
        padding: const EdgeInsets.all(16.0),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Button 1: Log Food --- 
                ElevatedButton(
                  onPressed: () { 
                    //navigates to log food screen
                   Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogFoodScreen()),
                    ); 
                  },
                  style: ElevatedButton.styleFrom(
                    // Get the primary color from the theme and make it x% transparent
                    // (255 * 0.5).round() calculates the alpha value for 50% opacity.
                    backgroundColor: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.1).round()),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    textStyle: const TextStyle(fontSize: 30),
                  ),
                  child: const Text('Log Food'),
                ),
                const SizedBox(height: 16),

                // --- Button 2: Add New Food ---)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddFoodScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    // Get the primary color from the theme and make it 10% transparent
                    backgroundColor: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.1).round()),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    textStyle: const TextStyle(fontSize: 30),
                  ),
                  child: const Text('Add New Food'),
                ),
                const SizedBox(height: 16),

                // --- Button 3: Set Diet ---
                ElevatedButton(
                  onPressed: () { /* ... */ },
                  style: ElevatedButton.styleFrom(
                    // Get the primary color from the theme and make it 10% transparent
                    backgroundColor: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.1).round()),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    textStyle: const TextStyle(fontSize: 30),
                  ),
                  child: const Text('Set Diet'),
                ),
                const SizedBox(height: 16),

                // --- Button 4: Food History ---
                ElevatedButton(
                  onPressed: () { /* ... */ },
                  style: ElevatedButton.styleFrom(
                    // Get the primary color from the theme and make it 10% transparent
                    backgroundColor: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.1).round()),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    textStyle: const TextStyle(fontSize: 30),
                  ),
                  child: const Text('Food History'),
                ),

                const SizedBox(height: 16),

                // --- Button 5: View All Foods ---
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to the Food List screen
                    _logger.d('View All Foods button pressed!');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    textStyle: const TextStyle(fontSize: 30),
                    backgroundColor: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.1).round()),
                  ),
                  child: const Text('View All Foods'),
                ),

                const Spacer(), //SPACER WIDGET

                // --- Button 6: Import/Export Profile ---
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement Import/Export functionality
                    _logger.d('Import/Export button pressed!');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    textStyle: const TextStyle(fontSize: 25),
                    //different color to distinguish it
                    backgroundColor: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.4).round()),
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                  child: const Text('Import/Export Profile'),
                ),
              ],
            ),
      ),
    );
  }
}