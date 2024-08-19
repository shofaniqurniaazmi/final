import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/common/config/env.dart';
import 'package:nutritrack/model/news.dart';

class NewsProvider with ChangeNotifier {
  List<Results> _newsResults = [];
  bool _isLoading = false;

  List<Results> get newsResults => _newsResults;
  bool get isLoading => _isLoading;

  final Dio _dio = Dio();

  // const newsURL = "https://newsdata.io/api/1/news?apikey=pub_512145b24e23ed26e817e4017220145129057&country=id&language=id&category=health"; //full

  // final String _apiKey = 'YOUR_API_KEY_HERE'; // Replace with your API key
  final String _url = 'https://newsdata.io/api/1/news?apikey=${apiKeyNews}&country=id&language=id&category=health';

  Future<void> fetchNews() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.get(
        _url,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final news = News.fromJson(data);
        _newsResults = news.results ?? [];
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      print(error);
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
