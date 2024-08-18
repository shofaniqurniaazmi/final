import 'package:flutter/material.dart';
import 'package:nutritrack/presentation/pages/login_screen.dart';

class Profile extends StatelessWidget {
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
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
                    'shofanii',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    'Dolor sit',
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
      ),
    );
  }
}


