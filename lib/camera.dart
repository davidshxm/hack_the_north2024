import 'package:flutter/material.dart';
import 'inventory.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'image_preview.dart';
import 'inventory_manager.dart';
import 'byte.dart';
import 'dart:convert'; // For decoding JSON
import 'package:http/http.dart' as http;
import 'dart:developer';

Future<Meta> createMeta(String payload) async {
  final response = await http.post(
    Uri.parse('https://htn2024-backend-uftm.vercel.app/api/meta'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'payload': payload,
    }),
  );

  if (response.statusCode == 200) {
    //return Meta.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return Meta.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create product');
  }
}



Future<List<Nutrient>> createPopulatedNutrients(String payload) async {
  final response = await http.post(
    Uri.parse('http://10.37.100.33:3000/api/populate-nutrients'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'payload': payload,
    }),
  );

  if (response.statusCode == 200) {
    return List<Nutrient>.from(
        jsonDecode(jsonDecode(response.body)['response']['text'])
            .map((x) => Nutrient.fromJson(x)));
  } else {
    throw Exception('Failed to create product');
  }
}

Future<List<Ingredient>> createPopulatedIngredients(String payload) async {
  final response = await http.post(
    Uri.parse('http://10.37.100.33:3000/api/populate-ingredients'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'payload': payload,
    }),
  );

  if (response.statusCode == 200) {
    return List<Ingredient>.from(
        jsonDecode(jsonDecode(response.body)['response']['text'])
            .map((x) => Ingredient.fromJson(x)));
  } else {
    throw Exception('Failed to create product');
  }
}

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late TextRecognizer textRecognizer;
  late ImagePicker imagePicker;
  Meta meta = Meta(label: "", name: "", description: "");
  Product product = Product(
      label: "",
      name: "",
      description: "",
      imagePath: "",
      nutrients: [],
      ingredients: []);
  String recognizedText = "";
  String recognizedNutrientText = "";
  String recognizedIngredientText = "";

  List<String?> pickedImagePaths =
      List.filled(3, null); // Store images for each step
  List<bool> stepsCompleted = [
    false,
    false,
    false
  ]; // Tracks whether each step is done or skipped
  bool processing = false;
  bool isRecognizing = false;
  int currentStep =
      0; // Track the current step (0: Nutritional label, 1: Ingredients, 2: Product picture)

  @override
  void initState() {
    super.initState();
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    imagePicker = ImagePicker();
  }

  void _pickImageAndProcess({required ImageSource source}) async {
    final pickedImage = await imagePicker.pickImage(source: source);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      pickedImagePaths[currentStep] = pickedImage.path;
      stepsCompleted[currentStep] = true;
      isRecognizing = true;
    });

    try {
      final inputImage = InputImage.fromFilePath(pickedImage.path);
      final RecognizedText recognisedText =
          await textRecognizer.processImage(inputImage);

      recognizedText = "";
      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          recognizedText += "${line.text}\n";
        }
      }

      switch (currentStep) {
        case 0:
          Meta m = await createMeta(recognizedText);
          setState(() {
            meta = m;
          });
          break;
        case 1:
          setState(() {
            recognizedNutrientText = recognizedText;
          });
          break;
        case 2:
          setState(() {
            processing = true;
          });
          print("going");
          final results = await Future.wait([
            createPopulatedNutrients(recognizedNutrientText),
            createPopulatedIngredients(recognizedText)
          ]);
          setState(() {
            processing = false;
          });
          print("done");
          Product p = Product(
              label: meta.label,
              name: meta.name,
              imagePath: pickedImage.path,
              description: meta.description,
              nutrients: results[0] as List<Nutrient>,
              ingredients: results[1] as List<Ingredient>);
          log(jsonEncode(p.toJson()));
          setState(() {
            product = p;
          });
          break;
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error recognizing text: $e')),
      );
    } finally {
      setState(() {
        isRecognizing = false;
      });
    }
  }

  void _skipCurrentStep() {
    setState(() {
      stepsCompleted[currentStep] = true; // Mark step as completed (skipped)
      if (currentStep < 2) {
        currentStep++;
      }
    });
  }

  bool get isAllStepsCompleted => stepsCompleted.every((step) => step);

  void _goToInventory(data) async {
    // Show popup to enter product name
    final productName = await showDialog<String>(
      context: context,
      builder: (context) {
        String name = product.name;
        return AlertDialog(
          title: const Text('Enter Product Name'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: product.name),
            onChanged: (value) => name = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, name),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
    print(productName);
    // Add new item to inventory and navigate to Inventory page
    if (productName != null && productName.isNotEmpty) {
      final inventoryManager = InventoryManager();
      String? imagePath = pickedImagePaths[0];
      if (imagePath != null) {
        inventoryManager.addItem(productName, data.toJson(), imagePath);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Inventory()),
      );
    }
  }

  void _chooseImageSourceModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageAndProcess(source: ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a picture'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageAndProcess(source: ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Mainly for testing purposes rn, can remove later
  void _copyTextToClipboard() async {
    if (recognizedText.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: recognizedText));
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Text copied to clipboard')),
      );
    }
  }

  String _getStepDescription(int step) {
    switch (step) {
      case 0:
        return "Step 1: Capture a photo of the product. This image will be used to identify and verify the product.";
      case 1:
        return "Step 2: Capture the Nutritional Label of the product. This label provides information about the nutrients present in the product.";
      case 2:
        return "Step 3: Capture the Ingredients List of the product. This list shows the components used in the product.";
      default:
        return "";
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ML Text Recognition'),
      ),
      body: SafeArea(
        child: Center(
          child: Stack(alignment: Alignment.topCenter, children: [
            Positioned.fill(
                child:
                    Image.asset("assets/UploadScreen.png", fit: BoxFit.fill)),
            Positioned(
              width: 250,
              top: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (pickedImagePaths[currentStep] != null)
                    if (processing)
                      const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange), // Custom color
                          strokeWidth: 5.0, // Adjust thickness
                        ),
                      )
                    else
                      ImagePreview(imagePath: pickedImagePaths[currentStep]!),
                  // Display current step
                  if (pickedImagePaths[currentStep] == null)
                    Column(
                      children: [
                        Text(
                          'Step ${currentStep + 1} of 3',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: (currentStep + 1) / 3,
                          minHeight: 5,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _getStepDescription(currentStep),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  // if (!isRecognizing && recognizedText.isNotEmpty) ...[
                  //   const Divider(),
                  //   Padding(
                  //     padding: const EdgeInsets.only(
                  //         left: 16, right: 16, bottom: 16),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         const Text(
                  //           "Recognized Text",
                  //           style: TextStyle(fontWeight: FontWeight.bold),
                  //         ),
                  //         IconButton(
                  //           icon: const Icon(Icons.copy, size: 16),
                  //           onPressed: _copyTextToClipboard,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   Expanded(
                  //     child: Scrollbar(
                  //       child: SingleChildScrollView(
                  //         padding: const EdgeInsets.all(16),
                  //         child: Row(
                  //           children: [
                  //             Flexible(
                  //               child: SelectableText(
                  //                 recognizedText.isEmpty
                  //                     ? "No text recognized"
                  //                     : recognizedText,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
            Positioned(
                top: 342,
                child: SizedBox(
                    height: 140,
                    width: 340,
                    child: TextButton(
                        onPressed:
                            isRecognizing ? null : _chooseImageSourceModal,
                        child: Image.asset("assets/UploadButton.png",
                            fit: BoxFit.fitWidth)))),
            Positioned(
                top: 458,
                child: SizedBox(
                    height: 140,
                    width: 340,
                    child: TextButton(
                        onPressed: isAllStepsCompleted
                            ? () => _goToInventory(product)
                            : null,
                        child: Image.asset("assets/InventoryButton.png",
                            fit: BoxFit.fitWidth)))),
            Positioned(
                top: 564,
                left: 10,
                child: SizedBox(
                    height: 140,
                    width: 240,
                    child: TextButton(
                        onPressed:
                            isAllStepsCompleted ? null : _skipCurrentStep,
                        child: Image.asset("assets/SkipButton.png",
                            fit: BoxFit.fitWidth)))),
            Positioned(
                top: 580,
                left: 240,
                child: SizedBox(
                    height: 105,
                    width: 105,
                    child: TextButton(
                        onPressed: !stepsCompleted[currentStep]
                            ? null
                            : () {
                                setState(() {
                                  if (currentStep < 2) {
                                    currentStep++;
                                  }
                                });
                              },
                        child: Image.asset("assets/NextButton.png",
                            fit: BoxFit.fitWidth)))),
          ]),
        ),
      ),
    );
  }
}
