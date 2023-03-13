import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/services/theme.dart';
import 'package:market/widgets/size_configs.dart';

class InputField extends StatefulWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget,
      this.hight,
      this.width = false})
      : super(key: key);
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final double? hight;
  final bool width;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: base4,
          border: Border.all(
            width: 1,
            color: base5.withOpacity(.5),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        width: SizeConfig.screenWidth,
        height: widget.hight ?? 52,
        padding: const EdgeInsets.only(
          left: 14,
        ),
        margin: const EdgeInsets.only(
          top: 8,
        ),
        child: Row(
          crossAxisAlignment: widget.hight == null
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Container(
                padding: widget.hight == null
                    ? const EdgeInsets.all(0)
                    : const EdgeInsets.symmetric(vertical: 13),
                width: getProportionateScreenWidth(70),
                child: widget.title == 'Image url'
                    ? widget.widget
                    : widget.title == 'Phone numbe'
                        ? widget.widget
                        : Text(
                            widget.title,
                            style: bodystyle.apply(
                                color: base5, fontSizeDelta: -3),
                            textAlign: TextAlign.center,
                          )),
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: VerticalDivider(
                thickness: 1,
                color: base5.withOpacity(.5),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextFormField(
                keyboardType: widget.title == 'Phone numbe'
                    ? TextInputType.number
                    : widget.title == 'Price'
                        ? TextInputType.number
                        : TextInputType.text,
                readOnly: widget.title == 'Category' ? true : false,
                maxLines: widget.hight == null ? 1 : null,
                obscureText: widget.title == 'password',
                style: bodystyle.apply(color: base5.withOpacity(.5)),
                controller: widget.controller,
                autofocus: false,
                cursorColor: Get.isDarkMode ? Colors.grey[350] : base5,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: bodystyle.apply(
                      color: base5.withOpacity(.5), fontSizeDelta: -5),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 0, color: Colors.white.withOpacity(1))),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: base5.withOpacity(.5))),
                ),
              ),
            )),
            widget.title == 'Category'
                ? widget.widget ?? Container()
                : Container()
          ],
        ),
      ),
    );
  }
}
