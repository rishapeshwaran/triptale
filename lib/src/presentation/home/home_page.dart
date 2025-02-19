import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List mylist = [
      "Mount",
      "Beach",
      "WaterFalls",
      "Temple",
      "Hill Station",
      "Forest"
    ];
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        centerTitle: true,
        title: Text("Home"),
        actions: [
          CircleAvatar(),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "  Category",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: 120,
            // color: Colors.amber,
            child: ListView.builder(
              itemCount: mylist.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: CircleAvatar(
                        maxRadius: 40,
                      ),
                    ),
                    Text(mylist[index])
                  ],
                );
              },
            ),
          ),
          Row(
            children: [
              SizedBox(width: 20),
              Text("Top Place"),
              Expanded(child: SizedBox()),
              Text("View All"),
              SizedBox(width: 20),
            ],
          ),
          Expanded(child: ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 200, 163, 163),
                ),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                height: 140,
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mount Everest",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(width: 6),
                              Text("Everest")
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.star_rounded),
                              SizedBox(width: 6),
                              Text("3.5")
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
