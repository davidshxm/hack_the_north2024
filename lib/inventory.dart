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
  int Index = 0;
  String? selectedNutrient;

  @override
  void initState() {
    super.initState();
  }

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
    Map<String, dynamic> product =
    _inventoryManager.getEntryByName(_inventoryManager.getItemNameByIndex(Index));

    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory"),
        backgroundColor: Colors.green,
      ),
      body: SlidingUpPanel(
        controller: _pc,
        backdropEnabled: true, // For a backdrop when the panel is opened
        renderPanelSheet: true,
        maxHeight: MediaQuery.of(context).size.height, // Full screen height
        minHeight: 0, // Hide the panel when collapsed
        panel: Center(
          child: Column(
            children: [
              // Product name button
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => ChatBot()));
                  },
                  child: Text(product['name'] ?? ""),
                ),
              ),

              // Product description button
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => ChatBot()));
                  },
                  child: Text(product['description'] ?? ""),
                ),
              ),
              if (product['nutrients'] != null && product['nutrients'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    hint: Text('Select a Nutrient'),
                    value: selectedNutrient,
                    isExpanded: true,
                    items: product['nutrients'].map<DropdownMenuItem<String>>((nutrient) {
                      String name = nutrient['name'];
                      String value = nutrient['value'].toString();
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedNutrient = newValue;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatBot(prompt: "Tell me more about $newValue"),
                          ),
                        );
                      });
                    },
                  ),
                ),
              // Dropdown to select nutrients with name and value side by side
              if (product['ingredients'] != null && product['ingredients'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    hint: Text('Select an Ingredient'),
                    value: selectedNutrient,
                    isExpanded: true,
                    items: product['ingredients'].map<DropdownMenuItem<String>>((nutrient) {
                      String name = nutrient['name'];
                      String description = nutrient['description'];
                      String rating = nutrient['rating'].toString();
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(description),
                            Text(rating)
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedNutrient = newValue;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatBot(prompt: "Tell me more about $newValue"),
                          ),
                        );
                      });
                    },
                  ),
                ),
                ],
              ),
              Column(
                children: [
                  if(!isNull)
                  for (int index = 0; index < product['ingredients'].length; index++)
                  Container(
                    width: double.infinity,
                      height: 50,
                      child: 
                  
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => ChatBot(prompt: "Tell me more about ${product['ingredients'][index]['name']}")));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                        children: [
                          Text(product['ingredients'][index]['name'],
                            style: TextStyle(fontWeight: FontWeight.bold), // Ingredient name
                          ),
                          SizedBox(height: 5), // Space between lines
                          Text(product['ingredients'][index]['value'].toString(), // Ingredient description
                          ),
                        ],
                      ),
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
            _isPanelVisible = true;
          });
        },
        onPanelClosed: () {
          setState(() {
            _isPanelVisible = false;
          });
        },
      ),
      floatingActionButton: _isPanelVisible
          ? null
          : FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Camera(),
            ),
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
                                return _buildEmptyItem();
                              }
                            }),
                          ),
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
              Positioned(
                bottom: 22,
                child: Text(
                  _inventoryManager.getItemLabelByIndex(index),
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PixelifySans'),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyItem() {
    return Expanded(
      child: Container(
        width: 100,
        height: 100,
      ),
    );
  }
}
