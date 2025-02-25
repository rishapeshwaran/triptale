import 'package:flutter/material.dart';

class PlaceDetails extends StatefulWidget {
  const PlaceDetails({super.key});

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Column(
          children: [
            Container(
              height: 300,
              color: Colors.grey,
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Marina Beach",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on),
                            SizedBox(width: 6),
                            Text(
                              "Chennai",
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text("4.8"),
                            SizedBox(width: 6),
                            Text(
                              "ratings...",
                            )
                          ],
                        ),
                        TabBar(tabs: [
                          Tab(text: "About"),
                          Tab(text: "Review"),
                          Tab(text: "Photo")
                        ]),
                        Expanded(
                          child: TabBarView(children: [
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    "Description",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "Marina Beach is a must-visit destination in Chennai.  It's a place where you can experience the city's vibrant culture, enjoy the natural beauty of the coastline, and create lasting memories.  Whether you're looking for a relaxing stroll, a taste of local street food, or simply a place to soak in the atmosphere, Marina Beach has something to offer everyone"),
                                ],
                              ),
                            ),
                            Text("t2"),
                            Text("t3"),
                          ]),
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: FilledButton(
                              onPressed: () {}, child: Text("Save Trip")),
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
