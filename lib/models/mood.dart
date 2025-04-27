import 'track.dart';

class Mood {
  final String name;
  final String iconPath;
  final List<Track> tracks;
  double volume;

  Mood({
    required this.name,
    required this.iconPath,
    required this.tracks,
    required this.volume,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'iconPath': iconPath,
        'volume': volume,
        'tracks': tracks.map((t) => t.toJson()).toList(),
      };

  factory Mood.fromJson(Map<String, dynamic> json) => Mood(
        name: json['name'],
        iconPath: json['iconPath'],
        volume: json['volume'],
        tracks: (json['tracks'] as List).map((e) => Track.fromJson(e)).toList(),
      );
}
