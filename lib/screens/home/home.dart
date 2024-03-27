import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newmsu/screens/home/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/view.dart';
import '../../drawer/bottombar.dart';
import '../../models/model.dart';
import '../navigation.dart';
import 'daily.dart';
import 'exthome.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:flutter/painting.dart';


class IndependentContainer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.blue,
      child: Center(
        child: Text(
          'Independent Container',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {



  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  AnimationController? animationController;
  DrawerIndex? drawerIndex;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  String regnum = '';

  Widget tabBody = Container(
    color: MyMsuTheme.background,
  );
  bool _isDrawerOpen = false;


  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  void initState() {
    _loadRegnum();
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = MyHomeScreen(animationController: animationController);
    super.initState();
  }
  _loadRegnum() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      regnum = prefs.getString('regnum') ?? '';
    });
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyMsuTheme.background,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00CCFF),
                    Color(0xFF3366FF),

                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'MSU',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 2),
                Image.asset(
                  'assets/images/logo.png',
                  height: 50,
                  color: Colors.white,
                ),
              ],
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: ()  {
                if (_scaffoldKey.currentState!.isDrawerOpen) {
                  _scaffoldKey.currentState!.openEndDrawer();
                } else {
                  _scaffoldKey.currentState!.openDrawer();
                }

              },

            ),

          ),
        ),

        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return  Container();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  // bottomBar(),
                ],
              );
            }
          },
        ),
        drawer: HomeDrawer(

          onDrawerItemClicked: onDrawerItemClicked,
        ),
      ),
    );
  }




  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0 || index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MyHomeScreen(animationController: animationController);
                });
              });
            } else if (index == 1 || index == 3) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      InitalNav(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  void onDrawerItemClicked(DrawerIndex index) {
    setState(() {
      drawerIndex = index;
      // Change tab body based on the selected drawer item
      if (drawerIndex == DrawerIndex.HOME) {
        tabBody = MyHomeScreen(animationController: animationController);
      } else if (drawerIndex == DrawerIndex.HOME) {
        tabBody = MyHomeScreen(animationController: animationController);
      }
    });
  }
}

enum DrawerIndex {
  HOME,
}

class HomeDrawer extends StatelessWidget {
  final Function(DrawerIndex) onDrawerItemClicked;

  const HomeDrawer({Key? key, required this.onDrawerItemClicked})
      : super(key: key);
  Future<String> getRegNum() async {
    final dio = Dio();

    try {
      final tokenmobile = await getTokenMobile();

      final response = await dio.get(
        'http://139.177.200.139:90/api/get-registration-number',
        options: Options(
          headers: {
            'tokenmobile': tokenmobile,
          },
        ),
      );

      if (response.statusCode == 200) {
        final String regNum = response.data['regnum'];
        return regNum;
      } else {
        throw Exception('Loading');
      }
    } catch (error) {
      throw Exception('No internet');
    }
  }

  Future<String> getTokenMobile() async {
    return SharedPreferencesHelper.getSavedTokenMobile();
  }


  @override
  Widget build(BuildContext context) {
    return
      ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30.0),
        bottomRight: Radius.circular(30.0),
      ),
      child:
      Drawer(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(30.0),
              backgroundBlendMode: BlendMode.modulate,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF00CCFF),
                          Color(0xFF3366FF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: DrawerHeader(
                      padding: EdgeInsets.zero,
                      child: FutureBuilder<String>(
                        future: getRegNum(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Oops ${snapshot.error}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            );
                          } else {
                            final String regNum = snapshot.data ?? '';
                            return Center(
                              child: Text(
                                regNum.isNotEmpty ? regNum : 'N/A',
                                style: TextStyle(
                                  fontFamily: MyMsuTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Colors.blue,
                    ),
                    title: Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      onDrawerItemClicked(DrawerIndex.HOME);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      _logout(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}



void _logout(BuildContext context) async {
  // Clear the token from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('tokenmobile');

  // Navigate to the login page
  Navigator.of(context).pushReplacementNamed('/login');
}

