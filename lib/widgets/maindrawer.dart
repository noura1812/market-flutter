import 'package:flutter/material.dart';
import 'package:market/screens/aboutapp.dart';
import 'package:market/screens/choose_country.dart';
import 'package:market/services/auth.dart';
import 'package:market/services/theme.dart';
import 'package:market/widgets/size_configs.dart';

class MainDrawer extends StatelessWidget {
  SizeConfig sizeConfig = SizeConfig();
  Auth? valu;
  MainDrawer({super.key, this.valu});

  Widget items(name, Function tapselector) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              return tapselector();
            },
            title: Text(name, style: subheadingstyle),
          ),
          Container(
            height: 2,
            color: base5.withOpacity(.5),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);

    return Drawer(
      width: SizeConfig.screenWidth * .75,
      backgroundColor: Theme.of(context).primaryColor,
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          items('About', () {
            Navigator.of(context).pushNamed('aboutapp', arguments: {
              'about': '',
              'image': 'images/markit-logo-official1.JPG'
            });
          }),
          items('Terms of use', () {
            Navigator.of(context).pushNamed('aboutapp', arguments: {
              'terms': '',
            });
          }),
          items('Privacy policy', () {
            Navigator.of(context).pushNamed('aboutapp', arguments: {
              'privacy': '',
            });
          }),
          items('Contact us', () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const About()));
          }),
          items('Change the country', () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const Country()));
          }),
          items('VIP', () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const About()));
          }),
          valu!.isAuth
              ? items('Log out', () {
                  valu!.logout();
                })
              : Container()
        ],
      ),
    );
  }
}
