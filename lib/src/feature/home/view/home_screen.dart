import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 22),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.red),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Aktaruzzaman"),
                      Text("Let's watch a movie"),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.search),
                  SizedBox(width: 6),
                  Icon(Icons.notifications_none_outlined),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
