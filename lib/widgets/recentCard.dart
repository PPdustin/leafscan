import 'package:flutter/material.dart';
import 'dart:io';
import 'package:leafscan/widgets/inter.dart';
import '../dataloader.dart';

class RecentCard extends StatelessWidget {
  const RecentCard({Key? key, this.item}) : super(key: key);
  final Map<String, dynamic>? item;

  String getTimeAgo(String timestamp) {
    DateTime time = DateTime.parse(timestamp);
    Duration difference = DateTime.now().difference(time);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: Colors.white,
            builder: (context) => _buildModalContent(context),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(File(item?['imagePath'] ?? '')),
                fit: BoxFit.cover,
              ),
            ),
            child:
                item?['disease'] != null
                    ? Container(
                      padding: const EdgeInsets.all(4),
                      color: Colors.black45,
                      child: Inter(
                        content: item!['disease'],
                        fontWeight: FontWeight.normal,
                        size: 12,
                      ),
                    )
                    : null,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              SizedBox(width: 2),
              Icon(Icons.history, color: Color(0xFF4B5563), size: 16),
              SizedBox(width: 2),
              Inter(
                content: getTimeAgo(item?['timestamp']),
                txtColor: Color(0xFF4B5563),
                fontWeight: FontWeight.normal,
                size: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModalContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Inter(
              content: 'Scan Result',
              size: 24,
              txtColor: Colors.black,  
            ),
            Container(
              width: 350,
              padding: EdgeInsets.fromLTRB(25, 25, 25, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Inter(
                        content: item!['disease'],
                        size: 16,
                        fontWeight: FontWeight.bold,
                        txtColor:
                            (item!['disease'] == "Healthy")
                                ? Color(0xFF2E7D32)
                                : Color(0xFF991B1B),
                      ),
                      Inter(
                        content: getTimeAgo(item?['timestamp'] ?? ''),
                        size: 14,
                        fontWeight: FontWeight.w500,
                        txtColor: Color(0xFF4B5563),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.bar_chart, color: Color(0xFF4B5563), size: 16),
                      SizedBox(width: 8),
                      Inter(
                        content: 'Confidence: ${item!['confidence']}',
                        size: 14,
                        fontWeight: FontWeight.w600,
                        txtColor: Color(0xFF4B5563),
                      ),

                    ],
                  ),
                ],
              ),
            ),
            //SizedBox(height: 16),
            if (item?['imagePath'] != null)
              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF4CAF50), width: 2),
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(File(item!['imagePath'])),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 8),
            if(item!['disease'] != 'Healthy')
            Container(
              width: 350,
              padding: EdgeInsets.fromLTRB(25 , 0, 25, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Inter(
                    content: diseaseInfo[item!['disease']]['Description'],
                    size: 14,
                    fontWeight: FontWeight.w600,
                    txtColor: Color(0xFF4B5563),
                  ),
                  SizedBox(height: 8),
                  // Text(
                  //   'Scanned: ${getTimeAgo(item?['timestamp'] ?? '')}',
                  //   style: TextStyle(fontSize: 16, color: Colors.grey),
                  // ),
                  SizedBox(height: 16),
                              
                  // Additional Content: Prevention and Treatment
                  Inter(
                    content: 'Prevention',
                    size: 16,
                    txtColor: Colors.black,
                  ),
                  SizedBox(height: 8),
                  Inter(
                    content: diseaseInfo[item?['disease']]['Prevention'] ??
                        'No prevention information available.',
                    size: 14,
                    fontWeight: FontWeight.w600,
                    txtColor: Color(0xFF4B5563),
                  ),
                  SizedBox(height: 16),
                  Inter(
                    content: 'Treatment',
                    size: 16,
                    txtColor: Colors.black,
                  ),
                  SizedBox(height: 8),
                  Inter(
                    content: diseaseInfo[item?['disease']]['Treatment'] ??
                        'No prevention information available.',
                    size: 14,
                    fontWeight: FontWeight.w600,
                    txtColor: Color(0xFF4B5563),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32), // Forest green primary color
                foregroundColor: Colors.white, // White text for contrast
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Comfortable padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners matching design
                  side: const BorderSide(color: Color(0xFFE5E7EB), width: 1), // Light gray border
                ),
                elevation: 2, // Subtle shadow
                textStyle: const TextStyle(
                  fontFamily: 'Inter', // Inter font family
                  fontSize: 14, // Size matching description text
                  fontWeight: FontWeight.w500, // Medium weight for button text
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        ),
      ),
    );
  }
}
