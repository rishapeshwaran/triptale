import 'package:flutter/material.dart';

import '../expanse_calc/trip_expance.dart';
import '../trips/place_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List mylist = [
    "Mount",
    "Beach",
    "WaterFalls",
    "Temple",
    "Hill Stationjkgjkgjhgj",
    "Forest"
  ];

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      HomeWidget(mylist: mylist),
      Text('Index 1: Business'),
      _ExpanseCalcState(),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_sharp), label: 'Post'),
          BottomNavigationBarItem(
              icon: Icon(Icons.request_quote), label: 'Expanse calc'),
        ],
      ),
      appBar: AppBar(
          // leading: Icon(Icons.menu),
          centerTitle: true,
          title: Text("Home"),
          actions: [CircleAvatar(), SizedBox(width: 10)]),
      body: SafeArea(
          child: Center(child: _widgetOptions.elementAt(_selectedIndex))),
      // body: HomeWidget(mylist: mylist),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
    required this.mylist,
  });

  final List mylist;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "  Category",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.all(10),
          height: 100,
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
                  Text(mylist[index],
                      style: TextStyle(
                          fontSize: 12, overflow: TextOverflow.ellipsis))
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
            return InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PlaceDetails()));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.secondaryContainer,
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
              ),
            );
          },
        ))
      ],
    );
  }
}

class _ExpanseCalcState extends StatefulWidget {
  const _ExpanseCalcState({super.key});

  @override
  State<_ExpanseCalcState> createState() => __ExpanseCalcStateState();
}

class __ExpanseCalcStateState extends State<_ExpanseCalcState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(child: ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TripExpance(),
                        ));
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            maxRadius: 25,
                            child: Icon(Icons.flight_takeoff),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Pondy"),
                                SizedBox(height: 5),
                                Text("10/01/2025"),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Total amount"),
                              SizedBox(height: 5),
                              Container(
                                child: Text("₹10000"),
                              ),
                            ],
                          ),
                          SizedBox(width: 20)
                          // Container(
                          //   width: 80,
                          //   color: Colors.red,
                          //   child: Center(
                          //     child: Icon(Icons.currency_rupee),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
