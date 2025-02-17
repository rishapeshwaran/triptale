import 'package:flutter/material.dart';

class FavoriteTrips extends StatefulWidget {
  const FavoriteTrips({super.key});

  @override
  State<FavoriteTrips> createState() => _FavoriteTripsState();
}

class _FavoriteTripsState extends State<FavoriteTrips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Favorite Trips"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(width: 15),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisExtent: 250,
                      // mainAxisSpacing: 20,
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.red,
                            ),
                            // child: Image.network(
                            //   "https://upload.wikimedia.org/wikipedia/commons/d/d9/Chennai_-_bird%27s-eye_view.jpg",
                            //   fit: BoxFit.fill,
                            // ),
                          ),
                          Text(
                            "  Marina Beach",
                            style: TextStyle(fontSize: 18),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.location_on_outlined,
                                size: 20,
                              ),
                              Text("Chennai")
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(width: 15),
              ],
            ),
          )
        ],
      ),
    );
  }
}
