import 'package:flutter/material.dart';
import 'package:leafscan/widgets/cButton.dart';
import 'package:leafscan/widgets/recent.dart';
import 'package:leafscan/widgets/results.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Map<String, dynamic>> scanHistory = [];
  List<dynamic>? _classificationResult;
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    List<Map<String, dynamic>> history = await loadScanHistory();
    setState(() {
      scanHistory = history;
    });
  }

  //File? _image;
  File? _croppedImage;
  final picker = ImagePicker();
  //String? _disease;
  String? result;

  //save image on local storage
  Future<String> saveImageLocally(XFile image) async {
    // Get the app's documents directory (platform-specific)
    final directory = await getApplicationDocumentsDirectory();

    // Create a file path with a unique name using timestamp
    final imagePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Save the image to the local file system
    final File savedImage = File(imagePath);
    await savedImage.writeAsBytes(await image.readAsBytes());

    return imagePath;
  }

  Future<void> saveScanResult(
    String imagePath,
    String disease,
    String confidence,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    // Load existing history from local storage
    List<String> history = prefs.getStringList('scanHistory') ?? [];

    // Create a new entry as a JSON object
    Map<String, dynamic> newEntry = {
      'confidence': confidence,
      'imagePath': imagePath,
      'disease': disease,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Add the new entry to the history list
    history.add(jsonEncode(newEntry));

    // Save the updated history list back to SharedPreferences
    await prefs.setStringList('scanHistory', history);

    List<Map<String, dynamic>> updatedHis = await loadScanHistory();

    setState(() {
      scanHistory = updatedHis;
    });
  }

  Future<List<Map<String, dynamic>>> loadScanHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('scanHistory') ?? [];

    // Safely cast each entry as Map<String, dynamic>
    return history.map((entry) {
      final decoded = jsonDecode(entry);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else {
        throw Exception('Invalid data format');
      }
    }).toList();
  }

  Future<List<dynamic>> classify(File imageFile) async {
    Uint8List imageBytes = await imageFile.readAsBytes();
    List<String> labels = [
      'Brown Spot',
      'Corn Rust',
      'Healthy',
      'Leaf Blight',
      'Maize Streak Virus',
    ];

    // Decode image
    img.Image? decodedImage = img.decodeImage(imageBytes);

    // Resize the image to 256x256 pixels
    img.Image resizedImage = img.copyResize(
      decodedImage!,
      width: 256,
      height: 256,
    );

    // Convert back to bytes
    Uint8List resizedBytes = Uint8List.fromList(img.encodeJpg(resizedImage));

    String modelPath = "assets/resnet34.pt";
    // Load the model
    ClassificationModel classificationModel =
        await PytorchLite.loadClassificationModel(
          modelPath,
          224,
          224,
          5,
          labelPath: "assets/modelLabel.txt",
        );

    //print(modelPath);

    // Read image as bytes and classify
    List<double> imagePrediction = await classificationModel
        .getImagePredictionListProbabilities(
          resizedBytes,
          mean: torchVisionNormMeanRGB,
          std: torchVisionNormSTDRGB,
        );

    String disease = labels[classificationModel.softMax(imagePrediction)];
    double confidence = imagePrediction.reduce(max);

    String formattedConfidence = (confidence * 100).toInt().toString() + "%";
    // .toStringAsFixed(4)
    // .substring(0, confidence.toStringAsFixed(4).length - 2);

    String imagePath = await saveImageLocally(XFile(imageFile.path));
    await saveScanResult(imagePath, disease, formattedConfidence);

    return [disease, formattedConfidence];
  }

  // Function to pick an image
  Future<void> pickImage(String method) async {
    //step 1
    XFile? pickedFile;

    if (method == 'gallery') {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    } else if (method == 'camera') {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    }

    if (pickedFile == null) {
      return; // Exit if no file is selected
    }

    //step 2
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // 1:1 Aspect Ratio
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Crop Image",
          toolbarColor: Color(0xFF4CAF50),
          activeControlsWidgetColor: Color(0xFF4CAF50),
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true, // Lock the aspect ratio to 1:1
        ),
        IOSUiSettings(
          title: "Crop Image",
          aspectRatioLockEnabled: true, // Lock aspect ratio
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _croppedImage = File(croppedFile.path);
        _classificationResult = null;
      });

      List<dynamic> classification = await classify(_croppedImage!);
      setState(() {
        _classificationResult = classification;
      });
      // } else {
      //   print('Else triggered================');
      //   print(croppedFile);
    }

    // result = await classify(_croppedImage!);
    // setState((){
    //   _disease = result;
    // });

    // setState(() {
    //   _image = File(pickedFile.path);
    // });

    // Pass the image to the classification function
    //print(_image);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            children: [
              Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF4CAF50), width: 2),
                  borderRadius: BorderRadius.circular(16),
                  image:
                      _croppedImage != null
                          ? DecorationImage(
                            image: FileImage(_croppedImage!),
                            fit: BoxFit.fill,
                          )
                          : null,
                ),
              ),
              const SizedBox(height: 27),
              Cbutton(takePhoto: true, onPressed: () => pickImage('camera')),
              const SizedBox(height: 16),
              Cbutton(takePhoto: false, onPressed: () => pickImage('gallery')),
              const SizedBox(height: 27),

              if (_croppedImage != null)
                _classificationResult == null
                    ? CircularProgressIndicator(color: Color(0xFF4CAF50))
                    : Result(
                      disease: _classificationResult![0],
                      confidence: _classificationResult![1],
                    ),
              const SizedBox(height: 27),
              Recent(
                history: scanHistory,
                isNull: _classificationResult == null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
