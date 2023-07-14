import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const API_URL = 'https://zenquotes.io/api/quotes';

class Quotes with ChangeNotifier {
  Quotes(this.quote, this.author, this.isFavorite);
  String quote;
  String author;

  bool isFavorite;

  void toggleFavorites() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}

class QuotesData with ChangeNotifier {
  var _loadedQuotes = <Quotes>[];
  List<Quotes> get loadedQuotes => [..._loadedQuotes];

  // static Future<Quotes> quoteOfTheDay() async {
  //   try {
  //     const url = 'https://zenquotes.io/api/today';
  //     final response = await http.get(Uri.parse(url));
  //     final mapResponse = jsonDecode(response.body);
  //     return Quotes(mapResponse[0]['q'], mapResponse[0]['a']);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  List<Quotes> fetchFavorites() {
    final onlyFavs =
        _loadedQuotes.where((element) => element.isFavorite == true).toList();
    return onlyFavs;
  }

  Future<void> fetchQuotes() async {
    try {
      final response = await http.get(Uri.parse(API_URL));
      final mappedResult = jsonDecode(response.body) as List;
      final tempHolder = <Quotes>[];
      for (var element in mappedResult) {
        tempHolder.add(
          Quotes(element['q'], element['a'], false),
        );
      }
      _loadedQuotes = tempHolder;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchMore() async {
    try {
      final response = await http.get(Uri.parse(API_URL));
      final mappedResult = jsonDecode(response.body) as List;
      final tempHolder = <Quotes>[];
      for (var element in mappedResult) {
        tempHolder.add(
          Quotes(element['q'], element['a'], false),
        );
      }
      _loadedQuotes.addAll(tempHolder);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
