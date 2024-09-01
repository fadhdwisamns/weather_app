import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService weatherService = WeatherService();
  List<Weather> _weatherList = [];
  bool _isLoading = false;
  String _location = 'jakarta';

  void _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weatherList = await weatherService.fetchWeather(_location);
      setState(() {
        _weatherList = weatherList;
      });
    } catch (e) {
      print('Failed to load weather data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _location,
            items: <String>['jakarta', 'bandung', 'surabaya'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.toUpperCase()),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _location = newValue!;
                _fetchWeather();
              });
            },
          ),
          Expanded(
            child: _isLoading
                ? Center(child: SpinKitFadingCircle(color: Colors.blue, size: 50.0))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _weatherList.length,
                    itemBuilder: (context, index) {
                      final weather = _weatherList[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(weather.time),
                              SizedBox(height: 8.0),
                              Text(weather.description),
                              SizedBox(height: 8.0),
                              Text(weather.temperature),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
