import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class InventoryManager {
  InventoryManager._privateConstructor() {
    String JSON = "{}";
    _inventoryList.readInventory().then((value) => (JSON = value));
    _inventoryMap.addAll(jsonDecode(JSON));
  }

  static final InventoryManager _instance =
      InventoryManager._privateConstructor();

  static final InventoryStorage _inventoryList = InventoryStorage();

  final Map<String, dynamic> _inventoryMap = {};

  factory InventoryManager() {
    return _instance;
  }

  void addItem(String item, Map<String, dynamic> entry) {
    _inventoryMap[item] = entry;
    _inventoryList.writeInventory(jsonEncode(_inventoryMap));
  }

  int getItemCount() {
    return _inventoryMap.length;
  }

  String getItemNameByIndex(int index) {
    if (index < 0 || index >= _inventoryMap.length) {
      return "";
    }
    return _inventoryMap.keys.toList()[index];
  }

  Map<String, dynamic> getEntryByName(String name) {
    if (!_inventoryMap.containsKey(name)) {
      return {};
    }
    return _inventoryMap[name];
  }
}

// Adapted from Flutter documentation
class InventoryStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/inventoryItems.json');
  }

  Future<String> readInventory() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return error
      return "error";
    }
  }

  Future<File> writeInventory(String JSON) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(JSON);
  }
}
