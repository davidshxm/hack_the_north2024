class InventoryManager {
  InventoryManager._privateConstructor();

  static final InventoryManager _instance = InventoryManager._privateConstructor();

  factory InventoryManager() {
    return _instance;
  }

  final List<String> _inventoryItems = ['Apple', 'Orange', 'Peach'];

  final Map<String, String> test = {'Apple': 'This is an apple', 'Orange': 'This is an orange', 'Peach': 'This is a Peach'};

  List<String> get inventoryItems => List.unmodifiable(_inventoryItems);

  void addItem(String item) {
    _inventoryItems.add(item);
    test['$item'] = 'This is a $item';
  }
}
