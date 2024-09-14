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

Future<CleanData> createCleanData(String payload) async {
  final response = await http.post(
    Uri.parse('http://10.37.100.33:3000/api/clean'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'payload': payload,
    }),
  );

  if (response.statusCode == 200) {
    return CleanData.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    print(payload);
    print(response.statusCode);
    print(response.body);
    throw Exception(response.body);
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
    print(response.body);
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
    print(response.body);
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
  Product product =
      Product(label: "", name: "", description: "", nutrients: [], ingredients: []);
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
          final results = await Future.wait([
            createPopulatedNutrients(recognizedNutrientText),
            createPopulatedIngredients(recognizedText)
          ]);
          Product p = Product(
              label: meta.label,
              name: meta.name,
              description: meta.description,
              nutrients: results[0] as List<Nutrient>,
              ingredients: results[1] as List<Ingredient>);
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

      // Move to next step
      if (currentStep < 2) {
        setState(() {
          currentStep++;
        });
      }
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

    // Add new item to inventory and navigate to Inventory page
    if (productName != null && productName.isNotEmpty) {
      final inventoryManager = InventoryManager();
      inventoryManager.addItem(productName, data.toJson());

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (pickedImagePaths[currentStep] != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      ImagePreview(imagePath: pickedImagePaths[currentStep]!),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text('No image selected for this step'),
                ),
              // Display current step
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Step ${currentStep + 1} of 3',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: isRecognizing ? null : _chooseImageSourceModal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Pick an image'),
                    if (isRecognizing) ...[
                      const SizedBox(width: 20),
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: isAllStepsCompleted ? null : _skipCurrentStep,
                child: const Text('Skip'),
              ),
              ElevatedButton(
                onPressed: isAllStepsCompleted ? () => _goToInventory(product) : null,
                child: const Text('Go to Inventory'),
              ),
              if (!isRecognizing && recognizedText.isNotEmpty) ...[
                const Divider(),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Recognized Text",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 16),
                        onPressed: _copyTextToClipboard,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Flexible(
                            child: SelectableText(
                              recognizedText.isEmpty
                                  ? "No text recognized"
                                  : recognizedText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
