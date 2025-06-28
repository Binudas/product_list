
import 'package:flutter/material.dart';
import 'package:product_list/models/product.dart';
import 'package:product_list/providers/productprovider.dart';
import 'package:product_list/providers/themeprovider.dart';
import 'package:product_list/screens/productlistingscreens.dart';
import 'package:product_list/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(ProductAdapter());
    logger.d('Hive initialized successfully at: ${appDocumentDir.path}');
  } catch (e) {
    logger.e('Failed to initialize Hive: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = ThemeProvider();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _themeProvider.setInitialTheme(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeProvider), 
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {

          final isLightMode = themeProvider.themeMode == ThemeMode.light;
          final buttonIcon = isLightMode ? Icons.light_mode : Icons.dark_mode;

          return MaterialApp(
            title: 'Product App',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const ProductListingScreen(),
          );
        },
      ),
    );
  }
}