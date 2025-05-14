import 'package:flutter/material.dart';
import 'package:leafscan/widgets/inter.dart';

class Cbutton extends StatelessWidget {
  const Cbutton({
    super.key,
    required this.takePhoto,
    this.onPressed
  });

  //Default onPressed function
  

  final bool takePhoto;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (takePhoto) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2E7D32),
          fixedSize: Size(350, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_camera, size: 18, color: Colors.white),
            SizedBox(width: 8),
            Inter(content: 'Take Photo', size: 16, fontWeight: FontWeight.w500),
          ],
        ),
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        fixedSize: Size(350, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          side: BorderSide(width: 2, color: Color(0xFF2E7D32)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library, size: 18, color: Color(0xFF2E7D32)),
          SizedBox(width: 8),
          Inter(
            content: 'Select from Gallery',
            txtColor: Color(0xFF2E7D32),
            size: 16,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
