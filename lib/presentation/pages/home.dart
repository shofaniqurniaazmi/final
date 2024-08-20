import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nutritrack/common/assets/assets.dart';
import 'package:nutritrack/common/config/storage.dart';
import 'package:nutritrack/model/news.dart';
import 'package:nutritrack/presentation/widget/article.dart';
import 'package:nutritrack/service/firebase/authentication_service.dart';
import 'package:nutritrack/service/provider/news_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthenticationService _firebaseAuth = AuthenticationService();
  late Future<Map<String, dynamic>?> _userProfileFuture;
  late Future<List<dynamic>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _newsFuture = fetchNews();
  }

  Future<List<dynamic>> fetchNews() async {
    final url =
        'https://newsdata.io/api/1/news?apikey=pub_512145b24e23ed26e817e4017220145129057&country=id&language=id&category=health';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'] as List<dynamic>;
    } else {
      throw Exception('Failed to load news');
    }
  }

  void _fetchUserProfile() async {
    final userId =
        await SecureStorage().getUserId(); // Await the Future<String?>
    if (userId != null) {
      setState(() {
        _userProfileFuture = _firebaseAuth.getProfileUser(userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            coverImage, // Replace with your background image asset path
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            top: 40.0, // Position the box from the top
            left: 20.0, // Position the box from the left
            right: 20.0, // Set the right padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<Map<String, dynamic>?>(
                  future: _userProfileFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Text('No profile data');
                    } else {
                      final profile = snapshot.data!;
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
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 40.0,
                              color: Colors.purple,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              'Hello, ${profile['fullName']}!',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                    height:
                        20.0), // Space between the greeting box and pie chart
                Container(
                  padding: EdgeInsets.all(10.0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nutritional Data (Last Week)',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 150.0, // Height for the pie chart
                        width: double.infinity, // Width to fit the container
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: 30,
                                color: Colors.red,
                                title: 'Carbs',
                                radius: 50,
                                titleStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value: 25,
                                color: Colors.green,
                                title: 'Protein',
                                radius: 50,
                                titleStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value: 20,
                                color: Colors.blue,
                                title: 'Fats',
                                radius: 50,
                                titleStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value: 25,
                                color: Colors.orange,
                                title: 'Fiber',
                                radius: 50,
                                titleStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 0,
                            centerSpaceRadius: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top:
                330.0, // Adjusted to start below the greeting box and pie chart
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: FutureBuilder<List<dynamic>>(
                future: _newsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('No news available',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.grey)));
                  } else {
                    final newsList = snapshot.data!;
                    final topNews = newsList.take(5).toList();
                    final otherNews = newsList.skip(5).take(5).toList();
                    print(otherNews);
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              prefixIcon: Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.purple,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Top News',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        SizedBox(
                          height: 150.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: topNews.length,
                            itemBuilder: (context, index) {
                              final newsItem = topNews[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: buildRecommendationCard(
                                  context,
                                  newsItem['title'] ?? 'No title',
                                  newsItem['image_url'] ?? '',
                                  newsItem['description'] ?? 'No description',
                                  newsItem['link']??'',
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Other News',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        SizedBox(
                          height: 150.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: otherNews.length,
                            itemBuilder: (context, index) {
                              final newsItem = otherNews[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: buildRecommendationCard(
                                  context,
                                  newsItem['title'] ?? 'No title',
                                  newsItem['image_url'] ?? '',
                                  newsItem['description'] ?? 'No description',
                                  newsItem['link']??'',
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecommendationCard(BuildContext context, String title,
      String imagePath, String description,String link) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Article(
              link: link,
              imagePath: imagePath,
              title: title,
              description: description,
            ),
          ),
        );
      },
      child: Container(
        width: 150.0,
        height: 150.0, // Set a fixed height for consistency
        margin: EdgeInsets.only(right: 10.0), // Space between cards
        child: Card(
          elevation: 4.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imagePath,
                height: 80.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.0,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
