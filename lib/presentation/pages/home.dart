import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nutritrack/common/assets/assets.dart';
import 'package:nutritrack/common/config/storage.dart';
import 'package:nutritrack/presentation/widget/article.dart';
import 'package:nutritrack/service/firebase/authentication_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthenticationService _firebaseAuth = AuthenticationService();
  late Future<Map<String, dynamic>?> _userProfileFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
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
                        // print(profile);
                        final String username = profile['fullName'] ?? 'User';
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
                                'Hello, $username!',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
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
                              width:
                                  double.infinity, // Width to fit the container
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
                      SizedBox(
                          width: 20.0), // Space between the pie chart and text
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
              child: Column(
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
                    'Top Recommended',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height:
                        150.0, // Set the height of the container to fit the cards
                    child: SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal, // Enable horizontal scrolling
                      child: Row(
                        children: [
                          // fething kedalam sini
                          buildRecommendationCard(
                            context,
                            'Sayuran',
                            sayurImage, // Replace with your image asset path
                            'Membantu mengontrol asupan kalori dan memberikan serat yang penting untuk pencernaan.',
                          ),
                          SizedBox(width: 10.0),
                          buildRecommendationCard(
                            context,
                            'Buah-buahan',
                            buahImage, // Replace with your image asset path
                            'Kaya akan vitamin dan mineral yang penting untuk kesehatan.',
                          ),
                          SizedBox(width: 10.0),
                          buildRecommendationCard(
                            context,
                            'Ikan',
                            ikanImage, // Replace with your image asset path
                            'Sumber protein dan lemak sehat yang baik untuk jantung.',
                          ),
                          SizedBox(width: 10.0),
                          buildRecommendationCard(
                            context,
                            'Telur',
                            telurImage, // Replace with your image asset path
                            'Penting untuk membangun dan memperbaiki jaringan tubuh.',
                          ),
                          // Add more cards here if needed
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Other Recommendations',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height:
                        150.0, // Set the height of the container to fit the cards
                    child: SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal, // Enable horizontal scrolling
                      child: Row(
                        children: [
                          buildRecommendationCard(
                            context,
                            'Sandwich',
                            sandwichImage, // Replace with your image asset path
                            'Kaya akan vitamin dan mineral yang penting untuk kesehatan.',
                          ),
                          SizedBox(width: 10.0),
                          buildRecommendationCard(
                            context,
                            'Salad Buah',
                            saladImage, // Replace with your image asset path
                            'Sumber protein dan lemak sehat yang baik untuk jantung.',
                          ),
                          SizedBox(width: 10.0),
                          buildRecommendationCard(
                            context,
                            'Capcay',
                            capcayImage, // Replace with your image asset path
                            'Penting untuk membangun dan memperbaiki jaringan tubuh.',
                          ),
                          SizedBox(width: 10.0),
                          buildRecommendationCard(
                            context,
                            'Sop Iga',
                            sopigaImage, // Replace with your image asset path
                            'Penting untuk membangun dan memperbaiki jaringan tubuh.',
                          ),
                          // Add more cards here if needed
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecommendationCard(BuildContext context, String title,
      String imagePath, String description) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Article(
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
              Image.asset(
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
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
