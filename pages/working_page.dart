import 'package:flutter/material.dart';
import 'package:polo/design/costom_colors.dart';

class WorkingPage extends StatelessWidget {
  const WorkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 80,
            color: Colors.black,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 10),
                SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child:  Center(
                child: SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

