
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:product_list/models/product.dart';
import 'package:product_list/services/productservices.dart';
import 'package:product_list/utils/conectivityservices.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isOffline = false;

  final ProductService _productService = ProductService();
  final ConnectivityService _connectivityService = ConnectivityService();
  final Logger _logger = Logger();

  static const String _productBoxName = 'products'; 

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isOffline => _isOffline;

  ProductProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadProductsFromHive(); 
    _listenToConnectivityChanges();
    await _fetchAndSyncProducts(); 
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setOfflineStatus(bool status) {
    if (_isOffline != status) {
      _isOffline = status;
      notifyListeners();
    }
  }

  Future<void> _loadProductsFromHive() async {
    _logger.d('Attempting to load products from Hive...');
    try {
      final box = await Hive.openBox<Product>(_productBoxName);
      if (box.isNotEmpty) {
        _products = box.values.toList();
        _logger.d('Loaded ${_products.length} products from Hive.');
        notifyListeners();
      } else {
        _logger.d('Hive product box is empty.');
      }
    } catch (e) {
      _logger.e('Error loading products from Hive: $e');
      _setError('Failed to load local data: $e');
    }
  }

  Future<void> _saveProductsToHive(List<Product> productsToSave) async {
    _logger.d(
      'Attempting to save ${productsToSave.length} products to Hive...',
    );
    try {
      final box = await Hive.openBox<Product>(_productBoxName);
      await box.clear(); 
      for (var product in productsToSave) {
        await box.put(product.id, product); 
      }
      _logger.d('Successfully saved products to Hive.');
    } catch (e) {
      _logger.e('Error saving products to Hive: $e');
      _setError('Failed to save data locally: $e');
    }
  }

  Future<void> _fetchAndSyncProducts() async {
    _setLoading(true);
    _setError(null);

    bool isConnected = await _connectivityService.isConnected();
    _setOfflineStatus(!isConnected); 

    if (isConnected) {
      _logger.d('Device is online. Attempting to fetch from API.');
      try {
        final fetchedProducts = await _productService.fetchProducts();
        if (fetchedProducts.isNotEmpty) {
          _products = fetchedProducts;
          await _saveProductsToHive(
            fetchedProducts,
          ); 
          _logger.d(
            'Successfully fetched and synced ${fetchedProducts.length} products.',
          );
        }
      } catch (e) {
        _logger.e(
          'Failed to fetch from API, falling back to Hive (if available): $e',
        );
        _setError('Could not fetch latest data. Showing offline data.');
       
        if (_products.isEmpty) {
          await _loadProductsFromHive(); 
        }
      }
    } else {
      _logger.d('Device is offline. Displaying products from Hive.');
      _setError('You are offline. Showing cached data.');
     
    }
    _setLoading(false);
  }

  void _listenToConnectivityChanges() {
    _connectivityService.connectivityStream.listen((
      List<ConnectivityResult> results,
    ) async {
      final bool wasOffline = _isOffline; 
      bool nowConnected =
          results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.ethernet);

      _logger.d(
        'Connectivity changed: ${results.first}. Now connected: $nowConnected',
      );

      _setOfflineStatus(!nowConnected);

      if (nowConnected && wasOffline) {
        _logger.i('Device just came online. Initiating data sync.');
       
        await _fetchAndSyncProducts();
        _setError(null); 
      }
    });
  }

  
  Future<void> refreshProducts() async {
    await _fetchAndSyncProducts();
  }
}
