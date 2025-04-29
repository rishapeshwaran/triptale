import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:triptale/src/data/dtos/post_model.dart';
import 'package:triptale/src/presentation/user_auth/edit_profile.dart';

import '../../data/dtos/expanse_master_dto.dart';
import '../../data/dtos/user_profile_dto.dart';
import '../../data/repository/expanse_repository.dart';
import '../../data/repository/posts_repo.dart';
import '../../data/repository/user_repository.dart';
import '../../services/gmap_services.dart';
import '../location/location_demo.dart';
import '../trips/place_details.dart';
import '../user_auth/signin.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late UserModel? _userProfile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserByUid(FirebaseAuth.instance.currentUser!.uid, ref);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAndSetExpanseMasters(ref);
    });
  }

  double totalamt = 0;
  int totalcmt = 0;
  getTotalExpanseAndCommands(List<TripExpanseMaster> tripExpanseMasterList,
      List<TravelPost> userPosts) {
    totalamt = 0;
    totalcmt = 0;
    for (int i = 0; i < tripExpanseMasterList.length; i++) {
      totalamt += tripExpanseMasterList[i].budget;
    }
    for (int i = 0; i < userPosts.length; i++) {
      totalcmt += userPosts[i].comments.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TripExpanseMaster> tripExpanseMasterList =
        ref.watch(expanseMasterProvider);
    final userPosts =
        getUserPostsByUid(ref, FirebaseAuth.instance.currentUser!.uid);
    getTotalExpanseAndCommands(tripExpanseMasterList, userPosts);

    print("--->" + userPosts.toString());
    _userProfile = ref.watch(userProvider);

    if (_userProfile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Signin()),
                );
              });
            },
            child: const Text("Logout"),
          ),
          const SizedBox(width: 10),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                height: 100,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    _userProfile!.profileUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person, size: 50),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _userProfile!.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(_userProfile!.email),
              const SizedBox(height: 10),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("Total Trips",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(userPosts.length.toString()),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Total Comments",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(totalcmt.toString()),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Total Expanse",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(totalamt.toString()),
                    ],
                  ),
                ],
              ),
              const Divider(),
              for (int i = 0; i < userPosts.length; i++)
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PlaceDetails(postId: userPosts[i].postId)));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(15),
                    height: 140,
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: userPosts[i].media.isNotEmpty
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      child: PageView.builder(
                                        controller: pageController,
                                        itemCount: userPosts[i].media.length,
                                        itemBuilder: (context, Imgi) {
                                          return ClipRRect(
                                            child: Image.network(
                                              userPosts[i].media[Imgi].url,
                                              fit: BoxFit.fill,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child; // Image loaded
                                                }
                                                return Center(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // CircularProgressIndicator(),
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      child: LottieBuilder.asset(
                                                          "assets/lottie/Animation - 1743587126707.json"),
                                                    )
                                                  ],
                                                ));
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[300],
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.broken_image,
                                                          size: 50,
                                                          color:
                                                              Colors.grey[600]),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        'Photo not found',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[600]),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                  ],
                                )
                              : SizedBox(
                                  height: 250,
                                  child: Container(
                                    color: Colors.grey[300],
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.broken_image,
                                            size: 50, color: Colors.grey[600]),
                                        SizedBox(height: 5),
                                        Text(
                                          'No image added',
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userPosts[i].placeName,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              InkWell(
                                onTap: () {
                                  openGoogleMaps(
                                      userPosts[i].lat, userPosts[i].lng);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on),
                                    Text(userPosts[i].placeName,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  Text("Reviews : "),
                                  SizedBox(width: 5),
                                  Text(
                                    userPosts[i].reviews.length.toString(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  Text("Comments"),
                                  SizedBox(width: 5),
                                  Text(
                                    userPosts[i].comments.length.toString(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => const LocationScreen()),
              //     );
              //   },
              //   child: const Text('Show Location Screen'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
