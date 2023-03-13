import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:market/main.dart';
import 'package:market/services/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListView_drow extends StatefulWidget {
  final List list;
  final int num;
  String country;
  ListView_drow(
      {super.key, required this.list, required this.num, this.country = ''});

  @override
  State<ListView_drow> createState() => _ListView_drowState();
}

class _ListView_drowState extends State<ListView_drow> {
  @override
  Widget build(BuildContext context) {
    int selectedIndex = -1;

    return ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: (ctx, index) {
          return Card(
            color: Colors.white,
            shadowColor: base5,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  widget.num == 1
                      ? Container()
                      : Container(
                          width: 7,
                          decoration: const BoxDecoration(
                            color: base2,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                          ),
                        ),
                  Flexible(
                    child: ListTile(
                      selected: index == selectedIndex,
                      selectedTileColor: Theme.of(context).primaryColor,
                      hoverColor: Theme.of(context).primaryColor,
                      onTap: () async {
                        setState(() {
                          selectedIndex = index;
                        });
                        if (widget.num == 1) {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setString("C", widget.list[index].name);

                          Navigator.of(ctx).pushReplacement(MaterialPageRoute(
                              builder: (_) => MyApp(
                                    country: widget.list[index].name,
                                  )));
                        } else {
                          Navigator.of(context).pushNamed('category',
                              arguments: {
                                'category': widget.list[index][1],
                                'country': widget.country
                              });
                        }
                      },
                      leading: Container(
                          child: widget.num == 1
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      bottom:
                                          6.0), //Same as `blurRadius` i guess

                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 6.0,
                                        )
                                      ]),
                                  child: CircleFlag(
                                    widget.list[index].short,
                                    size: 35,
                                  ),
                                )
                              : widget.list[index][0]),
                      title: widget.num == 1
                          ? Text(
                              widget.list[index].name,
                              style: titlestyle,
                            )
                          : Text(
                              widget.list[index][1],
                              style: titlestyle,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
