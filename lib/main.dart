import 'package:app_komik_manga/provider/auth_provider.dart';
import 'package:app_komik_manga/provider/image_pick_provider.dart';
import 'package:app_komik_manga/screen/login.dart';
import 'package:app_komik_manga/screen/main_screen.dart';
import 'package:app_komik_manga/screen/search_screen.dart';
import 'package:app_komik_manga/screen/category_screen.dart';
import 'package:app_komik_manga/screen/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:app_komik_manga/models/manga_detail.dart';
import 'package:app_komik_manga/screen/manga_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyAuthProvider()),
        ChangeNotifierProvider(create: (_) => ImagePickProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.white),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(228, 40, 23, 70),
          ),
          useMaterial3: false,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return const MainScreen();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('An error occurred!'));
                  } else {
                    return const LoginScreen();
                  }
                },
              ),
          '/home': (context) => const MainScreen(),
          'mangaDetail': (context) {
            final mangaDetail =
                ModalRoute.of(context)!.settings.arguments as MangaDetail;
            return MangaDetailScreen(mangaDetail: mangaDetail);
          },
          'search': (context) => const SearchScreen(),
          'Genres': (context) => const CategoryScreen(),
          'Settings': (context) => SettingsScreen(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
              builder: (context) => Scaffold(
                    appBar: AppBar(title: Text('Unknown Route')),
                    body: Center(child: Text('404 - Page Not Found')),
                  ));
        },
      ),
    );
  }
}
