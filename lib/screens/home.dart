import 'package:flutter/material.dart';
import 'package:market/screens/category.dart';
import 'package:market/screens/login.dart';
import 'package:market/services/auth.dart';
import 'package:market/services/theme.dart';
import 'package:market/widgets/dialog.dart';
import 'package:market/widgets/listvew.dart';
import 'package:market/widgets/maindrawer.dart';
import 'package:market/widgets/size_configs.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({super.key, required this.country});
  String country;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = const <Tab>[
    Tab(text: 'Categories'),
    Tab(text: 'Your acoount'),
  ];
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<Auth>(
      builder: (context, value, _) => Scaffold(
        backgroundColor: base1,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: base4),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "Market in ${widget.country} ",
            style: headingstyle,
          ),
          bottom: TabBar(
            labelStyle: subheadingstyle,
            labelColor: Colors.white,
            indicatorColor: base,
            controller: _tabController,
            tabs: myTabs,
          ),
        ),
        body: taddar(value, widget.country),
        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton(
                backgroundColor: base,
                splashColor: base2,
                hoverColor: base2,
                onPressed: () {
                  value.isAuth
                      ? Navigator.of(context).pushNamed('additem', arguments: {
                          'country': widget.country,
                          'userid': value.userid
                        })
                      : showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) => CustomDialog(
                                missage: 'Log in to add items!',
                              ));
                },
                child: const Icon(Icons.add),
              )
            : null,
        drawer: MainDrawer(valu: value),
      ),
    );
  }

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  TabBarView taddar(Auth valu, String country) {
    const List shoopingcategories = [
      [
        Icon(
          Icons.directions_car,
          color: base5,
        ),
        'Cars and motors'
      ],
      [
        Icon(
          Icons.computer,
          color: base5,
        ),
        'Computers'
      ],
      [
        Icon(
          Icons.phone_android,
          color: base5,
        ),
        'Phones'
      ],
      [
        Icon(
          Icons.videogame_asset_outlined,
          color: base5,
        ),
        'Games'
      ],
      [
        Icon(
          Icons.pets_outlined,
          color: base5,
        ),
        'Animals'
      ],
      [
        Icon(
          Icons.living_outlined,
          color: base5,
        ),
        'Furniture'
      ]
    ];

    return TabBarView(
      controller: _tabController,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ListView_drow(
            list: shoopingcategories,
            num: 2,
            country: country,
          ),
        ),
        valu.isAuth
            ? Category_screen(login: true, vale: valu)
            : Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(50)),
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: base2),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const LoginSignup()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Log in / Sign up',
                          style: headingstyle,
                        ),
                      )),
                ),
              )
      ],
    );
  }
}
