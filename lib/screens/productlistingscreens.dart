
import 'package:flutter/material.dart';
import 'package:product_list/providers/productprovider.dart';
import 'package:product_list/providers/themeprovider.dart';
import 'package:product_list/widget/productitem.dart';
import 'package:provider/provider.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({Key? key}) : super(key: key);

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).refreshProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
             
              final bool willBeLightMode =
                  themeProvider.themeMode ==
                  ThemeMode.dark; 
              final String nextThemeName = willBeLightMode ? 'Light' : 'Dark';
              final IconData nextThemeIcon =
                  willBeLightMode
                      ? Icons.light_mode
                      : Icons.dark_mode; 

              return IconButton(
                icon: Icon(
                  nextThemeIcon,
                ), 
                onPressed: () {
                  themeProvider.toggleTheme();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Switched to $nextThemeName Mode'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productProvider.errorMessage != null &&
              productProvider.products.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      productProvider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => productProvider.refreshProducts(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              if (productProvider.isOffline)
                Container(
                  width: double.infinity,
                  color: Colors.orange.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, color: Colors.orange[800]),
                      const SizedBox(width: 8),
                      Text(
                        'Offline Mode',
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: productProvider.refreshProducts,
                  child:
                      productProvider.products.isEmpty
                          ? const Center(child: Text('No products available.'))
                          : ListView.builder(
                            itemCount: productProvider.products.length,
                            itemBuilder: (context, index) {
                              final product = productProvider.products[index];
                              return ProductListItem(product: product);
                            },
                          ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
