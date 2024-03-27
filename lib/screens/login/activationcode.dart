import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../apiservice.dart';
import '../../components/forward_button.dart';
import '../../components/header_text.dart';
import '../../components/trapozoid_cut_colored_image.dart';
import '../../components/view.dart';
import '../../goto_welcome_listener.dart';
import '../../utility/app_constant.dart';
import '../../utility/color_utility.dart';
import '../home/home.dart';
import 'login_animation.dart';


class CodeActivation extends StatefulWidget {
  final AnimationController controller;
  final GoToWelcomeListener goToWelcomeListener;
  final String regnum;



  CodeActivation({
    required this.controller,
    required this.goToWelcomeListener,
    required this.regnum,

  });

  @override
  _CodeActivationState createState() => _CodeActivationState();
}

class _CodeActivationState extends State<CodeActivation> {
  late LoginEnterAnimation enterAnimation;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<String> regnumFuture;
  late final Future<Map<String, dynamic>> userRegistrationStatus;

  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  final ApiService apiService = ApiService();
  String uniqueKey = '';
  int userId = 0;
  String code ='';
  String userCode = '';
  String regnum = '';
  bool _isRefreshing = false;



  @override
  void initState() {
    super.initState();
    String regnum = widget.regnum;
    fetchUserCode(regnum);
    userRegistrationStatus = getUserRegistrationStatus();
    enterAnimation = LoginEnterAnimation(widget.controller);
    regnumFuture = getStoredRegnum();
  }

  Future<Map<String, dynamic>> getUserRegistrationStatus() async {
    final dio = Dio();

    try {
      // Retrieve token from SharedPreferences
      final tokenmobile = await SharedPreferencesHelper.getSavedTokenMobile();

      // Make a GET request to the Laravel API endpoint
      final response = await dio.get(
        'http://139.177.200.139:90/api/user-registration-status/$userId',
        options: Options(
          headers: {
            'tokenmobile': tokenmobile,
          },
        ),
      );

      // Check if the response status is OK (200)
      if (response.statusCode == 200) {
        // Parse the response JSON
        final Map<String, dynamic> data = response.data;
        return data;
      } else {
        // Handle non-OK response
        print('Error: ${response.statusCode}');
        return {'status': 0, 'message': 'Failed to fetch user registration status'};
      }
    } catch (error) {
      // Handle Dio errors
      print('Dio Error: $error');
      return {'status': 0, 'message': 'Failed to fetch user registration status'};
    }
  }

