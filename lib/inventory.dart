import 'package:flutter/material.dart';
import 'camera.dart'; 
import 'inventory_manager.dart'; 

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<StatefulWidget> createState() => _InventoryPage();
}

class _InventoryPage extends State<Inventory> {
  final InventoryManager _inventoryManager = InventoryManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Inventory'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _inventoryManager.inventoryItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, 
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      // Each inventory icon, add in images later
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Item name below the icon (line up with graphic in box after)
                      Text(_inventoryManager.inventoryItems[index], style: const TextStyle(fontSize: 15)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[600],
        onPressed: () async {
          // Navigate to the camera page when clicked
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Camera(), 
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
