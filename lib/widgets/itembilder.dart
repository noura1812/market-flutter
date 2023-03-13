import 'package:flutter/material.dart';
import 'package:market/models/items.dart';
import 'package:market/services/fetchdata.dart';
import 'package:market/services/theme.dart';
import 'package:market/widgets/calctime.dart';
import 'package:market/widgets/size_configs.dart';
import 'package:provider/provider.dart';

class ItemsB extends StatelessWidget {
  Items it;
  bool login;
  ItemsB({super.key, required this.it, required this.login});
  SizeConfig sizeConfig = SizeConfig();

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return InkWell(
      onLongPress: () {
        login ? ontap(it, context) : null;
      },
      onTap: () {
        login ? null : Fetchdata().updatevews(it);
        Navigator.of(context).pushNamed('itemdetails', arguments: {'it': it});
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        height: getProportionateScreenHeight(
            SizeConfig.orientation == Orientation.landscape
                ? SizeConfig.screenHeight * .8
                : SizeConfig.screenHeight / 4),
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: SizeConfig.orientation == Orientation.landscape
                      ? 30
                      : 60),
              width:
                  SizeConfig.screenWidth / 2 - getProportionateScreenWidth(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: SizedBox(
                    width: SizeConfig.screenWidth / 2 -
                        getProportionateScreenWidth(25),
                    child: Column(
                      children: [
                        Text(
                          it.title,
                          style: titlestyle,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        Text(
                          it.price,
                          style: Subtitle,
                        ),
                      ],
                    ),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined),
                          Text(
                            it.city,
                            style: Subtitle,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              calc(it.date),
                              style: Subtitle,
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              width: getProportionateScreenWidth((10)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  width: SizeConfig.screenWidth / 2 -
                      getProportionateScreenWidth(30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image(
                      image: NetworkImage(it.images[0]),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  ontap(Items items, BuildContext context) {
    return showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
          ),
        ),
        backgroundColor: base1,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0))),
            height: 150,
            child: Container(
              padding: const EdgeInsets.only(top: 4),
              width: SizeConfig.screenWidth,
              height: (SizeConfig.orientation == Orientation.landscape)
                  ? (SizeConfig.screenHeight * .35)
                  : (SizeConfig.screenHeight * .20),
              child: Column(
                children: [
                  Flexible(
                      child: Container(
                    height: 4,
                    width: 120,
                    decoration: BoxDecoration(
                        color: base2.withOpacity(.5),
                        borderRadius: BorderRadius.circular(5)),
                  )),
                  SizedBox(
                    height: SizeConfig.orientation == Orientation.landscape
                        ? 30
                        : 40,
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * .8,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        Provider.of<Fetchdata>(context, listen: false)
                            .deletitem(it);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: base.withOpacity(.7),
                      ),
                      child: Text(
                        'Delet item',
                        style: titlestyle.copyWith(color: Colors.white),
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
