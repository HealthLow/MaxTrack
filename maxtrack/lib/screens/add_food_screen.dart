import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:maxtrack/services/database_helper.dart';

final _logger = Logger();

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  // A GlobalKey for the form to uniquely identify it.
  final _formKey = GlobalKey<FormState>();

  // Create a text controller for each field.
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  //good practice to clean up the controllers when the screen is disposed.
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
    // First, validate the form.
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      _logger.w('Form is not valid. Aborting save.');
      return; // Stop the function here if the form is not valid.
    }

    // If valid, proceed to save.
    final db = await DatabaseHelper.instance.database;
    final foodData = {
      'name': _nameController.text,
      'calories_per_100g': double.tryParse(_caloriesController.text) ?? 0.0,
      'protein_per_100g': double.tryParse(_proteinController.text) ?? 0.0,
      'carbs_per_100g': double.tryParse(_carbsController.text) ?? 0.0,
      'fat_per_100g': double.tryParse(_fatController.text) ?? 0.0,
      'is_ingredient': isIngredient ? 1 : 0,
    };

    final id = await db.insert('food_items', foodData);
    _logger.i('Inserted food item with ID: $id and data: $foodData');

    //we now call our dialog function.
    await _showConfirmationDialog(isIngredient: isIngredient);
  }

  Future<void> _showConfirmationDialog({required bool isIngredient}) async {
    if (!mounted) return;
    final itemType = isIngredient ? 'Ingredient' : 'Food';
    final message = '${_nameController.text} saved successfully as an $itemType!';

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Success!'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Add More'),
              onPressed: () {
                _nameController.clear();
                _caloriesController.clear();
                _proteinController.clear();
                _carbsController.clear();
                _fatController.clear();
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Back'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Food'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Food Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a food name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _caloriesController,
                  decoration: const InputDecoration(
                    labelText: 'Calories (per 100g)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
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
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _saveFoodItem(isIngredient: true);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onSecondary,
                        ),
                        child: const Text('Save Ingredient'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
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