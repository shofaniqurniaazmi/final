import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class Article extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String link;

  Article({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.link,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // Add logic to download image or data here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imagePath,
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              description,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: ()async{
                print('press url launcher');
                final Uri url = Uri.parse(link);
                if (await canLauncherUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                };
              },
              child: Text('Baca Selengkapnya'),
            ),
          ],
        ),
      ),
    );
  }
}
