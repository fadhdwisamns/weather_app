
class Weather {
  final String time;
  final String description;
  final String temperature;

  Weather({
    required this.time,
    required this.description,
    required this.temperature,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      time: json['jamCuaca'],
      description: json['cuaca'],
      temperature: json['tempC'] + "°C",
    );
  }
}
