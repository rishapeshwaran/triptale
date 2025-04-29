import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:triptale/src/data/dtos/post_model.dart';
import 'package:triptale/src/services/file_upload_service.dart';

import '../../data/dtos/user_profile_dto.dart';
import '../../data/repository/posts_repo.dart';
import '../../data/repository/user_repository.dart';

class CreatePost extends ConsumerStatefulWidget {
  const CreatePost({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePostState();
}

class _CreatePostState extends ConsumerState<CreatePost> {
  // final ImagePicker _picker = ImagePicker();
  List<File> _images = [];
  List<FilePickerResult?> _filePickerResultList = [];
  // Future<void> _pickImage() async {
  //   final XFile? pickedFile =
  //       await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() => _images.add(File(pickedFile.path)));
  //   }
  // }
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ["jpg", "jpeg", "png"]);
    if (result != null && result.files.single.path != null) {
      File selectedFile = File(result.files.single.path!);
      setState(() {
        _images.add(selectedFile);
        _filePickerResultList.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create post"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: SizedBox()),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(100, 40), // Width: 150, Height: 50
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatepostDescription(
                              images: _images,
                              filePickerResultList: _filePickerResultList),
                        ));
                  },
                  child: Row(
                    children: [Text("next"), Icon(Icons.arrow_forward)],
                  )),
              SizedBox(width: 20)
            ],
          ),
          _images.isEmpty
              ? Expanded(child: Center(child: Text("Add Images")))
              : Expanded(
                  child: GridView.builder(
                    itemCount: _images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (BuildContext context) {
                              return Container(
                                // padding: EdgeInsets.all(16),
                                height: 600,
                                width: double.maxFinite,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // SizedBox(height: 10),
                                    Expanded(
                                        child: Container(
                                      width: double.maxFinite,
                                      child: Image.file(
                                        _images[index],
                                        fit: BoxFit.fill,
                                      ),
                                    )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Close'),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              // _images.remove(_images[index]);
                                              _images.removeAt(index);
                                              setState(() {
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Icon(Icons.delete,
                                                color: Colors.red))
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Image.file(
                            _images[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 40), // Width: 150, Height: 50
            ),
            onPressed: _pickImage,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Add image"),
                Icon(Icons.camera_alt, size: 30, color: Colors.black54),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CreatepostDescription extends ConsumerStatefulWidget {
  final List<File> images;
  List<FilePickerResult?> filePickerResultList;
  CreatepostDescription(
      {required this.images, required this.filePickerResultList});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatepostDescriptionState();
}

class _CreatepostDescriptionState extends ConsumerState<CreatepostDescription> {
  late UserModel? _userProfile;
  final pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  List<Review> _reviews = [];
  @override
  Widget build(BuildContext context) {
    _userProfile = ref.watch(userProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // This removes focus from TextField
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Post New Trip",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 60),
                  height: 250,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: widget.images.length,
                    itemBuilder: (context, i) {
                      return ClipRRect(
                        // borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          widget.images[i], // Replace with actual image URL
                          fit: BoxFit.cover,
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
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextFormField(
                      controller: _experienceController,

                      decoration: InputDecoration(
                        // border: OutlineInputBorder(),
                        border: UnderlineInputBorder(),
                        // border: InputBorder.none,
                        alignLabelWithHint: true,
                        labelText: "Add travel experience...",
                        // floatingLabelBehavior: FloatingLabelBehavior.never,
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "experience required";
                        }
                      },
                      minLines: 2,
                      autofocus: false,
                      maxLines: 3,
                      keyboardType:
                          TextInputType.multiline, // Enables multi-line input
                      textAlignVertical:
                          TextAlignVertical.top, // Aligns text at the top
                    )),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextFormField(
                      controller: _placeController,
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(),
                        border: UnderlineInputBorder(),
                        // border: InputBorder.none,
                        alignLabelWithHint: true,
                        labelText: "Enter place name",
                        // floatingLabelBehavior: FloatingLabelBehavior.never,
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "place name required";
                        }
                      },
                    )),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextFormField(
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(),
                        border: UnderlineInputBorder(),
                        // border: InputBorder.none,
                        alignLabelWithHint: true,
                        labelText: "Pick place location and paste hare",
                        // floatingLabelBehavior: FloatingLabelBehavior.never,
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "place name required";
                        }
                      },
                    )),
                IconButton(onPressed: () {}, icon: Icon(Icons.pin_drop)),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reviews",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            final TextEditingController _typeController =
                                TextEditingController();
                            final TextEditingController _nameController =
                                TextEditingController();
                            final TextEditingController _feedbackController =
                                TextEditingController();

                            double _userRating = 0.0;

                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                double _userRating = 0.0;
                                return Dialog(
                                  child: Container(
                                    height: 400,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Add Reviews",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextFormField(
                                              controller: _typeController,
                                              decoration: InputDecoration(
                                                border: UnderlineInputBorder(),
                                                alignLabelWithHint: true,
                                                labelText:
                                                    "Type (hotel, restaurant, place)",
                                                floatingLabelAlignment:
                                                    FloatingLabelAlignment
                                                        .start,
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a type';
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              controller: _nameController,
                                              decoration: InputDecoration(
                                                border: UnderlineInputBorder(),
                                                alignLabelWithHint: true,
                                                labelText: "Enter name",
                                                floatingLabelAlignment:
                                                    FloatingLabelAlignment
                                                        .start,
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a name';
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              controller: _feedbackController,
                                              decoration: InputDecoration(
                                                border: UnderlineInputBorder(),
                                                alignLabelWithHint: true,
                                                labelText: "Feedback",
                                                floatingLabelAlignment:
                                                    FloatingLabelAlignment
                                                        .start,
                                              ),
                                              minLines: 2,
                                              maxLines: 3,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter feedback';
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Ratings"),
                                                RatingBar.builder(
                                                  minRating: 1,
                                                  maxRating: 5,
                                                  direction: Axis.horizontal,
                                                  itemCount: 5,
                                                  allowHalfRating: true,
                                                  itemBuilder:
                                                      (context, index) => Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (value) {
                                                    _userRating = value;
                                                  },
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                  },
                                                  child: Text("Close"),
                                                ),
                                                SizedBox(width: 10),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      final reviewItem = Review(
                                                          type: _typeController
                                                              .text,
                                                          name: _nameController
                                                              .text,
                                                          rating: _userRating,
                                                          feedback:
                                                              _feedbackController
                                                                  .text
                                                                  .replaceAll(
                                                                      '\n',
                                                                      ' '));
                                                      _reviews.add(reviewItem);
                                                      setState(() {
                                                        Navigator.pop(context);
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                      });
                                                      // Do something with the data
                                                      print(
                                                          "Type: ${_typeController.text}");
                                                      print(
                                                          "Name: ${_nameController.text}");
                                                      print(
                                                          "Feedback: ${_feedbackController.text}");
                                                      print(
                                                          "Rating: $_userRating");
                                                    }
                                                  },
                                                  child: Text("Submit"),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text("add reviews"))
                    ],
                  ),
                ),
                if (_reviews.isEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text("No reviews found. Pleace add reviews"),
                  ),
                for (int index = 0; index < _reviews.length; index++)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Card(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        height: 65,
                        width: double.maxFinite,
                        child: Column(
                          children: [
                            Text(
                              "${_reviews[index].type} : ${_reviews[index].name}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "\"${_reviews[index].feedback}\"",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(overflow: TextOverflow.ellipsis),
                            ),
                            RatingBarIndicator(
                              itemSize: 20.0,
                              rating: _reviews[index].rating,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey2.currentState!.validate()) {
                                  setState(
                                      () => _isLoading = true); // Start loading

                                  List<Media> mediaList = [];
                                  for (int i = 0;
                                      i < widget.filePickerResultList.length;
                                      i++) {
                                    if (widget.filePickerResultList[i] !=
                                        null) {
                                      final res = await uploadToCloudinary(
                                          widget.filePickerResultList[i]);
                                      if (res != null) {
                                        final media =
                                            Media(type: "img", url: res);
                                        mediaList.add(media);
                                      }
                                    }
                                  }

                                  final newPostId = await addNewPost(
                                    userId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    username: _userProfile!.username,
                                    profilePicture: _userProfile!.profileUrl,
                                    placeName: _placeController.text,
                                    lat: 40.7128,
                                    lng: -74.0060,
                                    experience: _experienceController.text,
                                    media: mediaList,
                                    reviews: _reviews,
                                    ref: ref,
                                  );

                                  print("--->$newPostId");

                                  setState(
                                      () => _isLoading = false); // Stop loading
                                  setState(() {
                                    _isLoading = false;
                                    Navigator.pop(context);
                                  });
                                }
                              },
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text("Create Post"),
                      ),
                      // child: ElevatedButton(
                      //     onPressed: () async {
                      //       if (_formKey2.currentState!.validate()) {
                      //         List<Media> mediaList = [];
                      //         for (int i = 0;
                      //             i < widget.filePickerResultList.length;
                      //             i++) {
                      //           if (widget.filePickerResultList[i] != null) {
                      //             final res = await uploadToCloudinary(
                      //                 widget.filePickerResultList[i]);
                      //             if (res != null) {
                      //               final media =
                      //                   Media(type: "img", url: res);
                      //               mediaList.add(media);
                      //             }
                      //           }
                      //         }

                      //         final newPostId = await addNewPost(
                      //           userId:
                      //               FirebaseAuth.instance.currentUser!.uid,
                      //           username:
                      //               _userProfile!.username, //need change
                      //           profilePicture:
                      //               _userProfile!.profileUrl, //need change
                      //           placeName: _placeController.text,
                      //           lat: 40.7128, //need change
                      //           lng: -74.0060, //need change
                      //           experience: _experienceController.text,
                      //           media: mediaList, //need change
                      //           reviews: _reviews,
                      //           ref: ref,
                      //         );
                      //         print("--->$newPostId");
                      //       }
                      //     },
                      //     child: Text("Create Post"))),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
