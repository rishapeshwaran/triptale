import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<String?> uploadToCloudinary(FilePickerResult? filePickerResult) async {
  if (filePickerResult == null || filePickerResult.files.isEmpty) {
    print("No file selected");
    return null;
  }

  File file = File(filePickerResult.files.single.path!);
  String cloudname = dotenv.env['CLOUDINERY_CLOUD_NAME'] ?? '';

  var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudname/raw/upload");
  var request = http.MultipartRequest("POST", uri);

  var fileBytes = await file.readAsBytes();
  var multiportfile = http.MultipartFile.fromBytes(
    'file',
    fileBytes,
    filename: file.path.split("/").last,
  );

  request.files.add(multiportfile);
  request.fields['upload_preset'] = "triptale";
  request.fields['resource_type'] = "raw";

  var response = await request.send();
  var responseBody = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    print("uploaded successfully");
    print(responseBody);
    var jsonResponse = json.decode(responseBody);
    String secureUrl = jsonResponse['secure_url'];
    print("Secure URL: $secureUrl");
    return secureUrl;
  } else {
    print("uploaded unsuccessfully");
    print(response.statusCode);
    print(responseBody);
    return null;
  }
}
