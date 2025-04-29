import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triptale/src/presentation/home/new_post.dart';
import 'package:triptale/src/presentation/user_auth/sign_up.dart';
import 'package:triptale/src/presentation/user_auth/signin.dart';

import '../../data/dtos/post_model.dart';
import '../../data/repository/posts_repo.dart';
import '../expanse_calc/expanse_home.dart';
import '../trips/place_details.dart';
import 'posts_home.dart';
import 'profile.dart';

// ✅ MAIN HOMEPAGE
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      // HomeWidget(),
      TravelPostPage(),
      CreatePost(),
      ExpanseCalcState(),
      ProfilePage(), // ✅ Added ProfilePage
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_sharp), label: 'Post'),
          BottomNavigationBarItem(
              icon: Icon(Icons.request_quote), label: 'Expanse'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'), // ✅ Profile tab
        ],
      ),
      body: SafeArea(
        child: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      ),
    );
  }
}

// ✅ HOME WIDGET
class HomeWidget extends ConsumerStatefulWidget {
  const HomeWidget({
    super.key,
  });

  @override
  ConsumerState<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget> {
  List<TravelPost> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts(); // Async logic is separated
  }

  Future<void> _loadPosts() async {
    // final DatabaseReference _ref = FirebaseDatabase.instance.ref('travelPosts');
    // final _data = await _ref.get();
    // print(_data);
    final DataSnapshot snapshot =
        await FirebaseDatabase.instance.ref('travelPosts').get();

    if (snapshot.exists) {
      final List dataList = snapshot.value as List;

      List<TravelPost> posts = [];
      for (int i = 0; i < dataList.length; i++) {
        final item = dataList[i];
        if (item != null) {
          posts.add(TravelPost.fromMap(
              i.toString(), Map<String, dynamic>.from(item)));
        }
      }

      print(posts[0].placeName);
    }
  }

  @override
  List mylist = [
    "Mount",
    "Beach",
    "WaterFalls",
    "Temple",
    "Hill Stationjkgjkgjhgj",
    "Forest"
  ];
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
                  Text(
                    mylist[index],
                    style: TextStyle(
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
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
        Expanded(
          child: ListView.builder(
            itemCount: 5, // just a sample count
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlaceDetails(postId: "")));
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
          ),
        )
      ],
    );
  }
}




// class _HomeWidgetState extends ConsumerState<HomeWidget> {
//   List<TravelPost> _posts = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadPosts(); // Async logic is separated
//   }

//   Future<void> _loadPosts() async {
//     final posts = await TravelPostService().fetchPostsExcludingUser('u002');
//     setState(() {
//       _posts = posts;
//       _isLoading = false;
//     });
//   }

//   List<String> mylist = [
//     "Mount",
//     "Beach",
//     "WaterFalls",
//     "Temple",
//     "Hill Station",
//     "Forest"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? Center(child: CircularProgressIndicator())
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.only(left: 10, top: 10),
//                 child: Text(
//                   "Category",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.all(10),
//                 height: 100,
//                 child: ListView.builder(
//                   itemCount: mylist.length,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 5),
//                           child: const CircleAvatar(
//                             maxRadius: 40,
//                           ),
//                         ),
//                         Text(
//                           mylist[index],
//                           style: const TextStyle(
//                             fontSize: 12,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         )
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               Row(
//                 children: const [
//                   SizedBox(width: 20),
//                   Text("Top Place"),
//                   Spacer(),
//                   Text("View All"),
//                   SizedBox(width: 20),
//                 ],
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _posts.length,
//                   itemBuilder: (context, index) {
//                     final post = _posts[index];
//                     return InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => PlaceDetails()),
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           color:
//                               Theme.of(context).colorScheme.secondaryContainer,
//                         ),
//                         margin: const EdgeInsets.all(10),
//                         padding: const EdgeInsets.all(15),
//                         height: 140,
//                         child: Row(
//                           children: [
//                             // Display media image
//                             post.media.isNotEmpty &&
//                                     post.media[0]['type'] == 'image'
//                                 ? ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: Image.network(
//                                       post.media[0]['url'],
//                                       width: 120,
//                                       height: double.infinity,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   )
//                                 : Container(
//                                     width: 120,
//                                     color: Colors.grey,
//                                   ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Text(
//                                     post.placeName,
//                                     style: const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       const Icon(Icons.location_on),
//                                       const SizedBox(width: 6),
//                                       Text(post.placeName
//                                           .split(',')
//                                           .last
//                                           .trim()),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       const Icon(Icons.star_rounded),
//                                       const SizedBox(width: 6),
//                                       Text(post.reviews.isNotEmpty
//                                           ? post.reviews[0]['rating'].toString()
//                                           : 'N/A'),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               )
//             ],
//           );
//   }
// }
