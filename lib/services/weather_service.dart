
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  final String baseUrl = "https://data.bmkg.go.id/prakiraan-cuaca/";

  Future<List<Weather>> fetchWeather(String location) async {
    final response = await http.get(Uri.parse('$baseUrl$location.json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> hourlyForecast = data['data']['forecast']['hourly'];
      return hourlyForecast.map((json) => Weather.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
