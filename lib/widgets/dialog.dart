import 'package:flutter/material.dart';
import 'package:market/services/theme.dart';

class CustomDialog extends StatelessWidget {
  String missage;
  CustomDialog({this.missage = ''});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: missage == '' ? addimages(context) : dialogContent(context),
    );
  }

  Widget addimages(BuildContext context) {
    return Stack(
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
              const SizedBox(height: 20.0),
              Container(
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    button(const Icon(
                      Icons.camera_alt_outlined,
                      color: base5,
                    )),
                    button(Row(
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
                    )),
                    button(
                        Text(
                          'Cancle',
                          style: titlestyle.apply(color: base5),
                        ),
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
              Navigator.of(context).pop();
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
    );
  }

  ElevatedButton button(Widget child, {bool cancel = false}) {
    return ElevatedButton(
        onPressed: () {},
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

  Widget dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            top: 18.0,
          ),
          margin: const EdgeInsets.only(top: 13.0, right: 8.0),
          decoration: BoxDecoration(
            color: base,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 20.0,
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                    Text(missage, style: titlestyle.apply(color: Colors.white)),
              ) //
                  ),
              const SizedBox(height: 24.0),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  decoration: const BoxDecoration(
                    color: base1,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0)),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(color: base2),
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        Positioned(
          right: 0.0,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
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
    );
  }
}
