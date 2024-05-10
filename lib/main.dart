import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knack/bloc/fetch_bloc/bloc/fetch_course_bloc.dart';
import 'package:knack/data/repositories/course_repo.dart';
import 'package:knack/data/repositories/user_repo.dart';
import 'package:knack/firebase_options.dart';

import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/screens/main_page.dart';
import 'package:knack/presentation/view/screens/splash/splash1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FetchCourseBloc(CourseRepo(), UserRepo()),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: g,
            colorScheme: ColorScheme(
                brightness: Brightness.light,
                primary: g,
                onPrimary: Color.fromARGB(255, 255, 255, 255),
                secondary: g,
                onSecondary: Color.fromARGB(255, 255, 255, 255),
                error: Colors.red,
                onError: const Color.fromARGB(255, 255, 17, 0),
                background: Color.fromARGB(255, 255, 255, 255),
                onBackground: Colors.grey,
                surface: g,
                onSurface: const Color.fromARGB(255, 255, 255, 255)),
            useMaterial3: false),
        debugShowCheckedModeBanner: false,
        title: 'Knack',
        home: SplashScreen(),
      ),
    );
  }
}
