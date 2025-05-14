import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

late Map<String, dynamic> diseaseInfo;

Future<void> loadDiseaseInfo() async {
  final String response = await rootBundle.loadString('assets/disease.json');
  diseaseInfo = json.decode(response);
}
