import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/repository/posts_repo.dart';
import '../../services/gmap_services.dart';

class PlaceDetails extends ConsumerStatefulWidget {
  final String postId;

  PlaceDetails({required this.postId});
  @override
  ConsumerState<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends ConsumerState<PlaceDetails> {
  final TextEditingController _commantcontroller = TextEditingController();

  final pageController = PageController();
  @override
  Widget build(BuildContext context) {
    final _post = ref.watch(singlePostProvider(widget.postId));
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 250,
              child: PageView.builder(
                controller: pageController,
                itemCount: _post!.media.length,
                itemBuilder: (context, i) {
                  return ClipRRect(
                    // borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      _post.media[i].url, // Replace with actual image URL
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null)
                          return child; // Image loaded successfully
                        return Center(
                          child:
                              CircularProgressIndicator(), // Show loading spinner
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image,
                                  size: 50, color: Colors.grey[600]),
                              SizedBox(height: 5),
                              Text(
                                'Photo not found',
                                style: TextStyle(color: Colors.grey[600]),
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
            const SizedBox(height: 5),
            SmoothPageIndicator(
              controller: pageController,
              count: 2,
              effect: const WormEffect(dotHeight: 4, dotWidth: 5),
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        // Row(
                        //   children: [
                        //     Text(
                        //       _post!.placeName,
                        //       style: TextStyle(
                        //           fontSize: 20, fontWeight: FontWeight.bold),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 6),
                        InkWell(
                          onTap: () {
                            openGoogleMaps(_post.lat, _post.lng);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.location_on),
                              Text(_post!.placeName,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     Text("4.8"),
                        //     SizedBox(width: 6),
                        //     Text(
                        //       "ratings...",
                        //     )
                        //   ],
                        // ),
                        TabBar(tabs: [
                          Tab(text: "About"),
                          Tab(text: "Reviews"),
                          Tab(text: "Commants")
                        ]),
                        Expanded(
                          child: TabBarView(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  "Description",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(child: Text(_post.experience)),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: FilledButton(
                                      onPressed: () {},
                                      child: Text("Save Trip")),
                                ),
                              ],
                            ),

                            // for review
                            Column(
                              children: [
                                SizedBox(height: 10),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _post.reviews.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(_post.reviews[index].type,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                " • ${_post.reviews[index].name}",
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          Text(_post.reviews[index].feedback,
                                              textAlign: TextAlign.center),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              RatingBarIndicator(
                                                rating: _post.reviews[index]
                                                    .rating, // Static rating value
                                                itemBuilder: (context, index) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.red,
                                                ),
                                                itemCount: 5,
                                                itemSize: 20.0,
                                                direction: Axis.horizontal,
                                              ),
                                              Text(" • "),
                                              Text(_post.reviews[index].rating
                                                  .toString())
                                            ],
                                          ),
                                          Divider()
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            // for Comments
                            Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _post.comments.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  _post
                                                      .comments[index].username,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                " • ${timeago.format(_post.comments[index].timestamp)}",
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          Text(_post.comments[index].text,
                                              textAlign: TextAlign.center),
                                          Divider()
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                TextFormField(
                                  controller: _commantcontroller,
                                  decoration: InputDecoration(
                                    hintText: "Type a message...",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.send,
                                          color:
                                              Theme.of(context).primaryColor),
                                      // onPressed: () {
                                      //   FocusScope.of(context).unfocus();
                                      // },
                                      onPressed: () async {
                                        final commentText =
                                            _commantcontroller.text.trim();
                                        if (commentText.isEmpty) return;

                                        FocusScope.of(context).unfocus();

                                        await addComment(
                                          postId: widget.postId,
                                          userId: FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid, // Replace with real user id
                                          username:
                                              'John Doe', // Replace with real username
                                          text: commentText,
                                        );
                                        fetchPostList(ref);
                                        final _post = ref.read(
                                            singlePostProvider(widget.postId));

                                        _commantcontroller.clear();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ),
                        // SizedBox(
                        //   width: double.maxFinite,
                        //   child: FilledButton(
                        //       onPressed: () {}, child: Text("Save Trip")),
                        // ),
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
