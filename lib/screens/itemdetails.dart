import 'package:flutter/material.dart';
import 'package:market/models/items.dart';
import 'package:market/services/fetchdata.dart';
import 'package:market/services/theme.dart';
import 'package:market/widgets/calctime.dart';
import 'package:market/widgets/size_configs.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  int indix = 0;

  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, Items>;
    Items it = arg['it']!;
    var details = Provider.of<Fetchdata>(context)
        .sellers
        .where((element) => element.id == it.userid)
        .toList();
    return Scaffold(
      backgroundColor: base1,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () {
            Fetchdata().getdata();
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Details',
          style: headingstyle.apply(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: base4),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              color: base4,
              shadowColor: base5,
              elevation: 15,
              child: SizedBox(
                width: SizeConfig.screenWidth,
                height:
                    getProportionateScreenHeight(SizeConfig.screenHeight * .35),
                child: Stack(
                  children: [
                    Center(
                      child: CarouselSlider(
                          items: it.images.map((e) {
                            return Image.network(
                              e,
                              fit: BoxFit.fitHeight,
                            );
                          }).toList(),
                          options: CarouselOptions(
                            onPageChanged: (indexx, reason) {
                              setState(() {
                                indix = indexx;
                              });
                            },
                            height: getProportionateScreenHeight(
                                    SizeConfig.screenHeight * .35) -
                                10,
                            autoPlayInterval: const Duration(seconds: 1),
                            autoPlay: false,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            initialPage: 0,
                          )),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.black54),
                        child: Text(
                          '${indix + 1}/${it.images.length}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: base5),
            padding: const EdgeInsets.all(5),
            child: Center(
                child: Text(
              it.title,
              style: titlestyle.apply(color: base4),
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            child: LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SizedBox(
                height: SizeConfig.screenHeight -
                    getProportionateScreenHeight(
                        SizeConfig.screenHeight * .35) -
                    170,
                child: ListView(children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: viewportConstraints.maxWidth,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              datacards('Date', it.date),
                              const SizedBox(
                                width: 6,
                              ),
                              datacards('Views', '${it.seens}')
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              datacards('Field', it.type),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              datacards('City', it.city),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              datacards('Price', it.price),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(10),
                          width: SizeConfig.screenWidth,
                          decoration: BoxDecoration(
                              color: base4,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: base5.withOpacity(.7), width: 2)),
                          child: Text(
                            it.subtitle,
                            style: subheadingstyle,
                            textAlign: TextAlign.justify,
                          ),
                        )
                      ],
                    ),
                  )
                ]),
              );
            }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: base,
        splashColor: base2,
        hoverColor: base2,
        onPressed: () {
          _showdialog(details[0]);
        },
        child: const Icon(
          Icons.perm_contact_calendar_outlined,
        ),
      ),
    );
  }

  datacards(String title, String data) {
    if (title == 'Date') {
      data = calc(data);
    }
    return Expanded(
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: base3.withOpacity(.6),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(60),
                  child: Center(
                    child: Text(
                      title,
                      style: subheadingstyle.apply(color: base2),
                    ),
                  ),
                ),
                SizedBox(
                    height: 40,
                    child: VerticalDivider(
                      color: base5.withOpacity(.5),
                      thickness: 1,
                    )),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    data,
                    style: subheadingstyle.apply(
                        color: base2, fontSizeDelta: title == 'Date' ? -3 : -1),
                  ),
                )
              ],
            )));
  }

  void _showdialog(details) {
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)),
              title: Container(
                padding: EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: base2,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                ),
                child: Text(
                  'Contact information',
                  style: headingstyle.apply(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              titlePadding: const EdgeInsets.all(0),
              content: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      details.name,
                      style: subheadingstyle,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Address',
                      style: subheadingstyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      details.address,
                      style:
                          subheadingstyle.apply(color: base5.withOpacity(.7)),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Phone number',
                      style: subheadingstyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      details.phonenumber.toString(),
                      style: subheadingstyle.apply(color: base2),
                    )
                  ],
                ),
              ),
            )));
  }
}
