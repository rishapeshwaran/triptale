import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:triptale/src/data/repository/posts_repo.dart';

import '../../data/dtos/post_model.dart';
import '../../services/gmap_services.dart';
import '../trips/place_details.dart';

class TravelPostPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<TravelPostPage> createState() => _TravelPostPageState();
}

class _TravelPostPageState extends ConsumerState<TravelPostPage> {
  List<TravelPost> _posts = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPostList(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<TravelPost>? _posts = ref.watch(allPostsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Travel Experiences')),
      body: _posts == null
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : _posts.isEmpty
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // CircularProgressIndicator(),
                    Container(
                      width: 100,
                      height: 100,
                      child: LottieBuilder.asset(
                          "assets/lottie/Animation - 1743587126707.json"),
                    )
                  ],
                )) // Show message if empty
              : ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    final pageController = PageController();

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PlaceDetails(
                                              postId: _posts[index].postId)));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // User Info
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              _posts[index].profilePicture),
                                          onBackgroundImageError: (_, __) {},
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(_posts[index].username,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        TextButton(
                                            onPressed: () {},
                                            child: Text("follow"))
                                      ],
                                    ),
                                    Divider(),
                                    const SizedBox(height: 10),

                                    // Location
                                    InkWell(
                                      onTap: () {
                                        openGoogleMaps(_posts[index].lat,
                                            _posts[index].lng);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_on),
                                          Text(_posts[index].placeName,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // Image Slider
                                    _posts[index].media.isNotEmpty
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                height: 250,
                                                child: PageView.builder(
                                                  controller: pageController,
                                                  itemCount: _posts[index]
                                                      .media
                                                      .length,
                                                  itemBuilder: (context, i) {
                                                    return ClipRRect(
                                                      child: Image.network(
                                                        _posts[index]
                                                            .media[i]
                                                            .url,
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child; // Image loaded
                                                          }
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(), // Show loading spinner
                                                          );
                                                        },
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Container(
                                                            color: Colors
                                                                .grey[300],
                                                            alignment: Alignment
                                                                .center,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .broken_image,
                                                                    size: 50,
                                                                    color: Colors
                                                                            .grey[
                                                                        600]),
                                                                SizedBox(
                                                                    height: 5),
                                                                Text(
                                                                  'Photo not found',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600]),
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
                                              SmoothPageIndicator(
                                                controller: pageController,
                                                count:
                                                    _posts[index].media.length,
                                                effect: const WormEffect(
                                                    dotHeight: 4, dotWidth: 5),
                                              ),
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
                                                      size: 50,
                                                      color: Colors.grey[600]),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    'No image added',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                    SizedBox(height: 10),
                                    // Row(
                                    //   children: [
                                    //     Row(
                                    //       children: [
                                    //         InkWell(
                                    //           onTap: () {},
                                    //           child: Icon(
                                    //               _posts[index]
                                    //                       .likedByCurrentUser
                                    //                   ? Icons.favorite
                                    //                   : Icons.favorite_border,
                                    //               color: Colors.red),
                                    //         ),
                                    //         const SizedBox(width: 5),
                                    //         Text(
                                    //             "${_posts[index].likesCount} "),
                                    //       ],
                                    //     ),
                                    //     SizedBox(width: 15),
                                    //     Row(
                                    //       children: [
                                    //         Icon(Icons.comment_outlined),
                                    //         const SizedBox(width: 5),
                                    //         Text(
                                    //             "${_posts[index].comments.length}"),
                                    //       ],
                                    //     )
                                    //   ],
                                    // ),
                                    SizedBox(height: 10),
                                    Text(_posts[index].experience),
                                    const SizedBox(height: 5),
                                    // Divider()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
