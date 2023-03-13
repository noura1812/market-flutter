import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:market/screens/additem.dart';
import 'package:market/services/auth.dart';
import 'package:market/services/fetchdata.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:market/screens/aboutapp.dart';
import 'package:market/screens/category.dart';
import 'package:market/screens/choose_country.dart';
import 'package:market/screens/home.dart';
import 'package:market/screens/itemdetails.dart';
import 'package:market/services/theme.dart';
import 'package:market/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? country = pref.getString('C');

  runApp(country != null
      ? MultiProvider(
          providers: [
            ChangeNotifierProvider<Auth>(create: (_) => Auth()),
            ChangeNotifierProvider<Fetchdata>(create: (_) => Fetchdata())
          ],
          child: MyApp(
            country: country,
          ),
        )
      : const MaterialApp(
          home: Country(),
        ));
}

class MyApp extends StatelessWidget {
  String country;
  MyApp({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'hom': ((context) => Home(
              country: country,
            )),
        'choose': ((context) => const Country()),
        'category': ((context) => Category_screen()),
        'aboutapp': ((context) => const About()),
        'itemdetails': ((context) => const ItemDetails()),
        'additem': ((context) => AddItems())
      },
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      home: Home(
        country: country,
      ),
    );
  }
}
