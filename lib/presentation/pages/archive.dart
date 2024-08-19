import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nutritrack/common/assets/assets.dart';
import 'package:nutritrack/common/config/storage.dart';
import 'package:nutritrack/service/firebase/storage_service.dart';

class Archive extends StatefulWidget {
  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  StorageFirebaseService _storageFirebaseService = StorageFirebaseService();
  List<Map<String, dynamic>>? archiveDataFromDatabase;

  Future<void> _getArchiveData() async {
    String? userId = await SecureStorage().getUserId();
    List<Map<String, dynamic>> data =
        await _storageFirebaseService.getAllArchives(userId!);
    setState(() {
      archiveDataFromDatabase = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _getArchiveData();
  }

  @override
  Widget build(BuildContext context) {
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
      body: archiveDataFromDatabase == null
          ? Center(child: CircularProgressIndicator())
          : archiveDataFromDatabase!.isEmpty
              ? Center(child: Text('No archive data available'))
              : ListView.builder(
                  itemCount: archiveDataFromDatabase!.length,
                  itemBuilder: (context, index) {
                    return ArchiveItem(archiveDataFromDatabase![index]);
                  },
                ),
    );
  }
}

class ArchiveItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const ArchiveItem(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Split time and date
    final timeParts = data['created_at'].toString().split(' ');
    final time = timeParts[0];
    final date = timeParts.length > 1 ? timeParts[1] : '';

    return InkWell(
      onTap: () {
        print(data['image_url']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              content: data['content']!,
              date: date,
              time: time,
              image: data['image_url'],
            ),
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
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  data['image_url'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Text('Image not available'));
                  },
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
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              data['content'] ?? '',
              style: TextStyle(
                fontSize: 16.0,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 2,
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
  final String content;
  final String date;
  final String time;
  final String image;

  DetailPage(
      {required this.content,
      required this.date,
      required this.time,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    image ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('Image not available'));
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
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
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(content),
          
              // NutritionalDataChart(), // Move your chart here
              // ListTile(
              //   title: Text('Total Nutrisi'),
              //   subtitle: Text('100 kalori'),
              // ),
              // ListTile(
              //   title: Text('Karbohidrat'),
              //   subtitle: Text('50 gram'),
              // ),
              // ListTile(
              //   title: Text('Protein'),
              //   subtitle: Text('20 gram'),
              // ),
              // ListTile(
              //   title: Text('Lemak'),
              //   subtitle: Text('30 gram'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
