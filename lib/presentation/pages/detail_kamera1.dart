import 'package:flutter/material.dart';
import 'dart:io';

import 'package:nutritrack/presentation/pages/detail_kamera2.dart';

class DetailCamera1 extends StatefulWidget {
  final String imagePath;
  final String responseGemini;

  DetailCamera1({required this.imagePath, required this.responseGemini});

  @override
  _DetailCamera1State createState() => _DetailCamera1State();
}

class _DetailCamera1State extends State<DetailCamera1> {
  int? selectedPortion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Portion Size'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.file(File(widget.imagePath)),
          ),
          Expanded(
            child: ListView(
              children: List.generate(5, (index) {
                int portion = index + 1;
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(
                      '$portion Porsi',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: selectedPortion == portion
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedPortion = portion;
                      });

                      // Ensure selectedPortion is not null
                      if (selectedPortion != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailCamera2(
                              imagePath: widget.imagePath,
                              portion: selectedPortion!,
                              nutritionalData: {
                                'Karbohidrat': 0.0, // Replace with actual data
                                'Protein': 0.0,    // Replace with actual data
                                'Vitamin': 0.0,    // Replace with actual data
                                'Mineral': 0.0,    // Replace with actual data
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
