class Job {
  final int id;
  final String title;
  final String description;
  final String vendorId;
  final String contact;
  final String imageUrl;
  final double rate;
  final double lat;
  final double lng;
  final String locationName;
  final String category; // matches DB column

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.vendorId,
    required this.contact,
    required this.imageUrl,
    required this.rate,
    required this.lat,
    required this.lng,
    required this.locationName,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'vendorId': vendorId,
      'contact': contact,
      'imageUrl': imageUrl,
      'rate': rate,
      'lat': lat,
      'lng': lng,
      'locationName': locationName,
      'category': category,
    };
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      vendorId: map['vendorId'] ?? '',
      contact: map['contact'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      rate: (map['rate'] ?? 0).toDouble(),
      lat: (map['lat'] ?? 0).toDouble(),
      lng: (map['lng'] ?? 0).toDouble(),
      locationName: map['locationName'] ?? '',
      category: map['category'] as String,
    );
  }
}
