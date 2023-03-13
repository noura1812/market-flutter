// ignore_for_file: public_member_api_docs, sort_constructors_first

class Items {
  String userid;
  String id;
  String title;
  String subtitle;
  int seens;
  String type;
  String country;
  String price;
  String city;
  String date;
  List images;
  Items({
    required this.userid,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.seens,
    required this.type,
    required this.city,
    required this.price,
    required this.country,
    required this.date,
    required this.images,
  });
}
