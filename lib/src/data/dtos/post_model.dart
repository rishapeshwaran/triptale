class TravelPost {
  final String postId;
  final String userId;
  final String username;
  final String profilePicture;
  final String placeName;
  final double lat;
  final double lng;
  final String experience;
  final List<Media> media;
  final DateTime timestamp;
  final int likesCount;
  final bool likedByCurrentUser;
  final List<Comment> comments;
  final List<Review> reviews;

  TravelPost({
    required this.postId,
    required this.userId,
    required this.username,
    required this.profilePicture,
    required this.placeName,
    required this.lat,
    required this.lng,
    required this.experience,
    required this.media,
    required this.timestamp,
    required this.likesCount,
    required this.likedByCurrentUser,
    required this.comments,
    required this.reviews,
  });

  factory TravelPost.fromMap(String postId, Map data) {
    return TravelPost(
      postId: postId,
      userId: data['user']['id'],
      username: data['user']['username'],
      profilePicture: data['user']['profilePicture'],
      placeName: data['location']['placeName'],
      lat: data['location']['coordinates']['lat'],
      lng: data['location']['coordinates']['lng'],
      experience: data['experience'],
      media: (data['media'] as List<dynamic>?)
              ?.map((m) => Media.fromMap(m))
              .toList() ??
          [],
      timestamp: DateTime.parse(data['timestamp']),
      likesCount: data['likesCount'] ?? 0,
      likedByCurrentUser: data['likedByCurrentUser'] ?? false,
      // comments: (data['comments'] as List<dynamic>?)
      //         ?.map((c) => Comment.fromMap(c))
      //         .toList() ??
      //     [],
      comments: (data['comments'] is Map)
          ? (data['comments'] as Map).entries.map((entry) {
              final commentMap = Map<String, dynamic>.from(entry.value);
              if (commentMap['commentId'] == null ||
                  commentMap['commentId'] == "") {
                commentMap['commentId'] = entry.key;
              }
              return Comment.fromMap(commentMap);
            }).toList()
          : [],

      reviews: (data['reviews'] as List<dynamic>?)
              ?.map((r) => Review.fromMap(r))
              .toList() ??
          [],
    );
  }
}

class Media {
  final String type;
  final String url;

  Media({required this.type, required this.url});

  factory Media.fromMap(Map data) {
    return Media(
      type: data['type'],
      url: data['url'],
    );
  }
}

class Comment {
  final String commentId;
  final String userId;
  final String username;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.commentId,
    required this.userId,
    required this.username,
    required this.text,
    required this.timestamp,
  });

  factory Comment.fromMap(Map data) {
    return Comment(
      commentId: data['commentId'],
      userId: data['user']['id'],
      username: data['user']['username'],
      text: data['text'],
      timestamp: DateTime.parse(data['timestamp']),
    );
  }
}

class Review {
  final String type;
  final String name;
  final double rating;
  final String feedback;

  Review({
    required this.type,
    required this.name,
    required this.rating,
    required this.feedback,
  });

  factory Review.fromMap(Map data) {
    return Review(
      type: data['type'],
      name: data['name'],
      rating: (data['rating'] as num).toDouble(),
      feedback: data['feedback'],
    );
  }
}
