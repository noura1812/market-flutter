import 'package:flutter/material.dart';
import 'package:market/models/countries.dart';
import 'package:market/services/theme.dart';
import 'package:market/widgets/listvew.dart';

class Country extends StatefulWidget {
  const Country({super.key});

  @override
  State<Country> createState() => _CountryState();
}

class _CountryState extends State<Country> {
  List<Counrties> counrties = [
    Counrties(name: 'Canada', short: 'ca'),
    Counrties(name: 'Egypt', short: 'eg'),
    Counrties(name: 'Iraq', short: 'iq'),
    Counrties(name: 'Jordan', short: 'jo'),
    Counrties(name: 'Lebanon', short: 'lb'),
    Counrties(name: 'Libya', short: 'ly'),
    Counrties(name: 'Oman', short: 'om'),
    Counrties(name: 'Palestine', short: 'ps'),
    Counrties(name: 'Qatar', short: 'qa'),
    Counrties(name: 'Saudi Arabia', short: 'sa'),
    Counrties(name: 'Sudan', short: 'sd'),
    Counrties(name: 'Syria', short: 'sy'),
    Counrties(name: 'Tunisia', short: 'tn'),
    Counrties(name: 'Turkey', short: 'tr'),
    Counrties(name: 'United States of America', short: 'us'),
    Counrties(name: 'Yemen', short: 'ye'),
    Counrties(name: 'Vietnam', short: 'vn'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: base1,
        appBar: AppBar(
          backgroundColor: base2,
          iconTheme: const IconThemeData(color: base4),
          title: Text(
            'Choose your country',
            style: headingstyle,
          ),
        ),
        body: ListView_drow(list: counrties, num: 1));
  }
}
