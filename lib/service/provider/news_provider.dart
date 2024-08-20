import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/common/config/env.dart';
import 'package:nutritrack/model/news.dart';

class NewsProvider with ChangeNotifier {
  News? _news;
  bool _isLoading = false;
  bool _hasLoadedOnce = false;
  List<Results> _firstGroupNews = [];
  List<Results> _secondGroupNews = [];

  News? get news => _news;
  List<Results> get newsResults => _news?.results ?? [];
  bool get isLoading => _isLoading;
  List<Results> get firstGroupNews => _firstGroupNews;
  List<Results> get secondGroupNews => _secondGroupNews;

  final Dio _dio = Dio();

  final String _url =
      'https://newsdata.io/api/1/news?apikey=${apiKeyNews}&country=id&language=id&category=health';

  Future<void> fetchNews() async {
    if (_hasLoadedOnce) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.get(_url);

      if (response.statusCode == 200) {
        final data = response.data;
        _news = News.fromJson(data);
        _hasLoadedOnce = true;

        // Membagi berita menjadi dua kelompok
        _divideNews();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      print('Error fetching news: $error');
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _divideNews() {
    if (_news?.results != null) {
      List<Results> allNews = _news!.results!;

      // Memastikan kita memiliki setidaknya 40 berita
      if (allNews.length >= 40) {
        _firstGroupNews = allNews.sublist(0, 20);
        _secondGroupNews = allNews.sublist(20, 40);
      } else {
        // Jika kurang dari 40, bagi sebisa mungkin
        int midPoint = allNews.length ~/ 2;
        _firstGroupNews = allNews.sublist(0, midPoint);
        _secondGroupNews = allNews.sublist(midPoint);
      }
    }
  }
}
