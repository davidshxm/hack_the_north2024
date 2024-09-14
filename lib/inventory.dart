import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'camera.dart';
import 'chatbot.dart';
import 'inventory_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Inventory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InventoryPage();
}

class _InventoryPage extends State<Inventory> {
  bool _isPanelVisible = false;
  bool isNull = true;
  final InventoryManager _inventoryManager = InventoryManager();
  PanelController _pc = PanelController();
  int Index = -1;

  @override
  void initState() {
    super.initState();
  }
  

  // Function to select a random image
  String _getRandomImage(int index) {
    List<String> images = [
      'assets/GameBoy-2.png',
      'assets/Card-2.png',
      'assets/Tamagotchi-2.png',
    ];
    return images[index % images.length];
  }

  @override
  Widget build(BuildContext context) {
    print(_inventoryManager.getItemCount());
    return Scaffold(
      appBar: AppBar(
        title: Text("SlidingUpPanelExample"),
      ),
      body: SlidingUpPanel(
        renderPanelSheet: _isPanelVisible,
        backdropEnabled: true,
        controller: _pc,
        panel: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatBot(prompt: "Hello!"),
                      ));
                },
                child: const Text('ChatBot'),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => ChatBot()));
                },
                child: Text(_inventoryManager.getEntryByName(_inventoryManager.getItemNameByIndex(Index))['name'] ?? "",),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => ChatBot()));
                },
                child: Text(_inventoryManager.getEntryByName(_inventoryManager.getItemNameByIndex(Index))['description'] ?? "",),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => ChatBot()));
                },
                child: Text(_inventoryManager.getEntryByName(_inventoryManager.getItemNameByIndex(Index))['weight'] ?? "",),
              ),
              Column(
                children: [
                  if(!isNull)
                  for (int index = 0; index < _inventoryManager.getEntryByName(_inventoryManager.getItemNameByIndex(Index))['nutrition'].length; index++)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => ChatBot()));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                        children: [
                          Text(_inventoryManager.getEntryByName(_inventoryManager.getItemNameByIndex(index))['nutrition']['name'],
                            style: TextStyle(fontWeight: FontWeight.bold), // Nutrient name
                          ),
                          SizedBox(height: 5), // Space between lines
                          Text(_inventoryManager.getEntryByName(_inventoryManager.getItemNameByIndex(index))['nutrition']['value'], // Nutrient description
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
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
      floatingActionButton: _isPanelVisible
          ? null // Hide FAB when the panel is visible
          : FloatingActionButton(
              onPressed: () {
                // Navigate to the camera page when clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Camera(),
                  ),
                );
              },
              child: Image.asset('assets/PlusButton.png'),
              elevation: 0, // Remove shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    30), // Adjust the border radius if needed
              ),
              backgroundColor: Colors
                  .transparent, // Make background transparent to remove border effect
            ),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/fridgeBg.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 65,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: (_inventoryManager.getItemCount() / 3).ceil(),
                    itemBuilder: (context, rowIndex) {
                      int startIndex = rowIndex * 3;
                      int endIndex =
                          min(startIndex + 3, _inventoryManager.getItemCount());

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(3, (index) {
                              if (startIndex + index < endIndex) {
                                return _buildInventoryItem(startIndex + index);
                              } else {
                                // put empty container when less than 3 to keep sizing consistent
                                return _buildEmptyItem();
                              }
                            }),
                          ),
                          // fridge divider, replace with fridge bar image later
                          Divider(
                            color: Colors.grey,
                            thickness: 2,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryItem(int index) {
    return Expanded(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Image.asset(
                  _getRandomImage(index),
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                iconSize: 100,
                onPressed: () {
                  setState(() {
                    isNull = false;
                    Index = index;
                  });
                  _pc.open();
                },
              ),
              // Text aligned to the center of the IconButton
              Positioned(
                bottom:
                    22, // Adjust this to control the vertical position of the text
                child: Text(
                  _inventoryManager.getItemLabelByIndex(index),
                  style: const TextStyle(
                      fontSize: 15, // Adjust the font size as needed
                      color: Colors.white, // Set the text color
                      fontWeight: FontWeight.bold, // Make the text bold
                      fontFamily: 'PixelifySans'),
                  textAlign: TextAlign.center, // Aligns the text to center
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // add an empty item to fill up space in the row
  Widget _buildEmptyItem() {
    return Expanded(
      child: Container(
        width: 100,
        height: 100,
      ),
    );
  }
}
