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

   Future<void> _onFoodItemSelected(FoodItem foodItem) async {
    // A controller for the weight input field in the dialog.
    final weightController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // We need to check if the widget is still mounted before showing a dialog.
    if (!mounted) return;

    // showDialog returns a value when it's popped. We can check if it's 'true'.
    final bool? didLog = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Log "${foodItem.name}"'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: weightController,
              autofocus: true, // Automatically focus the field
              decoration: const InputDecoration(
                labelText: 'Weight consumed (in grams)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a weight';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(false), // Pop with 'false'
            ),
            ElevatedButton(
              child: const Text('Log'),
              onPressed: () async {
                // Validate the input.
                if (formKey.currentState!.validate()) {
                  final weight = double.parse(weightController.text);
                  
                  // Call our database helper to save the log.
                  await DatabaseHelper.instance.addLogEntry(
                    foodId: foodItem.id,
                    weightConsumed: weight,
                  );

                   if (dialogContext.mounted) {
                        // Pop the dialog and return 'true' to signal success.
                        Navigator.of(dialogContext).pop(true);
                      }
                  
                }
              },
            ),
          ],
        );
      },
    );

    // After the dialog closes, check if the food was successfully logged.
    if (didLog == true && mounted) {
      // You could show a confirmation SnackBar here if you want.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully logged ${foodItem.name}!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
                              _onFoodItemSelected(foodItem);
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