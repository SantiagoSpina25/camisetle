class JerseyChallenge {
  final String imagePath;
  final String teamName;
  final int year;
  final DateTime date;

  JerseyChallenge({
    required this.imagePath,
    required this.teamName,
    required this.year,
    required this.date,
  });

  factory JerseyChallenge.fromJson(Map<String, dynamic> json) {
    return JerseyChallenge(
      imagePath: json['imagePath'],
      teamName: json['teamName'],
      year: json['year'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() => {
    'imagePath': imagePath,
    'teamName': teamName,
    'year': year,
    'date': date.toIso8601String(),
  };
}
