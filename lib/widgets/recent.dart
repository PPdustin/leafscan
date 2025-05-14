// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:leafscan/widgets/inter.dart';
import 'package:leafscan/widgets/recentCard.dart';

class Recent extends StatelessWidget {
  const Recent({super.key, required this.history, required this.isNull});
  final List<Map<String, dynamic>> history;
  final bool isNull;

  

  @override
  Widget build(BuildContext context) {
    history.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    return Container(
      height: 200,
      width: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Inter(
            content: 'Recent Scans',
            size: 18,
            fontWeight: FontWeight.bold,
            txtColor: Color(0xFF1A1A1A),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 130,
            child:
                (history.length == 1 && isNull) || history.length > 1
                    ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      //shrinkWrap: true,
                      itemCount: isNull ? history.length : history.length - 1,
                      itemBuilder: (context, index) {
                        final item =
                            isNull ? history[index] : history[index + 1];
                        return RecentCard(item: item);
                      },
                    )
                    : Inter(
                      txtColor: Color(0xFF4B5563),
                      content: 'No Recent Scans Found.',
                    ),
          ),
        ],
      ),
    );
  }
}
