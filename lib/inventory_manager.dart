import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class InventoryManager {
  InventoryManager._privateConstructor() {
    String JSON = "{\"Family-Sized Classic Potato Chips\": {\"label\":\"Chips\",\"name\":\"Family-Sized Classic Potato Chips\",\"description\":\"A big bag of crispy, classic goodness for the whole family!\",\"nutrients\":[{\"name\":\"Calories\",\"description\":\"Energy content of the food.\",\"value\":120,\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Fibre\",\"description\":\"High fibre content aids digestion and promotes a healthy gut.\",\"value\":\"39 g\",\"measure\":\"high\",\"type\":\"healthy\"},{\"name\":\"Sugars\",\"description\":\"Moderate sugar content, but still a significant amount.\",\"value\":\"19 g\",\"measure\":\"moderate\",\"type\":\"unhealthy\"},{\"name\":\"Protein\",\"description\":\"Protein is essential for growth and repair of the body.\",\"value\":\"4 g\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Fat\",\"description\":\"High fat content may increase the risk of obesity and heart disease.\",\"value\":\"2.9 g\",\"measure\":\"low\",\"type\":\"unhealthy\"},{\"name\":\"Saturated\",\"description\":\"Saturated fats can raise bad cholesterol levels, increasing heart disease risk.\",\"value\":\"0.4 g\",\"measure\":\"low\",\"type\":\"unhealthy\"},{\"name\":\"Trans\",\"description\":\"The most unhealthy type of fat. Luckily, this product contains none.\",\"value\":\"0 g\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Cholesterol\",\"description\":\"High cholesterol content is unhealthy.\",\"value\":\"0 mg\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Sodium\",\"description\":\"High sodium content can lead to high blood pressure.\",\"value\":\"270 mg\",\"measure\":\"high\",\"type\":\"unhealthy\"},{\"name\":\"Carbohydrate\",\"description\":\"Carbohydrates provide energy, but excess can lead to weight gain.\",\"value\":\"22 g\",\"measure\":\"moderate\",\"type\":\"moderate\"},{\"name\":\"Vitamin A\",\"description\":\"Essential for vision, immune function, and cell growth.\",\"value\":\"11%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Vitamin C\",\"description\":\"A powerful antioxidant, supports immune function and collagen production.\",\"value\":\"2%\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Calcium\",\"description\":\"Vital for bone health, muscle function, and nerve signalling.\",\"value\":\"12%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Iron\",\"description\":\"Necessary for oxygen transport and energy production in cells.\",\"value\":\"12%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Vitamin D\",\"description\":\"Promotes calcium absorption and supports bone and immune health.\",\"value\":\"0%\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Thiamine\",\"description\":\"Thiamine, or vitamin B1, is crucial for energy metabolism and nerve function.\",\"value\":\"0%\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Riboflavin\",\"description\":\"Riboflavin, or vitamin B2, is essential for energy production and skin health.\",\"value\":\"30%\",\"measure\":\"high\",\"type\":\"healthy\"},{\"name\":\"Niacin\",\"description\":\"Niacin, or vitamin B3, supports energy metabolism and healthy skin.\",\"value\":\"4%\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Vitamin B6\",\"description\":\"Vitamin B6 is vital for brain function and the formation of red blood cells.\",\"value\":\"30%\",\"measure\":\"high\",\"type\":\"healthy\"},{\"name\":\"Folate\",\"description\":\"Folate is essential for cell growth and the prevention of neural tube defects.\",\"value\":\"25%\",\"measure\":\"high\",\"type\":\"healthy\"},{\"name\":\"Vitamin B12\",\"description\":\"Vitamin B12 is crucial for nerve function and the formation of red blood cells.\",\"value\":\"8%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Pantothenate\",\"description\":\"Pantothenic acid, or vitamin B5, is involved in energy metabolism and hormone production.\",\"value\":\"15%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Phosphorus\",\"description\":\"Phosphorus is essential for bone health and energy metabolism.\",\"value\":\"15%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Magnesium\",\"description\":\"Magnesium is vital for muscle and nerve function, and bone development.\",\"value\":\"10%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Zinc\",\"description\":\"Zinc is important for immune function, wound healing, and DNA synthesis.\",\"value\":\"15%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Carbohydrate Plus\",\"description\":\"This is a measure of total carbohydrates, including dietary fibre and sugars.\",\"value\":\"126 mg\",\"measure\":\"low\",\"type\":\"healthy\"}],\"ingredients\":[{\"name\":\"Whole grain oat\",\"description\":\"Rich in fibre, vitamins, and minerals. May help lower cholesterol and improve digestion.\",\"rating\":9},{\"name\":\"Modified corn starch\",\"description\":\"Highly processed. May cause digestive issues and blood sugar spikes.\",\"rating\":4},{\"name\":\"Corn starch\",\"description\":\"A common thickening agent, but may cause blood sugar spikes.\",\"rating\":6},{\"name\":\"Sugar\",\"description\":\"Consume in moderation to avoid weight gain and diabetes.\",\"rating\":5},{\"name\":\"Salt\",\"description\":\"Excessive intake increases the risk of high blood pressure and heart disease.\",\"rating\":5},{\"name\":\"Trisodium phosphate\",\"description\":\"Used as a preservative, but high in sodium.\",\"rating\":5},{\"name\":\"Calcium carbonate\",\"description\":\"A source of calcium, essential for bone health.\",\"rating\":8},{\"name\":\"Monoglycerides\",\"description\":\"May help extend shelf life, but can be highly processed.\",\"rating\":5},{\"name\":\"Tocopherols\",\"description\":\"A form of vitamin E, an antioxidant with anti-inflammatory properties.\",\"rating\":8},{\"name\":\"Wheat starch\",\"description\":\"May contain gluten, which can be problematic for some individuals.\",\"rating\":6},{\"name\":\"Annatto\",\"description\":\"A natural colouring, but may cause allergic reactions in some people.\",\"rating\":7},{\"name\":\"Niacinamide\",\"description\":\"Vitamin B3, essential for energy production and skin health.\",\"rating\":8},{\"name\":\"Calcium pantothenate\",\"description\":\"Vitamin B5, important for metabolism and nerve function.\",\"rating\":8},{\"name\":\"Pyridoxine hydrochloride (vitamin B6)\",\"description\":\"Helps in brain development and immune function.\",\"rating\":9},{\"name\":\"Folate\",\"description\":\"Essential for cell growth and development, especially during pregnancy.\",\"rating\":9},{\"name\":\"Iron\",\"description\":\"Crucial for oxygen transport and energy production.\",\"rating\":8}]}}";
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

    final List<String> _inventoryImages = [];
    List<String> get inventoryImages => List.unmodifiable(_inventoryImages);


  void removeItem(String item) {
    _inventoryMap.remove(item);
    _inventoryList.writeInventory(jsonEncode(_inventoryMap));
  }

  void addItem(String item, Map<String, dynamic> entry, String imagePath) {
    _inventoryMap[item] = entry;
        _inventoryImages.add(imagePath);

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

  String getItemLabelByIndex(int index) {
    if (index < 0 || index >= _inventoryMap.length) {
      return "";
    }
    return _inventoryMap[_inventoryMap.keys.toList()[index]]['label'];
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
    final directory = await getApplicationSupportDirectory();

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
