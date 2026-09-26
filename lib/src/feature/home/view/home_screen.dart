import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
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
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Watch popular movies 1917"),
                    SizedBox(height: 10),
                    Text("Lyrics are the words that make up a song."),
                    Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 36,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: Text(
                              "Click Here",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 4, backgroundColor: Colors.blue),
                  SizedBox(width: 3),
                  CircleAvatar(radius: 3, backgroundColor: Colors.grey),
                  SizedBox(width: 3),
                  CircleAvatar(radius: 3, backgroundColor: Colors.grey),
                  SizedBox(width: 3),
                  CircleAvatar(radius: 3, backgroundColor: Colors.grey),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text("Latest Movies"),
                  Spacer(),
                  Text("See all", style: TextStyle(color: Colors.blueAccent)),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 189, // enough for image (135) + gap (6) + 2 lines of text
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 12,
                          itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                  height: 135,
                                  width: 111,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 6),
                                SizedBox(
                                  width: 111,
                                  child: Text(
                                    "Avatar: The Way of Water",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text("Top Rated"),
                  Spacer(),
                  Text("See all", style: TextStyle(color: Colors.blueAccent)),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 189, // enough for image (135) + gap (6) + 2 lines of text
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 12,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                    height: 135,
                                    width: 111,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  SizedBox(
                                    width: 111,
                                    child: Text(
                                      "Avatar: The Way of Water",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                      ),
                    ),
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
