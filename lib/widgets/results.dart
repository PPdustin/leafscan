import 'package:flutter/material.dart';
import 'package:leafscan/widgets/inter.dart';
import '../dataloader.dart';

class Result extends StatelessWidget {
  const Result({super.key, this.disease, this.confidence});
  final String? disease;
  final String? confidence;

  @override
  Widget build(BuildContext context) {

    if (disease != null) {
      return Container(
        padding: EdgeInsets.all(25),
        width: 350,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Inter(
              content: 'Detection Result',
              size: 20,
              txtColor: Colors.black, //Color(0xFF2E7D32),
            ),
            SizedBox(height: 16),
            Inter(
              content: disease!,
              size: 16,
              fontWeight: FontWeight.bold,
              txtColor:
                  (disease == "Healthy")
                      ? Color(0xFF2E7D32)
                      : Color(0xFF991B1B),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.bar_chart, color: Color(0xFF4B5563), size: 16),
                SizedBox(width: 8),
                Inter(
                  content: 'Confidence: ${confidence!}',
                  size: 14,
                  fontWeight: FontWeight.w600,
                  txtColor: Color(0xFF4B5563),
                ),
                
              ],
            ),
            if(disease != 'Healthy')...[
            SizedBox(height: 8),
            Inter(
              content: diseaseInfo[disease]['Description'],
              size: 14,
              fontWeight: FontWeight.w600,
              txtColor: Color(0xFF4B5563),
            ),
            SizedBox(height: 24,),
            Inter(
              content: 'Treatment',
              size: 16,
              txtColor: Colors.black,
            ),
            SizedBox(height: 8,),
            Inter(
              content: diseaseInfo[disease]['Treatment'],
              size: 14,
              fontWeight: FontWeight.w600,
              txtColor: Color(0xFF4B5563),
            ),
            SizedBox(height: 24,),
            Inter(
              content: 'Prevention',
              size: 16,
              txtColor: Colors.black,
            ),
            SizedBox(height: 8,),
            Inter(
              content: diseaseInfo[disease]['Prevention'],
              size: 14,
              fontWeight: FontWeight.w600,
              txtColor: Color(0xFF4B5563),
            ),
            ]
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
