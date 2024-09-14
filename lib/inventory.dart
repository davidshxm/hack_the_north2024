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

  // Function to cycle through images based on the index
  String _getImageForIndex(int index) {
    List<String> images = [
      'assets/GameBoy-2.png',
      'assets/Card-2.png',
      'assets/Tamagotchi-2.png',
    ];
    return images[index % images.length]; // Cycle through the 3 images
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SlidingUpPanel(
        renderPanelSheet: _isPanelVisible,
        backdropEnabled: true,
        controller: _pc,
        panel: Center(
          child: value.isNotEmpty && _inventoryManager.test[value] != null
              ? Text(_inventoryManager.test[value]!)
              : const Text('Please select an item.'), // Fallback text if value is not set or null
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
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/InventoryBackground.png', // Replace with your image path
            fit: BoxFit.cover, // Ensures the image covers the entire background
          ),
        ),
        // Foreground content (GridView and other UI elements)
        SafeArea(
          child: Column(
            children: [
              SizedBox(height: 65,),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: _inventoryManager.inventoryItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return Stack(
                      alignment: Alignment.center, // Centers the content in the Stack
                      children: [
                        // IconButton with dynamic image
                        IconButton(
                          icon: Image.asset(_getImageForIndex(index)), // Dynamically set the image based on the index
                          iconSize: 150, // Adjust the icon size as needed
                          onPressed: () {
                            setState(() {
                              value = _inventoryManager.inventoryItems[index]; // Set value to the item string
                            });
                            _pc.open(); // Open the panel after setting the value
                          },
                        ),
                        // Text aligned to the center of the IconButton
                        Positioned(
                          bottom: 35, // Adjust this to control the vertical position of the text
                          child: Text(
                            _inventoryManager.inventoryItems[index],
                            style: const TextStyle(
                              fontSize: 18, // Adjust the font size as needed
                              color: Colors.white, // Set the text color
                              fontWeight: FontWeight.bold, // Make the text bold
                            ),
                            textAlign: TextAlign.center, // Aligns the text to center
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
