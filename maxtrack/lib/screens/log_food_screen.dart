import 'package:flutter/material.dart';
import 'package:logger/logger.dart'; 
import 'package:maxtrack/screens/add_food_screen.dart'; // Needed for the '+' button navigation

class LogFoodScreen extends StatefulWidget {
  const LogFoodScreen({super.key});

  @override
  State<LogFoodScreen> createState() => _LogFoodScreenState();
}

final _logger = Logger();

class _LogFoodScreenState extends State<LogFoodScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Food'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- SEARCH BAR & ADD BUTTON ROW ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search for a food or ingredient',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      _logger.d('Search query: $query');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddFoodScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- SEARCH RESULTS LIST ---
            const Expanded(
              child: Center(
                child: Text('Search results will appear here.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}