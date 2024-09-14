import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Inventory extends StatefulWidget {
  Inventory({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InventoryPage();
}

class _InventoryPage extends State<Inventory> {
  PanelController _pc = new PanelController();
  bool _isPanelVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SlidingUpPanelExample"),
      ),
      body: SlidingUpPanel(
        renderPanelSheet: _isPanelVisible,
        backdropEnabled: true,
        controller: _pc,
        panel: Center(
          child: Text("This is the sliding Widget"),
        ),
        body: _body(),
        onPanelOpened: () {
          setState(() {
            _isPanelVisible = true;  // Set to true when the panel is opened
          });
        },
        onPanelClosed: () {
          setState(() {
            _isPanelVisible = false;  // Set to false when the panel is closed
          });
        },
      ),
    );
  }

  Widget _body() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(children: [
            ElevatedButton(
              onPressed: () => _pc.open(),
              child: Text("Open"),
            ),
          ]),
        ],
      ),
    );
  }
}
