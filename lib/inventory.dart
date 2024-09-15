import 'dart:io';
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
      'assets/GameBoy-Transparent.png',
      'assets/Card-Transparent.png',
      'assets/Tamagotchi-Transparent.png',
    ];
    return images[index % images.length];
  }

  Color _getColor(int rating) {
    if (rating >= 7) {
      return Colors.green[100]!;
    } else if (rating >= 5) {
      return Colors.yellow[100]!;
    } else if (rating >= 3) {
      return Colors.orange[100]!;
    } else {
      return Colors.red[100]!;
    }
  }

  int _getRating(String measure, String type) {
    int iMeasure = measure == "high" ? 3 : measure == "moderate" ? 2 : 1;
    int iType = type == "unhealthy" ? 1 : type == "moderate" ? 5 : 9;
    return iType;
  }

  String _getWarning(String measure, String type) {
    int iMeasure = measure == "high" ? 3 : measure == "moderate" ? 2 : 1;
    int iType = type == "unhealthy" ? 3 : type == "moderate" ? 2 : 1;
    switch (iMeasure + iType) {
      case 2:
        return "More recommended";
      case 6:
        return "Excessive consumption";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> product = _inventoryManager
        .getEntryByName(_inventoryManager.getItemNameByIndex(Index));

    return Scaffold(
      appBar: AppBar(
        title: Text("SlidingUpPanelExample"),
      ),
      body: SlidingUpPanel(
        controller: _pc,
        backdropEnabled: true,
        // For a backdrop when the panel is opened
        renderPanelSheet: true,
        maxHeight: MediaQuery.of(context).size.height,
        // Full screen height
        minHeight: 0,
        // Hide the panel when collapsed
        panel: Center(
          child: Column(
            children: [
              // Product name button
              Container(
                child: Text(product['name'] ?? ""),
              ),
              // Product description button
              Container(
                child: Text(product['description'] ?? ""),
              ),
              if (product['nutrients'] != null &&
                  product['nutrients'].isNotEmpty)
                  DropdownButton<String>(
                    hint: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('Select a Nutrient')),
                    value: selectedNutrient,
                    isExpanded: true,
                    itemHeight: 140,
                    items: product['nutrients']
                        .map<DropdownMenuItem<String>>((nutrient) {
                      String name = nutrient['name'];
                      String value = nutrient['value'].toString();
                      String measure = nutrient['measure'];
                      String type = nutrient['type'];
                      String description = nutrient['description'];
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Container(
                                height: 140,
                                color: _getColor(_getRating(measure, type)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(name,
                                              style: TextStyle(fontWeight: FontWeight.bold)),
                                        Text(value,
                                              style: TextStyle(fontWeight: FontWeight.bold)), 
                                        
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Text(description),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(_getWarning(measure, type),
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          if (_getWarning(measure, type) != "")
                                            SizedBox(width: 10),
                                            if (_getWarning(measure, type) == "More recommended")
                                              Icon(Icons.thumb_up, color: Colors.green)
                                            else if (_getWarning(measure, type) == "Excessive consumption")
                                              Icon(Icons.warning, color: Colors.red)
                                        ],
                                      ),
                                    ),
                                  ],
                              ),))
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedNutrient = newValue;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatBot(prompt: "Tell me more about $newValue"),
                          ),
                        );
                      });
                    },
                ),
              // Dropdown to select nutrients with name and value side by side
              if (product['ingredients'] != null &&
                  product['ingredients'].isNotEmpty)
                  SingleChildScrollView(
                      child: DropdownButton<String>(
                          hint: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Select a Ingredients')),
                          value: selectedNutrient,
                          isExpanded: true,
                          itemHeight: 140,
                          items: product['ingredients']
                              .map<DropdownMenuItem<String>>((nutrient) {
                            String name = nutrient['name'];
                            String description = nutrient['description'];
                            String rating = nutrient['rating'].toString();
                            return DropdownMenuItem<String>(
                              value: name,
                              child: Container(
                                height: 140,
                                color: _getColor(int.parse(rating)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Text(name,
                                              style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Image.asset("assets/" + rating + "0PercentBar.png",
                                            width: 100,
                                            height: 20,
                                          ),)
                                      ],
                                    ),
                                    
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Text(description),
                                    ),
                                  ],
                              ),))
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedNutrient = newValue;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatBot(prompt: "Tell me more about $newValue"),
                                ),
                              );
                            });
                          },)
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
              if (_inventoryManager.inventoryImages.length > index &&
                  _inventoryManager.inventoryImages[index].isNotEmpty)
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Image.file(
                    File(_inventoryManager.inventoryImages[index]),
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),

              // IconButton for the original icon background (gameboy, card, etc.)
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
                      fontSize: 13,
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
