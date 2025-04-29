import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/dtos/user_profile_dto.dart';
import '../../data/repository/user_repository.dart';
import '../../services/file_upload_service.dart';

class EditProfile extends ConsumerStatefulWidget {
  final String email;
  final String password;
  EditProfile({super.key, required this.email, required this.password});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  FilePickerResult? _filePickerResultList;
  final ImagePicker _picker = ImagePicker();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  bool _isLoading = false; // <-- Spinner state

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<String?> createUserWithEmailPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: widget.email.trim(), password: widget.password.trim());
      print(userCredential);
      return FirebaseAuth.instance.currentUser!.uid;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "An unknown error occurred."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
      return null;
    }
  }

  void _validateForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Show loader
      // await uploadUserData();
      final uid = await createUserWithEmailPassword();
      if (uid != null) {
        final imgurl = await uploadToCloudinary(_filePickerResultList);
        UserModel newUser = UserModel(
          bio: _bioController.text,
          createdAt: DateTime.now(),
          dob: _dateController.text,
          email: widget.email,
          name: _usernameController.text,
          profileUrl: imgurl ?? "",
          uid: uid,
          username: _usernameController.text,
        );

        final res = await addUserToFirestore(newUser, ref);
        if (res) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(""),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
        }

        setState(() => _isLoading = false);
      }
      // Hide loader
    }
  }

  // Future<void> _pickImage() async {
  //   final XFile? pickedFile =
  //       await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() => _image = File(pickedFile.path));
  //   }
  // }
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ["jpg", "jpeg", "png", "mp4"]);
    if (result != null && result.files.single.path != null) {
      File selectedFile = File(result.files.single.path!);
      setState(() {
        _image = selectedFile;
        _filePickerResultList = result;
      });
    }
  }

  // Future<void> uploadUserData() async {
  //   try {
  //     await FirebaseFirestore.instance.collection("userprofile").add({
  //       "uid": FirebaseAuth.instance.currentUser!.uid,
  //       "name": _usernameController.text,
  //       "username": _usernameController.text,
  //       "email": FirebaseAuth.instance.currentUser!.email,
  //       "bio": _bioController.text,
  //       "dob": _dateController.text,
  //       "created at": DateTime.now()
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Profile Updated Successfully!")),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to update profile: $e")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Create Profile")),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: double.maxFinite,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 50),
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                labelText: "User Name",
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Username is required";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _bioController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: "Bio",
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _dateController,
                              decoration: InputDecoration(
                                labelText: "Date of Birth",
                                suffixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              readOnly: true,
                              onTap: () => _selectDate(context),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Date selection is required";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: double.maxFinite,
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        _validateForm();
                                      },
                                child: Text("Save Changes"),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: (MediaQuery.of(context).size.width - 110) / 2,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(60),
                        onTap: _pickImage,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              border:
                                  Border.all(color: Colors.black12, width: 2),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: _image == null
                                ? Icon(Icons.camera_alt,
                                    size: 50, color: Colors.black54)
                                : Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isLoading) // Overlay spinner
            Container(
              color: Colors.black45,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}



// git remote set-url origin https://<TOKEN>@github.com/<user_name or organization_name>/<repo_name>.git
