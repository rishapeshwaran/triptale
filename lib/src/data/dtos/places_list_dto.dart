class Place {
  int? placeId;
  String? name;
  String? description;
  String? country;
  String? city;
  String? category;
  int? categoryId;
  List<PlaceImage>? images;
  Location? location;
}

class PlaceImage {
  int? imageId;
  String? imageUrl;
  PlaceImage({
    this.imageId,
    this.imageUrl,
  });
}

class Location {
  double? latitude;
  double? longitude;
  Location({
    this.latitude,
    this.longitude,
  });
}
