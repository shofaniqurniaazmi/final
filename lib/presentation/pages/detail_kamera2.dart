import 'package:flutter/material.dart';
import 'dart:io';
import 'package:nutritrack/presentation/pages/archive.dart';

class DetailCamera2 extends StatelessWidget {
  final String imagePath;
  final int portion;
  final Map<String, double> nutritionalData; // Data nutrisi

  DetailCamera2({
    required this.imagePath,
    required this.portion,
    required this.nutritionalData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Your Food'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.file(File(imagePath)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Total $portion Porsi Makanan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          NutritionalData(nutritionalData: nutritionalData), // Pass data nutrisi
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman Archive
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Archive(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              child: Text(
                'SAVE',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NutritionalData extends StatelessWidget {
  final Map<String, double> nutritionalData;

  NutritionalData({required this.nutritionalData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: nutritionalData.entries.map((entry) {
          return NutritionalBar(
            label: entry.key,
            value: entry.value,
            color: _getColorForLabel(entry.key),
          );
        }).toList(),
      ),
    );
  }

  Color _getColorForLabel(String label) {
    switch (label) {
      case 'Karbohidrat':
        return Colors.orange;
      case 'Protein':
        return Colors.green;
      case 'Vitamin':
        return Colors.red;
      case 'Mineral':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class NutritionalBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  NutritionalBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey[300],
              color: color,
              minHeight: 10,
            ),
          ),
          SizedBox(width: 8),
          Text(
            '${value.toInt()}%',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
