import 'dart:async'; // Import for the Timer (debouncer)
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:maxtrack/screens/add_food_screen.dart';
import 'package:maxtrack/services/database_helper.dart'; // Import our helper AND FoodItem class

final _logger = Logger();

class LogFoodScreen extends StatefulWidget {
  const LogFoodScreen({super.key});

  @override
  State<LogFoodScreen> createState() => _LogFoodScreenState();
}

class _LogFoodScreenState extends State<LogFoodScreen> {
  final _searchController = TextEditingController();
  
  // A list to hold our search results. It starts empty.
  List<FoodItem> _searchResults = [];
  
  // A Timer for our debouncer
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  // This is our new search function
  void _search(String query) {
    // If the user clears the search, clear the results.
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    // Call the database helper to get the results.
    DatabaseHelper.instance.searchFoodItems(query).then((results) {
      // We use 'setState' to tell Flutter that our state has changed
      // and the UI needs to be rebuilt with the new results.
      if (mounted) { // Check if the widget is still in the tree
          setState(() {
            _searchResults = results;
          });
      }
    });
  }
  
  // --- The Debouncer ---
  // This prevents the search function from being called on every keystroke.
  void _onSearchChanged(String query) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
          _logger.d('Searching for: $query');
          _search(query);
      });
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
            Row(
              children: [
                 Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search for a food or ingredient',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),

                // --- ADD THESE WIDGETS BACK ---
                const SizedBox(width: 16),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // This line makes the import necessary!
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
            Expanded(
              // If the results list is empty, show a message.
              // Otherwise, show the ListView.
              child: _searchResults.isEmpty
                  ? const Center(
                      child: Text('No results found. Try a different search.'),
                    )
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final foodItem = _searchResults[index];
                        return Card(
                          child: ListTile(
                            title: Text(foodItem.name),
                            subtitle: Text('${foodItem.caloriesPer100g.toStringAsFixed(1)} kcal per 100g'),
                            onTap: () {
                              // TODO: Implement the dialog to ask for weight
                              _logger.i('User selected: ${foodItem.name}');
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}