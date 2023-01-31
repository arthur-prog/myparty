import 'package:flutter/material.dart';
import 'package:my_party/src/features/screens/party/party_screen.dart';
import 'package:my_party/src/features/screens/map/map_screen.dart';
import 'package:my_party/src/features/screens/profile/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  int currentIndex = 0;

  late Widget childWidget;

  dynamic _scrollPhysics = ScrollPhysics();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey[500],
          currentIndex: currentIndex,
          onTap: (value) {
            currentIndex = value;
            _pageController.animateToPage(value,
                duration: Duration(milliseconds: 300),
                curve: Curves.linear);
            if (value == 1){
              _scrollPhysics = NeverScrollableScrollPhysics();
            } else {
              _scrollPhysics = ScrollPhysics();
            }
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.party_mode),
              label: AppLocalizations.of(context)!.party,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.map),
              label: AppLocalizations.of(context)!.map,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: AppLocalizations.of(context)!.profile,
            ),
          ],
        ),
        body: PageView(
          physics: _scrollPhysics,
          controller: _pageController,
          onPageChanged: (page) {
            if (page == 1){
              _scrollPhysics = const NeverScrollableScrollPhysics();
            } else {
              _scrollPhysics = const ScrollPhysics();
            }
            setState((){
              currentIndex = page;
            });
          },
          children: <Widget> [
            PartyScreen(),
            const MapScreen(),
            Profile(),
          ],
        )
    );
  }
}