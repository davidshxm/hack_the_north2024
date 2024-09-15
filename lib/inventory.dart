import 'dart:math';
import 'dart:ui';
import 'dart:convert';
import 'dart:developer' as dev;
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
  int Index = 0; // -1

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
    Map<String, dynamic> product = _inventoryManager.getEntryByName(_inventoryManager.getItemNameByIndex(Index));
    return Scaffold(
      appBar: AppBar(
        title: Text("SlidingUpPanelExample"),
      ),
      body: SlidingUpPanel(
        renderPanelSheet: _isPanelVisible,
        backdropEnabled: true,
        controller: _pc,
        panel: _buildPanelContent(context),
        body: _body(),
        onPanelOpened: () {
          _isPanelVisible = true;
        },
        onPanelClosed: () {
          _isPanelVisible = false;
        },
      ),
      floatingActionButton: _isPanelVisible
          ? null // Hide FAB when the panel is visible
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Camera()),
                );
              },
              child: Image.asset('assets/PlusButton.png'),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
              backgroundColor: Colors.transparent,
            ),
    );
  }

  Widget _buildPanelContent(BuildContext context) {
    return SingleChildScrollView(
      child: ListView(
        children: [
          _buildFullWidthButton(
            context,
            text: product['name'] ?? "",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChatBot()),
              );
            },
          ),
          _buildFullWidthButton(
            context,
            text: product['description'] ?? "",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChatBot()),
              );
            },
          ),
          _buildExpandableSection(
            title: "Nutrients",
            items: product['nutrients'],
            onPressed: (index) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatBot(
                          prompt: "Tell me more about ${product['nutrients'][index]['name']}",
                        )),
              );
            },
          ),
          _buildExpandableSection(
            title: "Ingredients",
            items: product['ingredients'],
            onPressed: (index) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatBot(
                          prompt: "Tell me more about ${product['ingredients'][index]['name']}",
                        )),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthButton(BuildContext context, {required String text, required VoidCallback onPressed}) {
    return ListTile(
      leading: GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {},
    child: Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    ),));
  }

  Widget _buildExpandableSection({
    required String title,
    required List<Map<String, dynamic>> items,
    required Function(int) onPressed,
  }) {
    return ExpansionTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          for (int index = 0; index < items.length; index++)
            ListTile(
              leading: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {},
              child: Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => onPressed(index),
                child: ListTile(
                  leading: Container(
                    children: [
                    Text(
                      items[index]['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(items[index]['value'].toString()),
                  ],
                  )
              ),
            ),))
            )
        ],
      ),
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
