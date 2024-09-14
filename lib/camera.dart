import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'image_preview.dart';
import 'inventory_manager.dart';
import 'inventory.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late TextRecognizer textRecognizer;
  late ImagePicker imagePicker;
  String recognizedText = "";

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

  void _goToInventory() async {
    // Show popup to enter product name
    final productName = await showDialog<String>(
      context: context,
      builder: (context) {
        String name = '';
        return AlertDialog(
          title: const Text('Enter Product Name'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Product Name'),
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
      inventoryManager.addItem(productName, {});

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
  Widget build(BuildContext context) {
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
                onPressed: isAllStepsCompleted ? _goToInventory : null,
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
