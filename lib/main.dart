import 'package:flutter/material.dart';
import 'package:leafscan/homepage.dart';
import 'package:leafscan/widgets/inter.dart';
import 'dataloader.dart';

import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  await Permission.camera.request();
  await Permission.storage.request(); // For Android 9 and below
  await Permission.photos.request(); // For Android 10+
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  await loadDiseaseInfo(); // Load JSON data before app starts
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPage = 0;

  final List<Widget> _pages = [Homepage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.spa, size: 20, color: Color(0xFF2E7D32)),
            SizedBox(width: 8),
            Inter(
              content: 'LeafScan',
              size: 24,
              fontWeight: FontWeight.bold,
              txtColor: Color(0xFF1A1A1A),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        surfaceTintColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size(1, 10),
          child: Divider(height: 1),
        ),
      ),
      body: _pages[_selectedPage],
    );
  }
}
