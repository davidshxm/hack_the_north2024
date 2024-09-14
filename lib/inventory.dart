import 'package:flutter/material.dart';
import 'camera.dart';
import 'inventory_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<StatefulWidget> createState() => _InventoryPage();
}

class _InventoryPage extends State<Inventory> {
  final InventoryManager _inventoryManager = InventoryManager();
  PanelController _pc = PanelController();
  bool _isPanelVisible = false;
  String value = ''; // Initially set to an empty string

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
      body: SlidingUpPanel(
        renderPanelSheet: _isPanelVisible,
        backdropEnabled: true,
        controller: _pc,
        panel: Center(
          child: value.isNotEmpty &&
                  _inventoryManager.getEntryByName(value) != null
              ? Text(_inventoryManager.getEntryByName(value)["Description"]!)
              : const Text(
                  'Please select an item.'), // Fallback text if value is not set or null
        ),
        body: _body(),
        onPanelOpened: () {
          setState(() {
            _isPanelVisible = true; // Set to true when the panel is opened
          });
        },
        onPanelClosed: () {
          setState(() {
            _isPanelVisible = false; // Set to false when the panel is closed
          });
        },
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

  Widget _body() {
    return Container(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _inventoryManager.getItemCount(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      // Replace Container with ElevatedButton
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            value = _inventoryManager.getItemNameByIndex(
                                index); // Set value to the item string
                          });
                          _pc.open(); // Open the panel after setting the value
                        },
                        style: ElevatedButton.styleFrom(
                          elevation:
                              5, // You can adjust the elevation as needed
                          fixedSize: const Size(80, 80), // Set the size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors
                              .grey[400], // Set the button background color
                        ),
                        child:
                            null, // You can add an icon or image here if needed
                      ),
                      const SizedBox(height: 4),
                      // Item name below the icon (line up with graphic in box after)
                      Text(_inventoryManager.getItemNameByIndex(index),
                          style: const TextStyle(fontSize: 15)),
                    ],
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
