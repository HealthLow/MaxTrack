import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maxtrack/services/database_helper.dart'; // We will need this
import 'package:maxtrack/screens/add_food_screen.dart';

class FoodListScreen extends StatefulWidget {
  const FoodListScreen({super.key});

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  // We will use a Future to hold the list of food items from the database.
  late Future<List<FoodItem>> _foodItemsFuture;

  @override
  void initState() {
    super.initState();
    // When the screen is first created, we'll start fetching the food items.
    _foodItemsFuture = _loadFoodItems();
  }

  // This function will get all food items from the database.
  Future<List<FoodItem>> _loadFoodItems() {
    // We will implement the actual database call here in the next step.
    // For now, it returns an empty list after a short delay.
    return DatabaseHelper.instance.getAllFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text('All Food Items'),
    ),
    // Replace the simple Center widget with a FutureBuilder
    body: FutureBuilder<List<FoodItem>>(
      future: _foodItemsFuture, // This is the future we want to "watch".
      builder: (context, snapshot) {
        // 1. WAITING STATE: Check if we are still waiting for the data.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // 2. ERROR STATE: Check if an error occurred.
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // 3. NO DATA STATE: Check if we got data, but the list is empty.
        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No food items found. Add some!'));
        }
        // 4. DATA STATE: We have data! Build the list.
        else {
          final foodItems = snapshot.data!;
          return ListView.builder(
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final item = foodItems[index];
              // We can use a different tile color for ingredients vs. foods
              final tileColor = item.isIngredient == 1
                  ? Colors.teal.withAlpha((255 * 0.1).round())
                  : null;

              return Card(
                color: tileColor,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                   leading: SizedBox(
                        width: 56, // A fixed width for the image container
                        height: 56, // A fixed height
                        // Use a ClipRRect to make the image have rounded corners like the Card
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: item.imagePath != null && File(item.imagePath!).existsSync()
                              ? Image.file(
                                  File(item.imagePath!),
                                  fit: BoxFit.cover, // This will crop the image to fill the box
                                )
                              : Container( // Placeholder if no image
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.fastfood, color: Colors.white),
                                ),
                        ),
                      ),
                  title: Text(item.name),
                  subtitle: Text(
                    'C: ${item.caloriesPer100g.toStringAsFixed(0)} | '
                    'P: ${item.proteinPer100g.toStringAsFixed(0)} | '
                    'C: ${item.carbsPer100g.toStringAsFixed(0)} | '
                    'F: ${item.fatPer100g.toStringAsFixed(0)}'
                  ),
                  onTap: () {
                   Navigator.push(
                     context,
                      MaterialPageRoute(
                        // Pass the selected 'item' to the AddFoodScreen
                        builder: (context) => AddFoodScreen(foodItem: item),
                      ),
                    ).then((_) {
                     // This code runs when we come BACK from the AddFoodScreen.
                     // We refresh the list to see the updated data.
                    setState(() {
                      _foodItemsFuture = _loadFoodItems();
                    });
                   });
                 },
                ),
              );
            },
          );
        }
      },
    ),
  );
  }
}