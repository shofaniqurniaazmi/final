import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Archive(),
    );
  }
}

class Archive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final archiveData = [
      {'time': '08:00 19-06-2024', 'title': 'Nasi Goreng'},
      {'time': '09:00 20-06-2024', 'title': 'Mie Goreng'},
      {'time': '10:00 21-06-2024', 'title': 'Nasi Goreng'},
      {'time': '10:00 21-06-2024', 'title': 'Nasi Goreng'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        leading: SizedBox(),
      ),
      body: ListView.builder(
        itemCount: archiveData.length,
        itemBuilder: (context, index) {
          return ArchiveItem(archiveData[index]);
        },
      ),
    );
  }
}

class ArchiveItem extends StatelessWidget {
  final Map<String, String> data;

  const ArchiveItem(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Split time and date
    final timeParts = data['time']!.split(' ');
    final time = timeParts[0];
    final date = timeParts.length > 1 ? timeParts[1] : '';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(title: data['title']!),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  'Image Placeholder',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                if (date.isNotEmpty)
                  Text(
                    date,
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              data['title']!,
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}

class NutritionalDataChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        height: 150.0,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 40,
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: 30,
                    color: Colors.red,
                    width: 15,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: 25,
                    color: Colors.green,
                    width: 15,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                    toY: 20,
                    color: Colors.blue,
                    width: 15,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 3,
                barRods: [
                  BarChartRodData(
                    toY: 15,
                    color: Colors.orange,
                    width: 15,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;

  DetailPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            NutritionalDataChart(), // Move your chart here
            ListTile(
              title: Text('Total Nutrisi'),
              subtitle: Text('100 kalori'),
            ),
            ListTile(
              title: Text('Karbohidrat'),
              subtitle: Text('50 gram'),
            ),
            ListTile(
              title: Text('Protein'),
              subtitle: Text('20 gram'),
            ),
            ListTile(
              title: Text('Lemak'),
              subtitle: Text('30 gram'),
            ),
          ],
        ),
      ),
    );
  }
}
