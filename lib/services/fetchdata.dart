import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:market/models/items.dart';
import 'package:market/models/sellerdetails.dart';

class Fetchdata with ChangeNotifier {
  List<Items> items = [];
  List<Details> sellers = [];
  Future<void> getdata() async {
    items = [];
    const String url =
        'https://market-flutter-f72fc-default-rtdb.firebaseio.com/product.json';
    try {
      final res = await http.get(
        Uri.parse(url),
      );
      if (res.body == 'null') {
        items = [];
        notifyListeners();
      } else if (res.body != 'null') {
        final extractedData = json.decode(res.body) as Map<String, dynamic>;
        extractedData.isEmpty
            ? null
            : extractedData.forEach((key, value) {
                items.add(Items(
                    id: key,
                    title: value['title'],
                    subtitle: value['details'],
                    seens: value['seens'],
                    type: value['field'],
                    city: value['city'],
                    price: value['price'],
                    country: value['country'],
                    date: value['date'],
                    images: value['image'],
                    userid: value['userid']));
              });
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> deletitem(Items it) async {
    final proindex = items.indexWhere((element) => element.id == it.id);

    items.removeAt(proindex);

    final String url =
        'https://market-flutter-f72fc-default-rtdb.firebaseio.com/product/${it.id}.json';
    try {
      await http.delete(
        Uri.parse(url),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updatevews(Items it) async {
    final String url =
        'https://market-flutter-f72fc-default-rtdb.firebaseio.com/product/${it.id}.json';
    try {
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': it.title,
            'field': it.type,
            'city': it.city,
            'country': it.country,
            'price': it.price,
            'image': it.images,
            'details': it.subtitle,
            'seens': ++it.seens,
            'date': it.date,
          }));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getsellerdata() async {
    sellers = [];
    const String url =
        'https://market-flutter-f72fc-default-rtdb.firebaseio.com/sellers.json';
    try {
      final res = await http.get(
        Uri.parse(url),
      );
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      extractedData.forEach((key, value) {
        sellers.add(Details(
          address: value['address'],
          id: value['userid'],
          name: value['name'],
          phonenumber: value['phonenumber'],
        ));
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
