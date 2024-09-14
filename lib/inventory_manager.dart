class InventoryManager {
  InventoryManager._privateConstructor();

  static final InventoryManager _instance = InventoryManager._privateConstructor();

  factory InventoryManager() {
    return _instance;
  }

  final List<String> _inventoryItems = ['Apple', 'Orange', 'Peach'];

  List<String> get inventoryItems => List.unmodifiable(_inventoryItems);

  void addItem(String item) {
    _inventoryItems.add(item);
  }
}
