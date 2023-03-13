import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:market/services/theme.dart';
import 'package:market/widgets/dialog.dart';
import 'package:market/widgets/input_field.dart';
import 'package:market/widgets/size_configs.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as p;

class AddItems extends StatefulWidget {
  AddItems({super.key});

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  final TextEditingController _titlecontroler = TextEditingController();

  String category = '';
  final List<String> Categories = [
    'Cars and motors',
    'Computers',
    'Phones',
    'Games',
    'Animals',
    'Furniture'
  ];
  List<XFile> images = [];

  final TextEditingController _city = TextEditingController();

  final TextEditingController _price = TextEditingController();

  final TextEditingController _details = TextEditingController();

  bool _isloading = false;
  bool added = true;
  StateSetter? _setState;

  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    String country = arg['country']!;
    SizeConfig().init(context);
    final userid = arg['userid'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add item'),
        iconTheme: const IconThemeData(color: base4),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(color: base),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    InputField(
                      controller: _titlecontroler,
                      title: 'Title',
                      hint: 'enter title',
                      width: true,
                    ),
                    dropdowbutton('Category', category, Categories),
                    InputField(
                      title: 'City',
                      hint: 'enter city',
                      width: true,
                      controller: _city,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: InputField(
                          title: 'Price',
                          hint: 'enter price',
                          width: true,
                          controller: _price,
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 15),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: base2),
                              onPressed: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context, state) {
                                          _setState = state;

                                          return imagesdialog(context);
                                        },
                                      );
                                    });
                              },
                              child: const Icon(
                                Icons.add_photo_alternate,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                    InputField(
                      title: 'Details',
                      hint: 'enter detaills',
                      controller: _details,
                      width: true,
                      hight: 140,
                    ),
                    Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(100)),
                      child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(backgroundColor: base2),
                          onPressed: () {
                            if (_titlecontroler.text.isEmpty ||
                                _city.text.isEmpty ||
                                _details.text.isEmpty ||
                                category == '') {
                              Fluttertoast.showToast(
                                  msg: "Pleas enter all Fields!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: base,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              setState(() {
                                _isloading = true;
                              });
                              additem(country, userid!).catchError((error) {
                                setState(() {
                                  added = false;
                                });
                                return showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomDialog(
                                          missage:
                                              'An error ocurred!,pleas try again later',
                                        ));
                              }).then((value) {
                                added
                                    ? Fluttertoast.showToast(
                                        msg: "Item was added!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: base2.withOpacity(.7),
                                        textColor: Colors.white,
                                        fontSize: 16.0)
                                    : null;
                                setState(() {
                                  _isloading = false;
                                });
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'ADD',
                              style: headingstyle,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future additem(String country, String userid) async {
    const String url =
        'https://market-flutter-f72fc-default-rtdb.firebaseio.com/product.json';
    try {
      List<String> imageUrls = await Future.wait(
          images.map((_image) => uploadFile(File(_image.path))));

      await http.post(Uri.parse(url),
          body: json.encode({
            'userid': userid,
            'title': _titlecontroler.text,
            'field': category,
            'city': _city.text,
            'country': country,
            'price': _price.text,
            'image': imageUrls,
            'details': _details.text,
            'seens': 0,
            'date': DateFormat("dd-MM-yyyy").format(DateTime.now()),
          }));
    } catch (error) {
      throw error;
    }
  }

  InputField dropdowbutton(String title, item, list) {
    return InputField(
        title: title,
        width: true,
        hint: category == '' ? 'enter $title' : category,
        widget: Row(
          children: [
            DropdownButton(
                borderRadius: BorderRadius.circular(10),
                dropdownColor: base2.withOpacity(.8),
                items: list.map<DropdownMenuItem<String>>((e) {
                  return DropdownMenuItem<String>(
                      value: e.toString(),
                      child: Text(
                        '$e',
                        style: bodystyle.apply(color: base4),
                      ));
                }).toList(),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: base5,
                ),
                elevation: 4,
                style: bodystyle.apply(color: base5, fontSizeDelta: -3),
                underline: Container(
                  height: 0,
                ),
                onChanged: (val) {
                  setState(() {
                    category = val.toString();
                  });
                }),
          ],
        ));
  }

  imagesdialog(ctx) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              top: 18.0,
            ),
            margin: const EdgeInsets.only(top: 13.0, right: 8.0),
            decoration: BoxDecoration(
              color: base1,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Upload images',
                      style: titlestyle.apply(color: base5)),
                ) //
                    ),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 250,
                  child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 2.0,
                      children: [
                        ...images.map((e) {
                          File file = File(e.path);

                          return Stack(children: [
                            Container(
                                padding: const EdgeInsets.all(8),
                                height: 100,
                                width: 100,
                                child: Image.file(
                                  file,
                                  fit: BoxFit.fill,
                                )),
                            Positioned(
                              right: 0.0,
                              child: GestureDetector(
                                onTap: () {
                                  _setState!(() {
                                    images.remove(e);
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: CircleAvatar(
                                    radius: 10.0,
                                    backgroundColor:
                                        Colors.white.withOpacity(.5),
                                    child: const Center(
                                        child: Icon(
                                      Icons.close,
                                      color: base5,
                                      size: 17,
                                    )),
                                  ),
                                ),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      button(
                          const Icon(
                            Icons.camera_alt_outlined,
                            color: base5,
                          ),
                          ctx,
                          csm: 'camera'),
                      button(
                          Row(
                            children: [
                              const Icon(
                                Icons.add_photo_alternate_outlined,
                                color: base5,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Gallery',
                                style: titlestyle.apply(color: base5),
                              )
                            ],
                          ),
                          ctx,
                          csm: 'gallery'),
                      button(
                          Text(
                            'Cancle',
                            style: titlestyle.apply(color: base5),
                          ),
                          ctx,
                          cancel: true),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(ctx).pop();
              },
              child: const Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: base5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton button(Widget child, BuildContext ctx,
      {String csm = '', bool cancel = false}) {
    return ElevatedButton(
        onPressed: () async {
          csm == 'camera' ? pickimages() : null;
          csm == 'gallery' ? pickimagesgalry() : null;
          cancel ? Navigator.pop(ctx) : null;
        },
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: cancel ? base.withOpacity(.5) : base1,
            side: BorderSide(
              color: cancel ? base : base5,
              width: 1,
            )),
        child: child);
  }

  Future pickimages() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    _setState!(() {
      image == null ? null : images.add(image);
    });
  }

  Future pickimagesgalry() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    _setState!(() {
      image == null ? null : images.add(image);
    });
  }

  Future<String> uploadFile(File _image) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(p.basename(_image.path));

      UploadTask storageuplodtsk = ref.putFile(_image);
      storageuplodtsk.then((res) {});

      String url = await (await storageuplodtsk).ref.getDownloadURL();
      return url;
    } catch (error) {
      return '';
    }
  }
}
