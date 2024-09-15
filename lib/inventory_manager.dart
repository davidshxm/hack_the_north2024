import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:convert';
import 'image_preview.dart';

class InventoryManager {
  InventoryManager._privateConstructor() {
    List<String> JSON = [
    "{\"Family-Sized Classic Potato Chips\": {\"label\":\"Chips\",\"name\":\"Family-Sized Classic Potato Chips\",\"description\":\"A big bag of crispy, classic goodness for the whole family!\",\"nutrients\":[{\"name\":\"Calories\",\"description\":\"Energy content of the food.\",\"value\":120,\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Fibre\",\"description\":\"High fibre content aids digestion and promotes a healthy gut.\",\"value\":\"39 g\",\"measure\":\"high\",\"type\":\"healthy\"},{\"name\":\"Sugars\",\"description\":\"Moderate sugar content, but still a significant amount.\",\"value\":\"19 g\",\"measure\":\"moderate\",\"type\":\"unhealthy\"},{\"name\":\"Protein\",\"description\":\"Protein is essential for growth and repair of the body.\",\"value\":\"4 g\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Fat\",\"description\":\"High fat content may increase the risk of obesity and heart disease.\",\"value\":\"2.9 g\",\"measure\":\"low\",\"type\":\"unhealthy\"},{\"name\":\"Saturated\",\"description\":\"Saturated fats can raise bad cholesterol levels, increasing heart disease risk.\",\"value\":\"0.4 g\",\"measure\":\"low\",\"type\":\"unhealthy\"},{\"name\":\"Trans\",\"description\":\"The most unhealthy type of fat. Luckily, this product contains none.\",\"value\":\"0 g\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Cholesterol\",\"description\":\"High cholesterol content is unhealthy.\",\"value\":\"0 mg\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Sodium\",\"description\":\"High sodium content can lead to high blood pressure.\",\"value\":\"270 mg\",\"measure\":\"high\",\"type\":\"unhealthy\"},{\"name\":\"Carbohydrate\",\"description\":\"Carbohydrates provide energy, but excess can lead to weight gain.\",\"value\":\"22 g\",\"measure\":\"moderate\",\"type\":\"moderate\"},{\"name\":\"Vitamin A\",\"description\":\"Essential for vision, immune function, and cell growth.\",\"value\":\"11%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Vitamin C\",\"description\":\"A powerful antioxidant, supports immune function and collagen production.\",\"value\":\"2%\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Calcium\",\"description\":\"Vital for bone health, muscle function, and nerve signalling.\",\"value\":\"12%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Iron\",\"description\":\"Necessary for oxygen transport and energy production in cells.\",\"value\":\"12%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Vitamin D\",\"description\":\"Promotes calcium absorption and supports bone and immune health.\",\"value\":\"0%\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Thiamine\",\"description\":\"Thiamine, or vitamin B1, is crucial for energy metabolism and nerve function.\",\"value\":\"0%\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Riboflavin\",\"description\":\"Riboflavin, or vitamin B2, is essential for energy production and skin health.\",\"value\":\"30%\",\"measure\":\"high\",\"type\":\"healthy\"},{\"name\":\"Niacin\",\"description\":\"Niacin, or vitamin B3, supports energy metabolism and healthy skin.\",\"value\":\"4%\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Vitamin B6\",\"description\":\"Vitamin B6 is vital for brain function and the formation of red blood cells.\",\"value\":\"30%\",\"measure\":\"high\",\"type\":\"healthy\"},{\"name\":\"Folate\",\"description\":\"Folate is essential for cell growth and the prevention of neural tube defects.\",\"value\":\"25%\",\"measure\":\"high\",\"type\":\"healthy\"},{\"name\":\"Vitamin B12\",\"description\":\"Vitamin B12 is crucial for nerve function and the formation of red blood cells.\",\"value\":\"8%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Pantothenate\",\"description\":\"Pantothenic acid, or vitamin B5, is involved in energy metabolism and hormone production.\",\"value\":\"15%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Phosphorus\",\"description\":\"Phosphorus is essential for bone health and energy metabolism.\",\"value\":\"15%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Magnesium\",\"description\":\"Magnesium is vital for muscle and nerve function, and bone development.\",\"value\":\"10%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Zinc\",\"description\":\"Zinc is important for immune function, wound healing, and DNA synthesis.\",\"value\":\"15%\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Carbohydrate Plus\",\"description\":\"This is a measure of total carbohydrates, including dietary fibre and sugars.\",\"value\":\"126 mg\",\"measure\":\"low\",\"type\":\"healthy\"}],\"ingredients\":[{\"name\":\"Whole grain oat\",\"description\":\"Rich in fibre, vitamins, and minerals. May help lower cholesterol and improve digestion.\",\"rating\":9},{\"name\":\"Modified corn starch\",\"description\":\"Highly processed. May cause digestive issues and blood sugar spikes.\",\"rating\":4},{\"name\":\"Corn starch\",\"description\":\"A common thickening agent, but may cause blood sugar spikes.\",\"rating\":6},{\"name\":\"Sugar\",\"description\":\"Consume in moderation to avoid weight gain and diabetes.\",\"rating\":5},{\"name\":\"Salt\",\"description\":\"Excessive intake increases the risk of high blood pressure and heart disease.\",\"rating\":5},{\"name\":\"Trisodium phosphate\",\"description\":\"Used as a preservative, but high in sodium.\",\"rating\":5},{\"name\":\"Calcium carbonate\",\"description\":\"A source of calcium, essential for bone health.\",\"rating\":8},{\"name\":\"Monoglycerides\",\"description\":\"May help extend shelf life, but can be highly processed.\",\"rating\":5},{\"name\":\"Tocopherols\",\"description\":\"A form of vitamin E, an antioxidant with anti-inflammatory properties.\",\"rating\":8},{\"name\":\"Wheat starch\",\"description\":\"May contain gluten, which can be problematic for some individuals.\",\"rating\":6},{\"name\":\"Annatto\",\"description\":\"A natural colouring, but may cause allergic reactions in some people.\",\"rating\":7},{\"name\":\"Niacinamide\",\"description\":\"Vitamin B3, essential for energy production and skin health.\",\"rating\":8},{\"name\":\"Calcium pantothenate\",\"description\":\"Vitamin B5, important for metabolism and nerve function.\",\"rating\":8},{\"name\":\"Pyridoxine hydrochloride (vitamin B6)\",\"description\":\"Helps in brain development and immune function.\",\"rating\":9},{\"name\":\"Folate\",\"description\":\"Essential for cell growth and development, especially during pregnancy.\",\"rating\":9},{\"name\":\"Iron\",\"description\":\"Crucial for oxygen transport and energy production.\",\"rating\":8}]}}",
    "{\"Monster Energy\": {\"label\":\"Energy\",\"name\":\"Monster Energy\",\"description\":\"A mysterious product with a code name, ready to be decoded!\",\"imagePath\":\"\/data\/user\/0\/com.example.hack_the_north2024\/cache\/b5977dc9-abeb-40d9-916f-a78637413e81595674107578064579.jpg\",\"nutrients\":[{\"name\":\"Calories\",\"description\":\"Provides energy for daily activities.\",\"value\":210,\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Fat\",\"description\":\"Minimal fat content, promoting heart health.\",\"value\":\"0 g\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Sodium\",\"description\":\"High sodium levels may increase blood pressure.\",\"value\":\"370 mg\",\"measure\":\"high\",\"type\":\"unhealthy\"},{\"name\":\"Carbohydrates\",\"description\":\"Carbohydrates provide energy, but excess may impact blood sugar.\",\"value\":\"55 g\",\"measure\":\"high\",\"type\":\"moderate\"},{\"name\":\"Sugars\",\"description\":\"Elevated sugar content, potentially impacting dental health.\",\"value\":\"54 g\",\"measure\":\"high\",\"type\":\"unhealthy\"},{\"name\":\"Protein\",\"description\":\"Protein is essential for muscle repair and growth.\",\"value\":\"0 g\",\"measure\":\"low\",\"type\":\"moderate\"},{\"name\":\"Riboflavin\",\"description\":\"Riboflavin supports energy production and healthy vision.\",\"value\":\"15 %\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Niacin\",\"description\":\"Niacin aids in metabolism and supports skin health.\",\"value\":\"210 %\",\"measure\":\"high\",\"type\":\"healthy\"},{\"name\":\"Vitamin B6\",\"description\":\"Vitamin B6 is crucial for brain function and immune health.\",\"value\":\"220 %\",\"measure\":\"high\",\"type\":\"healthy\"},{\"name\":\"Vitamin B12\",\"description\":\"Vitamin B12 is essential for nerve function and DNA synthesis.\",\"value\":\"590 %\",\"measure\":\"high\",\"type\":\"healthy\"},{\"name\":\"Caffeine\",\"description\":\"Caffeine provides a temporary energy boost but may cause jitters.\",\"value\":\"166 mg\",\"measure\":\"high\",\"type\":\"moderate\"},{\"name\":\"Sucralose\",\"description\":\"Artificial sweetener with no calories, but may impact gut health.\",\"value\":\"20 mg\",\"measure\":\"moderate\",\"type\":\"moderate\"},{\"name\":\"Onolactone\",\"description\":\"Onolactone is a compound with potential health benefits.\",\"value\":\"10 mg\",\"measure\":\"moderate\",\"type\":\"healthy\"},{\"name\":\"Bassin Extract\",\"description\":\"Bassin extract, a natural ingredient, may have health benefits.\",\"value\":\"500 mg\",\"measure\":\"high\",\"type\":\"healthy\"}],\"ingredients\":[{\"name\":\"Carbonated water\",\"description\":\"Carbonated water is a common ingredient, often used as a base for beverages.\",\"rating\":8},{\"name\":\"Sugar\",\"description\":\"Consume sugars in moderation to avoid weight gain and dental issues.\",\"rating\":5},{\"name\":\"Glucose\",\"description\":\"Glucose is a simple sugar, quickly absorbed by the body.\",\"rating\":5},{\"name\":\"Citric acid\",\"description\":\"May help prevent kidney stones and support immune function.\",\"rating\":7},{\"name\":\"Flavours\",\"description\":\"Natural flavours are preferred, as artificial ones may have hidden risks.\",\"rating\":6},{\"name\":\"Taurine\",\"description\":\"An amino acid that may improve athletic performance and heart health.\",\"rating\":8},{\"name\":\"Sodium citrate\",\"description\":\"High in sodium, may increase blood pressure if consumed excessively.\",\"rating\":5},{\"name\":\"Grape skin extract\",\"description\":\"Contains antioxidants, particularly resveratrol, which may have heart benefits.\",\"rating\":9},{\"name\":\"Panax ginseng flavour\",\"description\":\"May boost energy and cognitive function, but can interact with medications.\",\"rating\":7},{\"name\":\"Caffeine\",\"description\":\"Stimulant that can improve focus but may cause jitters and sleep issues.\",\"rating\":6},{\"name\":\"Sorbic acid\",\"description\":\"Preservative that may cause allergic reactions in some individuals.\",\"rating\":4},{\"name\":\"Benzoic acid\",\"description\":\"Preservative that can be naturally derived, but may cause allergies.\",\"rating\":4},{\"name\":\"Niacinamide (Vitamin B3)\",\"description\":\"Important for energy metabolism and skin health.\",\"rating\":8},{\"name\":\"Salt\",\"description\":\"Excessive intake increases the risk of high blood pressure.\",\"rating\":5},{\"name\":\"D-Glucuronolactone\",\"description\":\"Naturally occurring compound, but its effects are not well studied.\",\"rating\":5},{\"name\":\"Guarana seed extract\",\"description\":\"Contains caffeine and antioxidants, may boost energy and metabolism.\",\"rating\":7},{\"name\":\"Inositol\",\"description\":\"May help with anxiety and depression, but more research is needed.\",\"rating\":6},{\"name\":\"Pyridoxine hydrochloride (Vitamin B6)\",\"description\":\"Essential for brain function and metabolism.\",\"rating\":8},{\"name\":\"Sucralose\",\"description\":\"Artificial sweetener, may be a better option for diabetics.\",\"rating\":6},{\"name\":\"Riboflavin (Vitamin B2)\",\"description\":\"Important for energy production and eye health.\",\"rating\":8},{\"name\":\"Maltodextrin\",\"description\":\"Highly processed, often used as a filler or thickener.\",\"rating\":3},{\"name\":\"Cyanocobalamin (Vitamin B12)\",\"description\":\"Vital for nerve function and DNA synthesis.\",\"rating\":9}]}}",
    "{\"Coca-Cola\": {\"label\":\"Drink\",\"name\":\"Coca-Cola\",\"description\":\"A refreshing sip of deliciousness, a taste to savour.\",\"imagePath\":\"\/data\/user\/0\/com.example.hack_the_north2024\/cache\/ec78bfdc-01cc-4571-ae26-5fa376e6f9245922340158272114301.jpg\",\"nutrients\":[{\"name\":\"Calories\",\"description\":\"Energy content of the food.\",\"value\":140,\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Fat\",\"description\":\"This product contains no fat.\",\"value\":\"0 g\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Carbohydrates\",\"description\":\"High carbohydrate content may increase blood sugar levels.\",\"value\":\"39 g\",\"measure\":\"high\",\"type\":\"unhealthy\"},{\"name\":\"Sugars\",\"description\":\"High sugar content may increase the risk of diabetes.\",\"value\":\"39 g\",\"measure\":\"high\",\"type\":\"unhealthy\"},{\"name\":\"Protein\",\"description\":\"Protein is essential for muscle growth and repair.\",\"value\":\"0 g\",\"measure\":\"low\",\"type\":\"moderate\"},{\"name\":\"Sodium\",\"description\":\"Low sodium content is healthy.\",\"value\":\"25 mg\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Potassium\",\"description\":\"Potassium is essential for nerve and muscle function.\",\"value\":\"10 mg\",\"measure\":\"low\",\"type\":\"healthy\"}],\"ingredients\":[{\"name\":\"Carbonated water\",\"description\":\"A good alternative to sugary drinks, but excessive intake may reduce bone density.\",\"rating\":7},{\"name\":\"Sugar\/glucose-fructose\",\"description\":\"Consume sugars in moderation to avoid weight gain and diabetes.\",\"rating\":5},{\"name\":\"Caramel colour\",\"description\":\"May contain 4-Methylimidazole (4-MEI), a potential carcinogen.\",\"rating\":4},{\"name\":\"Phosphoric acid\",\"description\":\"May contribute to tooth erosion and bone density loss.\",\"rating\":4},{\"name\":\"Natural flavour\",\"description\":\"May contain hidden allergens and natural chemicals with health risks.\",\"rating\":6},{\"name\":\"Caffeine\",\"description\":\"Stimulant that may improve focus but can cause anxiety and sleep issues.\",\"rating\":6}]}}"
    "{\"Cheetos\": {\"label\":\"Cheese\",\"name\":\"Cheetos\",\"description\":\"A cheesy delight, sealed with a promise of authenticity.\",\"imagePath\":\"\/data\/user\/0\/com.example.hack_the_north2024\/cache\/0fc3b4ea-4fc7-463c-ae45-8ae35ecb59471738532077936826555.jpg\",\"nutrients\":[{\"name\":\"Calories\",\"description\":\"Provides energy for daily activities.\",\"value\":160,\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Fat\",\"description\":\"Moderate fat content, but may increase heart disease risk.\",\"value\":\"10 g\",\"measure\":\"moderate\",\"type\":\"unhealthy\"},{\"name\":\"Saturated\",\"description\":\"Low saturated fat is beneficial for heart health.\",\"value\":\"1.5 g\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Trans\",\"description\":\"No trans fat is ideal for a healthy diet.\",\"value\":\"0.1 g\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Carbohydrates\",\"description\":\"Carbs provide energy, but high intake may impact blood sugar.\",\"value\":\"15 g\",\"measure\":\"moderate\",\"type\":\"moderate\"},{\"name\":\"Fibre\",\"description\":\"Fibre aids digestion and supports a healthy gut.\",\"value\":\"1 g\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Sugars\",\"description\":\"Low sugar content is beneficial for overall health.\",\"value\":\"2 g\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Protein\",\"description\":\"Essential for muscle repair and growth.\",\"value\":\"2 g\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Sodium\",\"description\":\"Moderate sodium intake is recommended for blood pressure control.\",\"value\":\"250 mg\",\"measure\":\"moderate\",\"type\":\"moderate\"},{\"name\":\"Potassium\",\"description\":\"Potassium supports nerve and muscle function.\",\"value\":\"50 mg\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Calcium\",\"description\":\"Important for bone health and muscle function.\",\"value\":\"20 mg\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Iron\",\"description\":\"Iron is essential for oxygen transport in the blood.\",\"value\":\"0.75 mg\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Cholesterol\",\"description\":\"No cholesterol is ideal for heart health.\",\"value\":\"0 mg\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Thiamine\",\"description\":\"Thiamine supports energy metabolism and nerve function.\",\"value\":\"0.1 mg\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Riboflavin\",\"description\":\"Riboflavin is vital for energy production and growth.\",\"value\":\"0.1 mg\",\"measure\":\"low\",\"type\":\"healthy\"},{\"name\":\"Niacin\",\"description\":\"Niacin supports healthy skin and nervous system function.\",\"value\":\"1 mg\",\"measure\":\"low\",\"type\":\"healthy\"}],\"ingredients\":[{\"name\":\"Enriched cornmeal\",\"description\":\"Fortified with vitamins and minerals, but may be highly processed.\",\"rating\":6},{\"name\":\"Cornmeal\",\"description\":\"A good source of complex carbohydrates and fibre.\",\"rating\":7},{\"name\":\"Niacin\",\"description\":\"Vitamin B3, essential for energy metabolism and skin health.\",\"rating\":8},{\"name\":\"Iron\",\"description\":\"Crucial for oxygen transport and energy production.\",\"rating\":9},{\"name\":\"Thiamine mononitrate\",\"description\":\"Vitamin B1, vital for nerve function and carbohydrate metabolism.\",\"rating\":8},{\"name\":\"Riboflavin\",\"description\":\"Vitamin B2, supports energy production and healthy vision.\",\"rating\":8},{\"name\":\"Folic acid\",\"description\":\"A B vitamin essential for DNA synthesis and pregnancy health.\",\"rating\":8},{\"name\":\"Vegetable oil\",\"description\":\"Highly processed, may raise inflammation and contain unhealthy fats.\",\"rating\":4},{\"name\":\"Seasoning\",\"description\":\"Contains dairy, artificial flavours, and high sodium content.\",\"rating\":4},{\"name\":\"Modified milk ingredients\",\"description\":\"Processed dairy, may cause issues for lactose-intolerant individuals.\",\"rating\":5},{\"name\":\"Cheddar cheese\",\"description\":\"A good source of calcium and protein, but high in saturated fat.\",\"rating\":6},{\"name\":\"Maltodextrin\",\"description\":\"Highly processed. Dangerous for diabetics and those with gluten allergies.\",\"rating\":3},{\"name\":\"Salt\",\"description\":\"Excessive intake increases the risk of high blood pressure and heart disease.\",\"rating\":5},{\"name\":\"Monosodium glutamate\",\"description\":\"May cause headaches and other side effects in sensitive individuals.\",\"rating\":3},{\"name\":\"Lactic acid\",\"description\":\"May help improve gut health and digestion.\",\"rating\":7},{\"name\":\"Citric acid\",\"description\":\"May help prevent kidney stones and improve iron absorption.\",\"rating\":7},{\"name\":\"Sunset yellow FCF\",\"description\":\"May cause allergic reactions and hyperactivity, especially in children.\",\"rating\":1},{\"name\":\"Natural and artificial flavour\",\"description\":\"May contain hidden allergens and harmful chemicals.\",\"rating\":4}]}}"
    ];
    //_inventoryList.readInventory().then((value) => (JSON = value));
    for (var JSON in JSON) _inventoryMap.addAll(jsonDecode(JSON));
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
