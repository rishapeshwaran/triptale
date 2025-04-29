import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:triptale/src/presentation/home/home_page.dart';
import 'package:triptale/src/presentation/user_auth/sign_up.dart';
import '../splash_screen.dart';
import 'presentation/trips/favorite_trips.dart';
import 'presentation/user_auth/edit_profile.dart';
import 'presentation/user_auth/signin.dart';
import 'services/app_theme.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    print("==>" + FirebaseAuth.instance.currentUser.toString());
    print(FirebaseAuth.instance.currentUser);
    ColorScheme colorScheme =
        ColorScheme.fromSeed(seedColor: Colors.deepPurple);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // colorScheme: colorScheme,
          useMaterial3: true,
          textTheme:
              _getTextTheme(AppFontsType.openSans, colorScheme.onSurface),
        ),
        // home: TravelPostPage());
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data != null) {
              return const SplashScreen();
            }
            return const SplashScreen1();
          },
        ));
    // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    // home:
    //     FirebaseAuth.instance.currentUser != null ? HomePage() : SignUp());
  }

  TextTheme _getTextTheme(AppFontsType appFont, Color colorsText) {
    TextTheme textTheme = Theme.of(context).textTheme.copyWith(
          bodyLarge: TextStyle(color: colorsText),
          bodyMedium: TextStyle(color: colorsText),
          bodySmall: TextStyle(color: colorsText),
          displayLarge: TextStyle(color: colorsText),
          displaySmall: TextStyle(color: colorsText),
          displayMedium: TextStyle(color: colorsText),
          headlineLarge: TextStyle(color: colorsText),
          headlineMedium: TextStyle(color: colorsText),
          headlineSmall: TextStyle(color: colorsText),
          labelLarge: TextStyle(color: colorsText),
          labelMedium: TextStyle(color: colorsText),
          labelSmall: TextStyle(color: colorsText),
          titleLarge: TextStyle(color: colorsText),
          titleMedium: TextStyle(color: colorsText),
          titleSmall: TextStyle(color: colorsText),
        );
    switch (appFont) {
      case AppFontsType.openSans:
        return GoogleFonts.openSansTextTheme(textTheme);
      case AppFontsType.roboto:
        return GoogleFonts.robotoTextTheme(textTheme);
      case AppFontsType.robotoCondensed:
        return GoogleFonts.robotoCondensedTextTheme(textTheme);
      case AppFontsType.lato:
        return GoogleFonts.latoTextTheme(textTheme);
    }
  }
}

//
//
//
//
//
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => EditProfile(),
            //           ));
            //     },
            //     child: Text("Edit profile")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoriteTrips(),
                      ));
                },
                child: Text("Favorite Trips")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Signin(),
                      ));
                },
                child: Text("Sign In")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ));
                },
                child: Text("Home Page"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
