class Track {
  final String id;
  final String name;
  final String path;

  Track({
    required this.id,
    required this.name,
    required this.path,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'path': path,
      };

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        id: json['id'],
        name: json['name'],
        path: json['path'],
      );
}
