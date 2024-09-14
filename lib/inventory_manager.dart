class InventoryManager {
  InventoryManager._privateConstructor();

  static final InventoryManager _instance = InventoryManager._privateConstructor();

  factory InventoryManager() {
    return _instance;
  }

  final List<String> _inventoryItems = ['Apple', 'Orange', 'Peach'];
  final List<String> _inventoryImages = [];

  final Map<String, String> test = {'Apple': 'This is an apple', 'Orange': 'This is an orange', 'Peach': 'This is a Peach'};

  List<String> get inventoryItems => List.unmodifiable(_inventoryItems);
  List<String> get inventoryImages => List.unmodifiable(_inventoryImages);


  void addItem(String item, String imagePath) {
    _inventoryItems.add(item);
    _inventoryImages.add(imagePath);
    test['$item'] = 'This is a $item';
  }
}
