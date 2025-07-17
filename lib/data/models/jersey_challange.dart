class JerseyChallenge {
  final String imageUrl;
  final String teamName;
  final int year;
  final String date;

  JerseyChallenge({
    required this.imageUrl,
    required this.teamName,
    required this.year,
    required this.date,
  });

  factory JerseyChallenge.fromFirestore(Map<String, dynamic> json) {
    return JerseyChallenge(
      teamName: json['teamName'],
      year: json['year'],
      date: json['teamName'],
      imageUrl: json['imageUrl'],
    );
  }
}
