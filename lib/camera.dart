import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'image_preview.dart';
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

  List<String?> pickedImagePaths = List.filled(3, null); // Store images for each step
  List<bool> stepsCompleted = [false, false, false]; // Tracks whether each step is done or skipped

  bool isRecognizing = false;
  int currentStep = 0; // Track the current step (0: Nutritional label, 1: Ingredients, 2: Product picture)

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

  void _goToInventory() {
    // Navigate to the Inventory page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Inventory()), // Assuming Inventory is a separate page
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ML Text Recognition'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: pickedImagePaths[currentStep] == null
                  ? const Text('No image selected for this step')
                  : ImagePreview(imagePath: pickedImagePaths[currentStep]!),
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
              onPressed: isAllStepsCompleted || isRecognizing
                  ? null
                  : _chooseImageSourceModal,
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
            const Divider(),
            // Display recognized text or move to next step
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: isAllStepsCompleted ? _goToInventory : null, // Only active when all steps are done
                child: const Text('Go to Inventory'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}