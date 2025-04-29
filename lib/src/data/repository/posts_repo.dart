import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dtos/post_model.dart';

// class TravelPostService {
final DatabaseReference _ref = FirebaseDatabase.instance.ref('travelPosts');

// Future<List<TravelPost>> fetchPostsExcludingUser(String excludedUserId) async {
//   final snapshot = await _ref.get();

//   if (snapshot.exists) {
//     final data = snapshot.value as Map;
//     return data.entries
//         .map((e) =>
//             TravelPost.fromMap(e.key, Map<String, dynamic>.from(e.value)))
//         .where((post) => post.userId != excludedUserId)
//         .toList();
//   } else {
//     return [];
//   }
// }
List<TravelPost> getUserPostsByUid(WidgetRef ref, String uid) {
  final allPosts = ref.read(allPostsProvider);
  return allPosts.where((post) => post.userId == uid).toList();
}

void fetchPostList(WidgetRef ref) async {
  List<TravelPost> _posts = [];

  final snapshot = await FirebaseDatabase.instance.ref('travelPosts').get();

  if (!snapshot.exists) {
    print("⚠️ No posts found.");
    return;
  }

  final data = snapshot.value;

  if (data is List) {
    for (int i = 0; i < data.length; i++) {
      final item = data[i];

      if (item == null) {
        print("⚠️ Null item at index $i");
        continue;
      }

      if (item is Map) {
        try {
          final post =
              TravelPost.fromMap(i.toString(), Map<String, dynamic>.from(item));
          _posts.add(post);
        } catch (e, stack) {
          print("❌ Error parsing item at index $i: $e");
          print(stack);
        }
      } else {
        print("⚠️ Skipped non-map item at index $i: $item");
      }
    }
  } else if (data is Map) {
    data.forEach((key, value) {
      if (value == null) return;

      if (value is Map) {
        try {
          final post = TravelPost.fromMap(
              key.toString(), Map<String, dynamic>.from(value));
          _posts.add(post);
        } catch (e, stack) {
          print("❌ Error parsing post with key $key: $e");
          print(stack);
        }
      } else {
        print("⚠️ Skipped non-map item with key $key: $value");
      }
    });
  } else {
    print("❌ Unsupported data format at root level.");
  }

  ref.read(allPostsProvider.notifier).state = _posts;
}

// Future<void> addCommentToPost({
//   required String postId,
//   required String userId,
//   required String username,
//   required String text,
// }) async {
//   final databaseRef = FirebaseDatabase.instance.ref();
//   // final commentRef = FirebaseDatabase.instance
//   //     .ref('travelPosts/t1001/comments')
//   //     .push(); // generates unique commentId

//   // final commentId = commentRef.key!;
//   final timestamp = DateTime.now();

//   final commentData = {
//     'commentId': "",
//     'user': {
//       'id': userId,
//       'username': username,
//     },
//     'text': text,
//     'timestamp': timestamp.toIso8601String(),
//   };

//   databaseRef.child('travelPosts/$postId/comments').push().set(commentData);
//   // await commentRef.set(commentData);
// }

Future<void> addComment({
  required String postId,
  required String userId,
  required String username,
  required String text,
}) async {
  try {
    final commentRef = FirebaseDatabase.instance
        .ref("travelPosts/$postId/comments")
        .push(); // 🔑 generates a unique key

    final commentId = commentRef.key;

    final commentData = {
      "commentId": commentId,
      "text": text,
      "timestamp": DateTime.now().toIso8601String(),
      "user": {
        "id": userId,
        "username": username,
      }
    };

    await commentRef.set(commentData);

    print("✅ Comment added with ID: $commentId");
  } catch (e) {
    print("❌ Failed to add comment: $e");
  }
}

// }

final allPostsProvider = StateProvider<List<TravelPost>>((ref) {
  return [];
});

// 🔹 StateProvider to get a single post by postId
final singlePostProvider = Provider.family<TravelPost?, String>((ref, postId) {
  final posts = ref.watch(allPostsProvider);
  return posts.firstWhere(
    (post) => post.postId == postId,
    //orElse: () => null,
  );
});

Future<String> addNewPost({
  required String userId,
  required String username,
  required String profilePicture,
  required String placeName,
  required double lat,
  required double lng,
  required String experience,
  required List<Media> media,
  List<Review>? reviews,
  required WidgetRef ref,
}) async {
  // Create a reference to the Firebase database
  final postRef = FirebaseDatabase.instance.ref('travelPosts').push();

  // Generate a new unique key
  final String postId =
      postRef.key ?? DateTime.now().millisecondsSinceEpoch.toString();

  // Create the post object
  final newPost = TravelPost(
    postId: postId,
    userId: userId,
    username: username,
    profilePicture: profilePicture,
    placeName: placeName,
    lat: lat,
    lng: lng,
    experience: experience,
    media: media,
    timestamp: DateTime.now(),
    likesCount: 0,
    likedByCurrentUser: false,
    comments: [],
    reviews: reviews ?? [],
  );

  // Convert to a map for Firebase
  final Map<String, dynamic> postData = {
    'user': {
      'id': userId,
      'username': username,
      'profilePicture': profilePicture,
    },
    'location': {
      'placeName': placeName,
      'coordinates': {
        'lat': lat,
        'lng': lng,
      },
    },
    'experience': experience,
    'media': media
        .map((m) => {
              'type': m.type,
              'url': m.url,
            })
        .toList(),
    'timestamp': DateTime.now().toIso8601String(),
    'likesCount': 0,
    'likedByCurrentUser': false,
    'comments': [],
    'reviews': (reviews ?? [])
        .map((r) => {
              'type': r.type,
              'name': r.name,
              'rating': r.rating,
              'feedback': r.feedback,
            })
        .toList(),
  };

  // Save to Firebase
  await postRef.set(postData);

  // Update the provider with the new post
  final currentPosts = ref.read(allPostsProvider);
  ref.read(allPostsProvider.notifier).state = [...currentPosts, newPost];

  return postId;
}
