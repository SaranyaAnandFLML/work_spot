class BranchModel {
  final int id;
  final String name;
  final String location;
  final double pricePerHour;
  final String city;
  final String branch;
  final List<String> images;
  final String description;
  final List<String> amenities;
  final String operatingHours;
  final double latitude;    // new
  final double longitude;   // new

  BranchModel({
    required this.id,
    required this.name,
    required this.location,
    required this.pricePerHour,
    required this.city,
    required this.branch,
    required this.images,
    required this.description,
    required this.amenities,
    required this.operatingHours,
    required this.latitude,    // new
    required this.longitude,   // new
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      pricePerHour: (json['price_per_hour'] as num).toDouble(),
      city: json['city'],
      branch: json['branch'],
      images: List<String>.from(json['images']),
      description: json['description'],
      amenities: List<String>.from(json['amenities']),
      operatingHours: json['operating_hours'],
      latitude: (json['latitude'] as num).toDouble(),    // new
      longitude: (json['longitude'] as num).toDouble(),  // new
    );
  }
}
