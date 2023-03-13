import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:market/services/auth.dart';
import 'package:market/services/theme.dart';
import 'package:market/widgets/dialog.dart';
import 'package:market/widgets/input_field.dart';
import 'package:market/widgets/size_configs.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginSignup extends StatefulWidget {
  const LoginSignup({super.key});

  @override
  State<LoginSignup> createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  List images = [
    'images/markit-logo-official1.JPG',
    'images/google.JPG',
    'images/facebook.JPG',
  ];
  bool _isloading = false;
  final TextEditingController name = TextEditingController();

  final TextEditingController address = TextEditingController();

  final TextEditingController phonenumber = TextEditingController();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  String type = '';
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: base1,
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(color: base),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(25),
                        height: SizeConfig.screenHeight * .05,
                        child: Image.asset(
                          images[0],
                          fit: BoxFit.fill,
                        ),
                      ),
                      dividertext("Are you a member?"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            radiobutton('I am a member', 'old'),
                            radiobutton('A new member', 'new')
                          ],
                        ),
                      ),
                      type != ''
                          ? Column(
                              children: [
                                dividertext(type == 'new'
                                    ? ' sign up with E-mai'
                                    : ' Log in with E-mail'),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: InputField(
                                    title: 'E-mail',
                                    hint: 'enter email ',
                                    controller: email,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: InputField(
                                    title: 'password',
                                    hint: 'enter password ',
                                    controller: password,
                                  ),
                                ),
                                type == 'new'
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: InputField(
                                          title: 'Name',
                                          hint: 'enter your name ',
                                          controller: name,
                                        ),
                                      )
                                    : Container(),
                                type == 'new'
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: InputField(
                                          title: 'Address',
                                          hint: 'enter your address ',
                                          controller: address,
                                        ),
                                      )
                                    : Container(),
                                type == 'new'
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: InputField(
                                          title: 'Phone numbe',
                                          hint: 'enter phone number ',
                                          widget: const Icon(Icons.phone),
                                          controller: phonenumber,
                                        ),
                                      )
                                    : Container(),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  height: 50,
                                  child: RichText(
                                    text: TextSpan(
                                        text: type == 'new'
                                            ? ''
                                            : 'Forgut password?',
                                        style: Subtitle.apply(
                                          color: base,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            print('forgut password');
                                          }),
                                  ),
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: base,
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        _isloading = true;
                                      });
                                      try {
                                        String? id = type == 'new'
                                            ? await Provider.of<Auth>(context,
                                                    listen: false)
                                                .signup(
                                                    email.text, password.text)
                                            : await Provider.of<Auth>(context,
                                                    listen: false)
                                                .signin(
                                                    email.text, password.text);
                                        Fluttertoast.showToast(
                                            msg: type == 'new'
                                                ? "Sugned up successfully!"
                                                : "Loged in successfully!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                base2.withOpacity(.7),
                                            textColor: Colors.white,
                                            fontSize: 16.0);

                                        type == 'new' ? adduser(id) : null;
                                        Navigator.pop(context);
                                      } catch (error) {
                                        var errorMessage = type == 'new'
                                            ? 'Sign up faild try again later'
                                            : 'Log in faild try again later';
                                        if (error
                                            .toString()
                                            .contains('EMAIL_EXISTS')) {
                                          errorMessage =
                                              'This email address is already in use.';
                                        } else if (error
                                            .toString()
                                            .contains('INVALID_EMAIL')) {
                                          errorMessage =
                                              'This is not a valid email address';
                                        } else if (error
                                            .toString()
                                            .contains('WEAK_PASSWORD')) {
                                          errorMessage =
                                              'This password is too weak.';
                                        } else if (error
                                            .toString()
                                            .contains('EMAIL_NOT_FOUND')) {
                                          errorMessage =
                                              'Could not find a user with that email.';
                                        } else if (error
                                            .toString()
                                            .contains('INVALID_PASSWORD')) {
                                          errorMessage = 'Invalid password.';
                                        }
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CustomDialog(
                                                  missage: errorMessage,
                                                ));
                                      }
                                      setState(() {
                                        _isloading = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 70, vertical: 8),
                                      child: Text(
                                        type == 'new' ? 'Sign up' : 'Log in',
                                        style: headingstyle.apply(color: base4),
                                      ),
                                    )),
                                Container(
                                  width: SizeConfig.screenWidth * .7,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  height: 50,
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text:
                                                'By clicking Sign Up, you agree to our ',
                                            style: Subtitle.apply(
                                              color: base5,
                                            )),
                                        TextSpan(
                                            text: 'Terms of Service',
                                            style: Subtitle.apply(
                                              color: base,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.of(context).pushNamed(
                                                    'aboutapp',
                                                    arguments: {
                                                      'terms': '',
                                                    });
                                              }),
                                        TextSpan(
                                            text: ' and ',
                                            style: Subtitle.apply(
                                              color: base5,
                                            )),
                                        TextSpan(
                                            text: 'Privacy Policy',
                                            style: Subtitle.apply(
                                              color: base,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.of(context).pushNamed(
                                                    'aboutapp',
                                                    arguments: {
                                                      'privacy': '',
                                                    });
                                              }),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  InkWell circlavatar(String image) {
    return InkWell(
      child: CircleAvatar(
        backgroundImage: AssetImage(
          image,
        ),
        radius: 25,
      ),
    );
  }

  radiobutton(String title, String val) {
    return Expanded(
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Text(title),
        horizontalTitleGap: 0,
        leading: Radio(
          fillColor: MaterialStateProperty.all<Color>(base),
          value: val,
          groupValue: type,
          onChanged: (value) {
            setState(() {
              type = value!;
            });
          },
        ),
      ),
    );
  }

  Row dividertext(String txt) {
    return Row(children: [
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 30.0, right: 10.0),
          child: Divider(
            thickness: 1,
            color: base5.withOpacity(.5),
          ),
        ),
      ),
      Text(
        txt,
        style: bodystyle.apply(color: base5),
      ),
      Expanded(
          child: Container(
        margin: const EdgeInsets.only(left: 10.0, right: 30.0),
        child: Divider(
          thickness: 1,
          color: base5.withOpacity(.5),
        ),
      )),
    ]);
  }

  Future adduser(String? userid) async {
    const String url =
        'https://market-flutter-f72fc-default-rtdb.firebaseio.com/sellers.json';
    try {
      await http.post(Uri.parse(url),
          body: json.encode({
            'userid': userid,
            'name': name.text,
            'address': address.text,
            'phonenumber': phonenumber.text,
          }));
    } catch (error) {
      throw error;
    }
  }
}