 void performLogin(BuildContext context, String regnum, String code) async {
    try {
      final response = await apiService.loginUser(regnum, code);

      if (context == null) {
        return;
      }

      if (response.containsKey('message')) {
        print(response['message']);

        if (response.containsKey('user')) {
          final user = response['user'];

          if (user['tokenmobile'] != null) {
            // Save the tokenmobile to SharedPreferences
            saveToken(user['tokenmobile']);

            // Call getUserRegistrationStatus with the saved tokenmobile
            final registrationStatus = await apiService.getUserRegistrationStatus(user['tokenmobile']);

            if (user['activated'] == 1) {
              Fluttertoast.showToast(
                msg: 'App Activated',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboard(),
                ),
              );
            } else {
              Fluttertoast.showToast(
                msg: 'Please activate the app from elearning',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }
          } else {
            Fluttertoast.showToast(
              msg: 'Missing tokenmobile in the response',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: 'Invalid credentials or App not activated',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Please activate your app on ELearning',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void showPasswordDialog(BuildContext context) {
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Code'),
          content: TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Code',
            ),
            validator: (val) {
              return val?.length == 0 ? 'Code cannot be empty' : null;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String regnum = await getStoredRegnum();

                Navigator.of(context).pop();
                performLogin(context, regnum,code);
              },
              child: Text('Sign In'),
            ),
          ],
        );
      },
    );
  }

  void saveRegnum(String regnum) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('regnum', regnum);
  }

  Future<String> getStoredRegnum() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('regnum') ?? "";
  }

  Future<void> fetchUserCode(String regnum) async {
    final url = 'http://139.177.200.139:90/api/getcode?regnum=$regnum';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final jsonResponse = json.decode(response.body);
      final userCode = jsonResponse['user_id'] ?? 'No user code found';
      codeController.text =userCode;
      print('User Code: $userCode');
    } else {
      final errorMessage = 'Failed to load user code: ${response.statusCode}';
      print(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          key: _scaffoldKey,
          children: <Widget>[

            _trapoziodView(size, textTheme),
            _buttonContainer(context, size, textTheme),
          ],
        ),
      ),
    );
  }



  Widget _trapoziodView(Size size, TextTheme textTheme) {
    return Transform(
      transform: Matrix4.translationValues(
        0.0, -enterAnimation.Ytranslation.value * size.height, 0.0,
      ),
      child: TrapozoidTopBar(
        child: Container(

          height: size.height * 0.7,
          color: Colors.white,

          child: Stack(
            children: <Widget>[

              _buildBackgroundImage(size),
              _buildTextHeader(size, textTheme),
              _buildForm(size, textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(Size size, TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.3, left: 24, right: 24),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: _buildTextFormCode(textTheme),
              ),


              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1,
                  vertical: 12,
                ),
                child: Container(
                  color: Colors.grey,
                  height: 1,
                  width: enterAnimation.dividerScale.value * size.width,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1,
                ),
                // child: _buildTextFormPassword(textTheme),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTextFormCode(TextTheme textTheme) {
    String hintText = '';

    Future<void> startRefreshing() async {
      // Fetch user code
      await fetchUserCode(widget.regnum);
      if (codeController.text.isEmpty) {
        // If user code is still empty, wait for a short duration and then retry
        await Future.delayed(Duration(milliseconds: 500));
        await startRefreshing(); // Recursive call to continue refreshing
      } else {
        // Update hintText once user code is fetched
        setState(() {
          hintText = 'User Code: ${codeController.text}';
        });
      }
    }

    // Start refreshing when the widget is built
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      startRefreshing();
    });

    return FadeTransition(
      opacity: enterAnimation.userNameOpacity,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.blueAccent,
                width: 2.5,
              ),
            ),
            child: TextFormField(
              enabled: false, // Make the field non-editable
              controller: codeController, // Use a TextEditingController to display the userCode
              style: textTheme.bodyMedium?.copyWith(color: Colors.black87, letterSpacing: 1.2),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText.isNotEmpty ? hintText : 'User Code..', // Show refreshing message while waiting for user code
                hintStyle: textTheme.bodyMedium?.copyWith(color: Colors.black),
                icon: const Icon(
                  Icons.numbers,
                  color: Colors.black87,
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          SizedBox(height: 10), // Add spacing between code and the message
        ],
      ),
    );
  }




  Widget _buttonContainer(BuildContext context, Size size, TextTheme textTheme) {
    return RefreshIndicator(
      onRefresh: () async {
        // Set _isRefreshing to true to start showing the refresh indicator
        setState(() {
          _isRefreshing = true;
        });
          await  fetchUserCode(regnum);

        setState(() {
          _isRefreshing = false;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(top: size.height * 0.8),
        child: Container(
          width: double.infinity,
          child: Wrap(

            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Please login to your e-learning portal and punch this code',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Transform(
                  transform: Matrix4.translationValues(
                    enterAnimation.translation.value * 200,
                    0.0,
                    0.0,
                  ),
                  child: _isRefreshing
                      ? CircularProgressIndicator() // Show CircularProgressIndicator while refreshing
                      : ForwardButton(
                    onPressed: () {
                      String regnum = widget.regnum;
                      String code = codeController.text;

                      // Validate if regnum is not empty
                      if (regnum.isNotEmpty) {
                        // Call the API for login
                        performLogin(context, regnum, code);
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Please enter the regnum',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
                    label: BUTTON_ENTER,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSocialMediaAppButton(String color,
      String image,
      double size,
      double animatedValue,) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.diagonal3Values(animatedValue, animatedValue, 0.0),
      child: InkWell(
        onTap: null,
        child: Container(
          height: size,
          width: size,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(getColorHexFromStr(color)),
          ),
          child: Image.asset(image),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.3),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
            image: AssetImage(IMAGE_LOGIN_PATH),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.overlay,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextHeader(Size size, TextTheme textTheme) {
    return Transform(
      transform: Matrix4.translationValues(
        -enterAnimation.Xtranslation.value * size.width,
        0.0,
        0.0,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: size.height * 0.15, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeaderText(
              text: TEXT_MSU_LABEL,
              imagePath: IMAGE_SLIPPER_PATH,
            ),
            SizedBox(height: 30), // Adjust the spacing between the widgets
            Text(
              'Below is your activation code',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

    );
  }


  void saveToken(String tokenmobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tokenmobile', tokenmobile);
  }

  Future<String> getSavedToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('tokenmobile') ?? "";
  }

  void performVerification(BuildContext context, String regnum, String code) async {
    try {
      final response = await apiService.loginUser(regnum,code);

      if (context == null) {
        return;
      }

      if (response.containsKey('message')) {
        print(response['message']);
        if (response.containsKey('user') && response['user']['tokenmobile'] != null) {
          // Save the tokenmobile to SharedPreferences
          saveToken(response['user']['tokenmobile']);

          Fluttertoast.showToast(
            msg: 'Code Activation Successful',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,  // Use green color for success
            textColor: Colors.white,
          );

          // Navigate to the Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Invalid credentials or missing tokenmobile',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<Map<String, dynamic>> getCode(String tokenmobile) async {
    try {
      Dio dio = Dio();

      // Set up the headers
      Options options = Options(
        headers: {'tokenmobile': tokenmobile},
      );

      // Make the request to your server endpoint
      Response response = await dio.get(
        'http://139.177.200.139:90/api/getcode',
        options: options,
      );

      // Check the response status and return the appropriate result
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 401) {
        return {'message': 'Tokenmobile not provided.'};
      } else if (response.statusCode == 404) {
        return {'message': 'User not found.'};
      } else {
        return {'message': 'Error occurred while processing the request.'};
      }
    } catch (e) {
      print('Error: $e');
      return {'message': 'An unexpected error occurred.'};
    }
  }




}
