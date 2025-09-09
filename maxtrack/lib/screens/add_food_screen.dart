import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:maxtrack/services/database_helper.dart';
import 'dart:io'; // Import for File class
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p; // Use 'as p' to avoid name conflicts

final _logger = Logger();

class AddFoodScreen extends StatefulWidget {
  final FoodItem? foodItem;
  const AddFoodScreen({super.key, this.foodItem});

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

  String? _imagePath;

  @override
  void initState() {
    super.initState();

    // Check if we are editing an existing item.
    if (widget.foodItem != null) {
      final item = widget.foodItem!;
      // Pre-fill the controllers with the existing data.
      _nameController.text = item.name;
      _caloriesController.text = item.caloriesPer100g.toString();
      _proteinController.text = item.proteinPer100g.toString();
      _carbsController.text = item.carbsPer100g.toString();
      _fatController.text = item.fatPer100g.toString();
      _imagePath = item.imagePath;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // Show a dialog to let the user choose between camera and gallery.
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Gallery'),
          ),
         ],
      ),
    );

    if (source == null) return; // User canceled the dialog

    // Use the image_picker to get the image file.
     final XFile? pickedFile = await picker.pickImage(source: source);

     if (pickedFile == null) return; // User canceled the picker

     // --- This is the crucial part: Copy the file to a permanent location ---
     final appDir = await getApplicationDocumentsDirectory();
     final fileName = p.basename(pickedFile.path); // Get the original file name
     final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

     // Update the state to show the preview.
     setState(() {
       _imagePath = savedImage.path;
     });

     _logger.d('Image picked and saved to: $_imagePath');
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
      'image_path': _imagePath,
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
                // This is a placeholder for the image preview.
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // If an image has been picked, display it. Otherwise, show an icon.
                  child: _imagePath != null
                      // Image.file is used to display an image from a local file path.
                      ? Image.file(File(_imagePath!), fit: BoxFit.cover)
                      : const Center(child: Icon(Icons.camera_alt, size: 50)),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement the image picking logic
                    _pickImage();
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Add Photo'),
                ),
                const SizedBox(height: 24),

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