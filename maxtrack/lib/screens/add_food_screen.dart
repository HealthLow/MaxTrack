import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:maxtrack/services/database_helper.dart';

final logger = Logger();

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  // A GlobalKey for our form to uniquely identify it.
  final _formKey = GlobalKey<FormState>();

  // Create a text controller for each field.
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  // This is a good practice to clean up the controllers when the screen is disposed.
  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }
 Future<void> _saveFoodItem({required bool isIngredient}) async {
    // First, get a reference to the database.
    
    final isValid = _formKey.currentState!.validate();
     // If any validator returns an error message, 'validate()' returns false.
    if (!isValid) {
      logger.w('Form is not valid. Aborting save.');
      return; // Stop the function here if the form is not valid.
    }

    final db = await DatabaseHelper.instance.database;

    // Create a Map (which is like a dictionary or JSON object) of the data.
    // The keys MUST match the column names in your database table exactly.
    final foodData = {
      'name': _nameController.text,
      'calories_per_100g': double.tryParse(_caloriesController.text) ?? 0.0,
      'protein_per_100g': double.tryParse(_proteinController.text) ?? 0.0,
      'carbs_per_100g': double.tryParse(_carbsController.text) ?? 0.0,
      'fat_per_100g': double.tryParse(_fatController.text) ?? 0.0,
      'is_ingredient': isIngredient ? 1 : 0, // Here is where we use the flag!
      // 'image_path' will be null for now.
    };

    // Use the 'insert' method from sqflite.
    // This returns the 'id' of the new row that was inserted.
    final id = await db.insert('food_items', foodData);

    logger.i('Inserted food item with ID: $id and data: $foodData');

    // Optional: Show a confirmation message to the user
    if (mounted) { // 'mounted' checks if the screen is still visible
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_nameController.text} saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Food'),
      ),
      // We use a ListView to prevent the screen from overflowing
      // if the keyboard pops up and takes up space.
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              // This makes the form fields appear vertically.
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Food Name',
                    border: OutlineInputBorder(),
                  ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                       return 'Please enter a food name'; // The error message
                      }
                     return null; // The input is valid
                    },
                  // We can add validation later.
                ),
                const SizedBox(height: 16), // A little space between fields
                TextFormField(
                  controller: _caloriesController,
                  decoration: const InputDecoration(
                    labelText: 'Calories (per 100g)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number, // Show a number keyboard
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter calories';
                    }
                   if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                   }
                   return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _proteinController,
                  decoration: const InputDecoration(
                    labelText: 'Protein (per 100g)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _carbsController,
                  decoration: const InputDecoration(
                    labelText: 'Carbs (per 100g)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fatController,
                  decoration: const InputDecoration(
                    labelText: 'Fat (per 100g)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24), // More space before the button
                Row(
                      children: [
                        // We use an Expanded widget to make each button take up
                        // half of the available width.
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Handle "Save Ingredient" logic
                              _saveFoodItem(isIngredient: true);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(fontSize: 16),
                              // Let's give it a slightly different color
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              foregroundColor: Theme.of(context).colorScheme.onSecondary,
                            ),
                            child: const Text('Save Ingredient'),
                          ),
                        ),
                        const SizedBox(width: 16), // A spacer between the buttons
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Handle "Save Food" logic (for full meals)
                              _saveFoodItem(isIngredient: false);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: const Text('Save Food'),
                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}