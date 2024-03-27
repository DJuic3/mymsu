import 'package:flutter/material.dart';

import '../uihelper.dart';
import '../widgets/responsive.dart';

class InitalNav extends StatefulWidget {
  const InitalNav({Key? key, this.animationController}) : super(key: key);
  final AnimationController? animationController;

  @override
  _InitalNavState createState() => _InitalNavState();
}

class _InitalNavState extends State<InitalNav>     with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  final List<Map<String, String>> boxData = [
    {
      'title': 'Timetable',
      'subtitle': 'Never miss a lecture',
      'imagePath': 'assets/msuposter.png',
    },

    {
      'title': 'Notices',
      'subtitle': 'Stay up to date',
      'imagePath': 'assets/msuposter.png',
    },
    // Add more data as needed
  ];
  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }


  @override
    Widget build(BuildContext context) {

      final isTabletDesktop = Responsive.isTabletDesktop(context);
      final cardWidth =
          MediaQuery.of(context).size.width / (isTabletDesktop ? 3.8 : 1.2);

      return Container(
        margin: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.arrow_downward,
                  color: Colors.blue,
                ),
                UIHelper.horizontalSpaceExtraSmall(),
                Flexible(
                  child: Text(
                    "MORE FROM MIDLANDS STATE UNIVERSITY",
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: Colors.blue,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                UIHelper.horizontalSpaceExtraSmall(),
                Icon(
                  Icons.arrow_downward,
                  color: Colors.blue,
                ),
              ],
            ),
            UIHelper.verticalSpaceMedium(),
        LimitedBox(
          maxHeight: 174.0,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: boxData.length,
            itemBuilder: (context, index) {
              final data = boxData[index];
              return Container(
                margin: const EdgeInsets.only(right: 10.0),
                padding: const EdgeInsets.all(10.0),
                width: cardWidth,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  border: Border.all(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  data['title']!,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                UIHelper.verticalSpaceExtraSmall(),
                                Text(
                                  data['subtitle']!,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                          ),
                          UIHelper.verticalSpaceExtraSmall(),
                        ],
                      ),
                    ),
                    UIHelper.horizontalSpaceSmall(),
                    ClipOval(
                      child: Image.asset(
                        'assets/msuposter.png',
                        height: 500.0,
                        width: 90.0,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        )
          ],
        ),
      );
    }
  }

