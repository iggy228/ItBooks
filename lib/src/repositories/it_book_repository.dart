import 'package:dio/dio.dart';
import 'package:it_book/src/models/book.dart';

class ItBookRepository {
  final baseUrl = 'https://api.itbook.store/1.0/';

  Future<List<Book>?> getBooks(String search) async {
    try {
      final Response<Map<String, dynamic>> response =
          await Dio().get('$baseUrl/search/$search');
      return response.data?['books']
          .map<Book>((element) => Book.fromMap(element))
          .toList();
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }
}
