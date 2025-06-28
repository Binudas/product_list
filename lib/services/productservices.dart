import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:product_list/models/product.dart';

class ProductService {
  final String _baseUrl = 'https://dummyjson.com/products';
  final Logger _logger = Logger();

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productList = data['products'];
        _logger.d('Fetched ${productList.length} products from API.');
        return productList.map((json) => Product.fromJson(json)).toList();
      } else {
        _logger.e(
          'Failed to load products. Status code: ${response.statusCode}',
        );
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error fetching products: $e');
      throw Exception('Error fetching products: $e');
    }
  }
}
