import 'package:flutter/material.dart';
import 'package:app_komik_manga/provider/auth_provider.dart';
import 'package:app_komik_manga/screen/login.dart';
import 'package:app_komik_manga/screen/main_screen.dart';
import 'package:app_komik_manga/screen/search_screen.dart';
import 'package:app_komik_manga/screen/category_screen.dart';
import 'package:app_komik_manga/screen/settings_screen.dart';
import 'package:app_komik_manga/screen/manga_detail_screen.dart';
import 'package:app_komik_manga/screen/manga_chapter_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:app_komik_manga/models/manga_detail.dart';

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
      ],
      child: MaterialApp(
        title: 'Manga App',
        theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.white),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(228, 40, 23, 70),
          ),
          useMaterial3: false,
        ),
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(
              builder: (context) => StreamBuilder(
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
            );
          }
          if (settings.name == 'mangaDetail') {
            final arguments = settings.arguments as Map?;
            if (arguments != null) {
              final mangaDetail = arguments['mangaDetail'] as MangaDetail?;
              final mangaId = arguments['mangaId'] as String?;
              if (mangaDetail != null && mangaId != null) {
                return MaterialPageRoute(
                  builder: (context) => MangaDetailScreen(
                    mangaDetail: mangaDetail,
                    mangaId: mangaId,
                  ),
                );
              }
            }
            // Handle error case if arguments are invalid
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: Text('Error')),
                body: Center(child: Text('Invalid arguments for mangaDetail')),
              ),
            );
          }
          if (settings.name == 'search') {
            return MaterialPageRoute(
              builder: (context) => SearchScreen(
                mangaId: settings.arguments as String,
              ),
            );
          }
          if (settings.name == 'Genres') {
            return MaterialPageRoute(
              builder: (context) => const CategoryScreen(),
            );
          }
          if (settings.name == 'Settings') {
            return MaterialPageRoute(
              builder: (context) => SettingsScreen(),
            );
          }
          if (settings.name == 'mangaChapter') {
            final args = settings.arguments as Map?;
            if (args != null) {
              final mangaId = args['mangaId'] as String?;
              final id = args['id'] as String?;
              if (mangaId != null && id != null) {
                return MaterialPageRoute(
                  builder: (context) => MangaChapterScreen(
                    mangaId: mangaId,
                    id: id,
                  ),
                );
              }
            }
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: Text('Error')),
                body: Center(child: Text('Invalid arguments for mangaChapter')),
              ),
            );
          }

          return null;
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text('Unknown Route')),
              body: Center(child: Text('404 - Page Not Found')),
            ),
          );
        },
      ),
    );
  }
}
