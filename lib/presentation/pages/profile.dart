import 'package:flutter/material.dart';
import 'package:nutritrack/common/config/storage.dart';
import 'package:nutritrack/service/firebase/authentication_service.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      appBar: AppBar(
        backgroundColor: Colors.purple,
        leading: SizedBox(),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              _firebaseAuth.logout(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No profile data available.'));
          } else {
            final userData = snapshot.data!;
            return Container(
              color: Colors.white,
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.purpleAccent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.grey.shade200,
                            child: Icon(
                              Icons.person,
                              size: 45,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          userData['fullName'] ?? 'No Name',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          userData['email'] ?? 'No Email',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.purple),
                    title: Text('Lorem ipsum'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.purple),
                    title: Text('Dolor sit'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.purple),
                    title: Text('Amet lorem'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.mail, color: Colors.purple),
                    title: Text('Ipsum dolor'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.purple),
                    title: Text('Sit amet'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
