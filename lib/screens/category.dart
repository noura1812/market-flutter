import 'package:flutter/material.dart';
import 'package:market/models/items.dart';
import 'package:market/services/auth.dart';
import 'package:market/services/fetchdata.dart';
import 'package:market/services/theme.dart';
import 'package:market/widgets/itembilder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class Category_screen extends StatefulWidget {
  bool login;
  Auth? vale;
  Category_screen({super.key, this.login = false, this.vale});

  @override
  State<Category_screen> createState() => _Category_screenState();
}

class _Category_screenState extends State<Category_screen> {
  @override
  void initState() {
    Provider.of<Fetchdata>(context, listen: false).getsellerdata();

    Provider.of<Fetchdata>(context, listen: false).getdata().then((value) {
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

  bool _isloading = true;

  @override
  Widget build(BuildContext context) {
    int index = 0;
    final arg = widget.login
        ? {}
        : ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String tiltle = widget.login ? '' : arg['category'];
    String country = widget.login ? '' : arg['country'];
    List<Items> items = widget.login
        ? Provider.of<Fetchdata>(context)
            .items
            .where((element) => element.userid == widget.vale!.userid)
            .toList()
        : Provider.of<Fetchdata>(context)
            .items
            .where((element) =>
                element.type == tiltle && element.country == country)
            .toList();
    return Scaffold(
        backgroundColor: base1,
        appBar: widget.login
            ? null
            : AppBar(
                title: Text(
                  tiltle,
                  style: headingstyle,
                ),
                centerTitle: true,
                iconTheme: const IconThemeData(color: base4),
                backgroundColor: Theme.of(context).primaryColor,
              ),
        body: _isloading
            ? const Center(
                child: CircularProgressIndicator(color: base),
              )
            : items.isEmpty
                ? Center(
                    child: Text(
                      'No products Added.',
                      style: headingstyle.apply(color: base5),
                    ),
                  )
                : RefreshIndicator(
                    color: base2,
                    onRefresh: () async {
                      await Fetchdata().getdata();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: items.map((e) {
                          index += 1;
                          return AnimationConfiguration.staggeredList(
                            position: index - 1,
                            duration: const Duration(milliseconds: 1000),
                            child: SlideAnimation(
                              horizontalOffset: 300,
                              child: FadeInAnimation(
                                child: Dismissible(
                                  direction: Provider.of<Auth>(context).isAuth
                                      ? DismissDirection.endToStart
                                      : DismissDirection.none,
                                  onDismissed: (_) {
                                    Provider.of<Fetchdata>(context,
                                            listen: false)
                                        .deletitem(e);
                                  },
                                  background: Container(
                                    alignment: AlignmentDirectional.centerEnd,
                                    padding: const EdgeInsets.only(right: 10),
                                    color: base.withOpacity(.7),
                                    child: const Icon(
                                      Icons.delete,
                                      color: base5,
                                      size: 35,
                                    ),
                                  ),
                                  key: Key(e.id),
                                  child: Card(
                                      elevation: 20,
                                      shadowColor: base5,
                                      margin: const EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child:
                                          ItemsB(it: e, login: widget.login)),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ));
  }
}
