import 'package:flutter/material.dart';

class UserClassificationScreen extends StatefulWidget {
  const UserClassificationScreen({Key? key}) : super(key: key);

  @override
  _UserClassificationScreenState createState() =>
      _UserClassificationScreenState();
}

class _UserClassificationScreenState extends State<UserClassificationScreen> {
  List<bool> _selected = List.filled(4, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Classification'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildGridButton(
                    context,
                    'assets/ibuhamil.png',
                    'Ibu Hamil',
                    0,
                  ),
                  _buildGridButton(
                    context,
                    'assets/balita.png',
                    'Balita',
                    1,
                  ),
                  _buildGridButton(
                    context,
                    'assets/diet.png',
                    'Diet',
                    2,
                  ),
                  _buildGridButton(
                    context,
                    'assets/bulking.png',
                    'Bulking',
                    3,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserClassificationScreen()),
                );
              },
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(
      BuildContext context, String imagePath, String text, int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _selected[index]
            ? Color.fromARGB(255, 82, 8, 85)
            : const Color.fromARGB(255, 230, 138, 253),
        shadowColor: Colors.grey,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () {
        setState(() {
          _selected[index] = !_selected[index];
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 80,
                width: 80,
              ),
              const SizedBox(height: 10),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (_selected[index])
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}
