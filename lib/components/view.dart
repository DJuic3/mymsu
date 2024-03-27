import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:newmsu/screens/home/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../main.dart';
import 'package:http/http.dart' as http;




class ModuleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),


        body: Column(
          children: [
            SubjectListView(),

          ],
        ),

      ),
    );
  }
}

class SubjectListView extends StatefulWidget {


  @override
  _SubjectListViewState createState() => _SubjectListViewState();
}

class _SubjectListViewState extends State<SubjectListView> with SingleTickerProviderStateMixin {
  List<dynamic> modules = [];
  String? tokenmobile;
  bool isLoading = false;
  int userId = 0;
  late final Future<Map<String, dynamic>> userRegistrationStatus;
  late final AnimationController? animationController;
  late final Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    userRegistrationStatus = getUserRegistrationStatus();
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(animationController as Animation<double>);
    fetchUserIdmodules();
    fetchUserId(context);


  }

  Future<void> fetchUserModules() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Make an HTTP request to retrieve user modules
      final response = await http.get(
        Uri.parse('http://139.177.200.139:90/api/user-modules/$userId'),
        headers: {'tokenmobile': tokenmobile ?? ''},
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          modules = data['modules'];
          tokenmobile = response.headers['tokenmobile'];
        });
      } else {
        final message = json.decode(response.body)['message'];
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<Map<String, dynamic>> fetchUserId(BuildContext context) async {
    // Set initial loading state
    isLoading = true;

    // Retrieve token from SharedPreferences
    tokenmobile = await SharedPreferencesHelper.getSavedTokenMobile();
    print(tokenmobile);

    try {
      // Make the HTTP GET request to get the user ID
      final response = await http.get(
        Uri.parse('http://139.177.200.139:90/api/user-id-by-token'),
        headers: {'tokenmobile': tokenmobile ?? ''},
      );

      // Set loading state to false
      isLoading = false;

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Set the userId directly in the widget
        userId = data['user_id'];

        // Make the HTTP GET request to fetch user details
        final userDetailsResponse = await http.get(
          Uri.parse('http://139.177.200.139:90/api/users/$userId'),
          headers: {'tokenmobile': tokenmobile ?? ''},
        );

        if (userDetailsResponse.statusCode == 200) {
          final Map<String, dynamic> userDetails = json.decode(userDetailsResponse.body);
          // Process the userDetails as needed
          print('User Details: $userDetails');
          return userDetails; // Return user details
        } else {
          print('HTTP Status Code: ${userDetailsResponse.statusCode}');
          throw ('Please update your profile');
        }
      } else {
        final message = json.decode(response.body)['message'];
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(''),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
        throw ('Failed to fetch user ID');
      }
    } catch (e) {
      // Handle any potential errors
      print('');
      throw ('Please update your profile');
    }
  }

  Future<void> fetchUserIdmodules() async {
    setState(() {
      isLoading = true;
    });

    tokenmobile = await SharedPreferencesHelper.getSavedTokenMobile();

    try {
      final response = await http.get(
        Uri.parse('http://139.177.200.139:90/api/user-id-by-token'),
        headers: {'tokenmobile': tokenmobile ?? ''},
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(userId);
        setState(() {
          userId = data['user_id'];
        });

        // Fetch user modules using userId and tokenmobile
        await fetchUserModules();
      } else {
        final message = json.decode(response.body)['message'];
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getUserRegistrationStatus() async {
    final dio = Dio();

    try {
      // Retrieve token from SharedPreferences
      final tokenmobile = await SharedPreferencesHelper.getSavedTokenMobile();

      // Make a GET request to the Laravel API endpoint
      final response = await dio.get(
        'http://139.177.200.139:90/api/user-registration-status/$userId', // Replace with your actual API endpoint
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


  Widget buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override

  Widget build(BuildContext context) {

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          fetchUserId(context),
          fetchUserModules(),
          fetchUserIdmodules(),
        ]);
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child:
                              Text(
                                'REGISTRATION STATUS',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: MyMsuTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: -0.2,
                                  color: MyMsuTheme.darkText,
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Container(
                                  height: 4,
                                  width: 170,
                                  decoration: BoxDecoration(
                                    color: HexColor('#87A0E5').withOpacity(0.9),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0),
                                    ),
                                  ),
                                  child: Row(
                                    children: <Widget>[

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 4,
                        height: 25,
                      ),
                      // Other widgets if needed
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                    future: userRegistrationStatus,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SizedBox(
                            width: 14, // Set the desired width
                            height: 14, // Set the desired height
                            child: CircularProgressIndicator(
                              strokeWidth: 3, // Set the desired strokeWidth
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.data == null) {
                        return Text('Data is null');
                      } else {
                        final dynamic data = snapshot.data!;
                        print('Data: $data'); // Add this line to print the data

                        // Check if 'status' key is present in the data
                        if (data.containsKey('status')) {
                          final int status = data['status'];
                          print('Status: $status'); // Add this line to print the status

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 35),
                              Center(
                                child: Container(
                                  width: 190,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: status == 1 ? Colors.green : Colors.yellow,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        status == 1 ? Icons.check : Icons.cancel_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        status == 1 ? 'Registered' : 'Unregistered',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Text('Key "status" not found in data');
                        }
                      }
                    },
                  ),

                ],
              ),
              SizedBox(height: 30),
              Container(
                child:Padding(
                  padding: const EdgeInsets.only(
                      left: 0, right: 0, top: 8, bottom: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'PROGRAM',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: MyMsuTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                letterSpacing: -0.2,
                                color: MyMsuTheme.darkText,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                height: 4,
                                width: 70,
                                decoration: BoxDecoration(
                                  color:
                                  HexColor('#87A0E5').withOpacity(0.9),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0)),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      // width: ((70 / 1) * animation!.value),
                                      height: 4,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          HexColor('#208f07'),
                                          HexColor('#208f07')
                                              .withOpacity(0.5),
                                        ]),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4.0)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            FutureBuilder<Map<String, dynamic>>(
                              future: fetchUserId(context),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return buildLoadingIndicator(); // Show loading indicator
                                } else if (snapshot.hasError) {
                                  // Print the actual error message
                                  print('Error: ${snapshot.error}');
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  // User details are available
                                  Map<String, dynamic> userData = snapshot.data!;

                                  // Extract student details
                                  List<dynamic> studentDataList = userData['student'];

                                  if (studentDataList.isEmpty) {
                                    return Text('Student data not found.');
                                  }

                                  // Assuming there's only one student data, you can access the first element
                                  Map<String, dynamic> studentData = studentDataList.first;

                                  // Extract specific details
                                  String programName = studentData['programname'] as String? ?? 'N/A';
                                  String levelName = studentData['levelName'].toString() ?? 'N/A';
                                  String attendanceTypeName = studentData['attendanceType'] as String? ?? 'N/A';

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child:
                                        Text(
                                          '$programName',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: MyMsuTheme.fontName,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: MyMsuTheme.grey.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                        height: 15,
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, right: 24, top: 8, bottom: 16),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'ATTENDANCE TYPE',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: MyMsuTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      letterSpacing: -0.2,
                                                      color: MyMsuTheme.darkText,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4),
                                                    child: Container(
                                                      height: 4,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                        color:
                                                        HexColor('#87A0E5').withOpacity(0.9),
                                                        borderRadius: const BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                            // width: ((70 / 1) * animation!.value),
                                                            height: 4,
                                                            decoration: BoxDecoration(
                                                              gradient: LinearGradient(colors: [
                                                                HexColor('#208f07'),
                                                                HexColor('#208f07')
                                                                    .withOpacity(0.5),
                                                              ]),
                                                              borderRadius: const BorderRadius.all(
                                                                  Radius.circular(4.0)),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 6),
                                                    child: Text(
                                                      '$attendanceTypeName',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: MyMsuTheme.fontName,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                        color:
                                                        MyMsuTheme.grey.withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, right: 24, top: 8, bottom: 16),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'LEVEL',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: MyMsuTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      letterSpacing: -0.2,
                                                      color: MyMsuTheme.darkText,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4),
                                                    child: Container(
                                                      height: 4,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                        color:
                                                        HexColor('#87A0E5').withOpacity(0.9),
                                                        borderRadius: const BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                            // width: ((70 / 1) * animation!.value),
                                                            height: 4,
                                                            decoration: BoxDecoration(
                                                              gradient: LinearGradient(colors: [
                                                                HexColor('#208f07'),
                                                                HexColor('#208f07')
                                                                    .withOpacity(0.5),
                                                              ]),
                                                              borderRadius: const BorderRadius.all(
                                                                  Radius.circular(4.0)),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 6),
                                                    child: Text(
                                                      '$levelName',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: MyMsuTheme.fontName,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                        color:
                                                        MyMsuTheme.grey.withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );


                                }
                              },
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );


  }

}

class MediterranesnDietView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final Map<String, dynamic> student;
  // Declare state variables here
  bool isLoading = false;
  String tokenmobile = "";
  int userId = 6;

  MediterranesnDietView({
    Key? key,
    this.animationController,
    this.animation,
    required this.student,
  }) : super(key: key);




  Future<Map<String, dynamic>> fetchFeesBalance(String tokenmobile) async {
    try {
      final response = await http.get(
        Uri.parse('http://139.177.200.139:90/api/fees-balance'),
        headers: {
          'tokenmobile': tokenmobile,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Check if response is empty
        if (jsonData.isEmpty) {
          // Return placeholder value
          return {'placeholder': '\$\$\$'};
        }
        return jsonData;
      } else {
        throw ('Failed to fetch fees balance');
      }
    } catch ($e) {
      // Handle network or other errors
      throw ('---');
    }
  }

  Future<Map<String, dynamic>> fetchUserId(BuildContext context) async {
    // Set initial loading state
    isLoading = true;

    // Retrieve token from SharedPreferences
    tokenmobile = await SharedPreferencesHelper.getSavedTokenMobile();
    print(tokenmobile);

    try {
      // Make the HTTP GET request to get the user ID
      final response = await http.get(
        Uri.parse('http://139.177.200.139:90/api/user-id-by-token'),
        headers: {'tokenmobile': tokenmobile ?? ''},
      );

      // Set loading state to false
      isLoading = false;

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Set the userId directly in the widget
        userId = data['user_id'];

        // Make the HTTP GET request to fetch user details
        final userDetailsResponse = await http.get(
          Uri.parse('http://139.177.200.139:90/api/users/$userId'),
          headers: {'tokenmobile': tokenmobile},
        );

        if (userDetailsResponse.statusCode == 200) {
          final Map<String, dynamic> userDetails = json.decode(userDetailsResponse.body);
          // Process the userDetails as needed
          print('User Details: $userDetails');
          return userDetails; // Return user details
        } else {
          print('HTTP Status Code: ${userDetailsResponse.statusCode}');
          throw Exception('Failed to fetch user details');
        }
      } else {
        final message = json.decode(response.body)['message'];
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
        throw Exception('Failed to fetch user ID');
      }
    } catch (e) {
      // Handle any potential errors
      print('Error: $e');
      throw Exception('Refresh network');
    }
  }

  Future<Map<String, dynamic>> getUserRegistrationStatus() async {
    final dio = Dio();

    try {
      // Retrieve token from SharedPreferences
      final tokenmobile = await SharedPreferencesHelper.getSavedTokenMobile();

      // Make a GET request to the Laravel API endpoint
      final response = await dio.get(
        'http://139.177.200.139:90/api/user-registration-status/$userId', // Replace with your actual API endpoint
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





  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            fetchFeesBalance(tokenmobile),
            getUserRegistrationStatus(),
            fetchUserId(context),
          ]);
        },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedBuilder(
            animation: animationController!,
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: animation!,
                child:  Transform(
                  transform:  Matrix4.translationValues(
                      0.0, 30 * (1.0 - animation!.value), 0.0),
                  child:
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 16, bottom: 18),
                    child:
                    Container(
                      decoration: BoxDecoration(
                        color: MyMsuTheme.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(68.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: MyMsuTheme.grey.withOpacity(0.2),
                              offset: Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 4),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              height: 48,
                                              width: 2,
                                              decoration: BoxDecoration(
                                                color: HexColor('#87A0E5').withOpacity(0.5),
                                                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[

                                                    SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,

                                                      child: Row(
                                                        children: <Widget>[

                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Container(

                                                              height: 100, // Set a fixed height or adjust as needed
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 2, bottom: 2),
                                                                    child:
                                                                    Text(
                                                                      'FEES BALANCE',
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                        fontFamily: MyMsuTheme.fontName,
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 20,
                                                                        letterSpacing: -0.1,
                                                                        color: MyMsuTheme.grey.withOpacity(0.5),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    children: <Widget>[
                                                                      SizedBox(
                                                                        width: 28,
                                                                        height: 28,
                                                                        child: Image.asset("assets/money.png"),
                                                                      ),
                                                                      FutureBuilder(
                                                                        future: SharedPreferencesHelper.getSavedTokenMobile(),
                                                                        builder: (context, snapshot) {
                                                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                                                            return const Center(
                                                                              child: SizedBox(
                                                                                width: 24, // Set the desired width
                                                                                height: 24, // Set the desired height
                                                                                child: CircularProgressIndicator(
                                                                                  strokeWidth: 3, // Set the desired strokeWidth
                                                                                ),
                                                                              ),
                                                                            );
                                                                          } else if (snapshot.hasError) {
                                                                            return Center(child: Text('${snapshot.error}'));
                                                                          } else {
                                                                            final tokenmobile = snapshot.data as String;
                                                                            return FutureBuilder(
                                                                              future: fetchFeesBalance(tokenmobile),
                                                                              builder: (context, snapshot) {
                                                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                  return const Center(
                                                                                    child: SizedBox(
                                                                                      width: 24, // Set the desired width
                                                                                      height: 24, // Set the desired height
                                                                                      child: CircularProgressIndicator(
                                                                                        strokeWidth: 3, // Set the desired strokeWidth
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                } else if (snapshot.hasError) {
                                                                                  return Center(child: Text('${snapshot.error}'));
                                                                                } else {
                                                                                  final feesBalance = snapshot.data?['fees_balance'] ?? 0.0;
                                                                                  return Center(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        SizedBox(height: 10),
                                                                                        Text(
                                                                                          '$feesBalance',
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(
                                                                                            fontFamily: MyMsuTheme.fontName,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: 25,
                                                                                            letterSpacing: -0.1,
                                                                                            color: MyMsuTheme.grey.withOpacity(0.5),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              },
                                                                            );
                                                                          }
                                                                        },
                                                                      ),

                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 4, bottom: 3),
                                                                        child: Text(
                                                                          'USD',
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                            fontFamily: MyMsuTheme.fontName,
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: 12,
                                                                            letterSpacing: -0.2,
                                                                            color: MyMsuTheme.grey.withOpacity(0.5),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: <Widget>[
                                            Container(
                                              height: 48,
                                              width: 2,
                                              decoration: BoxDecoration(
                                                color: HexColor('#F56E98')
                                                    .withOpacity(0.5),
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(4.0)),
                                              ),
                                            ),

                                          ],
                                        ),


                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                color: MyMsuTheme.background.withOpacity(0.5), // Set alpha value for transparency
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              ),
                            ),
                          ),

                        ],
                      ),


                    ),

                  ),

                ),
              );
            },
          ),
          Card(
            color: Colors.white,
            child: Column(
              children: [

                SubjectListView(),
                ModulesView(),
              ],
            ),
          )
        ],
      ),
    );

  }



  @override
  void dispose() {


  }

  Future<String> getSavedToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('tokenmobile') ?? "";
  }



}


class CurvePainter extends CustomPainter {
  final double? angle;
  final List<Color>? colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = [];
    if (colors != null) {
      colorsList = colors ?? [];
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint =  Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter =  Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
         Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
         Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
         Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
         Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    final rect =  Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient =  SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint =  Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center =  Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
         Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle! + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
// Create a utility class for managing SharedPreferences


class ModulesView extends StatefulWidget {


  @override
  _ModulesViewState createState() => _ModulesViewState();
}

class _ModulesViewState extends State<ModulesView> with SingleTickerProviderStateMixin {
  List<dynamic> modules = [];
  String? tokenmobile;
  bool isLoading = false;
  int userId = 0;
  late final Future<Map<String, dynamic>> userRegistrationStatus;
  late final AnimationController? animationController;
  late final Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    userRegistrationStatus = getUserRegistrationStatus();
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(animationController as Animation<double>);
    fetchUserIdmodules();
    fetchUserId(context);


  }

  Future<void> fetchUserModules() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Make an HTTP request to retrieve user modules
      final response = await http.get(
        Uri.parse('http://139.177.200.139:90/api/user-modules/$userId'),
        headers: {'tokenmobile': tokenmobile ?? ''},
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          modules = data['modules'];
          tokenmobile = response.headers['tokenmobile'];
        });
      } else {
        final message = json.decode(response.body)['message'];
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }


  Future<Map<String, dynamic>> fetchUserId(BuildContext context) async {
    // Set initial loading state
    isLoading = true;

    // Retrieve token from SharedPreferences
    tokenmobile = await SharedPreferencesHelper.getSavedTokenMobile();
    print(tokenmobile);

    try {
      // Make the HTTP GET request to get the user ID
      final response = await http.get(
        Uri.parse('http://139.177.200.139:90/api/user-id-by-token'),
        headers: {'tokenmobile': tokenmobile ?? ''},
      );

      // Set loading state to false
      isLoading = false;

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Set the userId directly in the widget
        userId = data['user_id'];

        // Make the HTTP GET request to fetch user details
        final userDetailsResponse = await http.get(
          Uri.parse('http://139.177.200.139:90/api/users/$userId'),
          headers: {'tokenmobile': tokenmobile ?? ''},
        );

        if (userDetailsResponse.statusCode == 200) {
          final Map<String, dynamic> userDetails = json.decode(userDetailsResponse.body);
          // Process the userDetails as needed
          print('User Details: $userDetails');
          return userDetails; // Return user details
        } else {
          print('HTTP Status Code: ${userDetailsResponse.statusCode}');
          throw Exception('Failed to fetch student data');
        }
      } else {
        final message = json.decode(response.body)['message'];
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
        throw Exception('Please refresh');
      }
    } catch (e) {
      // Handle any potential errors
      print('Error: $e');
      throw Exception('Failed to fetch student data');
    }
  }


  Future<void> fetchUserIdmodules() async {
    setState(() {
      isLoading = true;
    });

    tokenmobile = await SharedPreferencesHelper.getSavedTokenMobile();

    final response = await http.get(
      Uri.parse('http://139.177.200.139:90/api/user-id-by-token'),
      headers: {'tokenmobile': tokenmobile ?? ''},
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(userId);
      setState(() {
        userId = data['user_id'];
      });

      fetchUserModules();
    } else {
      final message = json.decode(response.body)['message'];

      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 48.0,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  message,
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> getUserRegistrationStatus() async {
    final dio = Dio();

    try {
      // Retrieve token from SharedPreferences
      final tokenmobile = await SharedPreferencesHelper.getSavedTokenMobile();

      // Make a GET request to the Laravel API endpoint
      final response = await dio.get(
        'http://139.177.200.139:90/api/user-registration-status/$userId', // Replace with your actual API endpoint
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




  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
      child: Column(
        children: [
          Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 400,
                          height: 40,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(10, 10),
                                blurRadius: 10,
                                spreadRadius: -2,
                              ),
                            ],
                          ),
                          child:
                          Column(
                            children: [
                              Center(
                                child:
                                Text(
                                  'MODULES',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: MyMsuTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    letterSpacing: -0.2,
                                    color: MyMsuTheme.darkText,
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Container(
                                    height: 4,
                                    width: 170,
                                    decoration: BoxDecoration(
                                      color: HexColor('#87A0E5').withOpacity(0.9),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0),
                                      ),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: ((70 / 1) * animation!.value),
                                          // height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width - 10,

                          child: isLoading
                              ? Center(
                            child: CircularProgressIndicator(),
                          )
                              : modules.isEmpty
                              ? Center(
                            child: Text(
                              'No Modules Yet',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: MyMsuTheme.darkText,
                              ),
                            ),
                          )
                              : ListView.builder(
                            shrinkWrap: true,
                            itemCount: modules.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Module Name: ${modules[index]['module_name']}',
                                      style: const TextStyle(
                                        fontSize: 10.0,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Module Code: ${modules[index]['module_code']}',
                                      style: const TextStyle(
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ),
                                  if (index < modules.length - 1)
                                    const Divider(
                                      height: 0.05,
                                      color: Colors.grey,
                                    ),
                                ],
                              );
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                  // Other widgets if needed
                ],
              ),


            ],
          ),
          SizedBox(height: 20),



        ],
      ),
    );


  }

}


class SharedPreferencesHelper {
  static const String tokenMobileKey = 'tokenmobile';

  static Future<void> saveTokenMobile(String tokenmobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenMobileKey, tokenmobile);
  }

  static Future<String> getSavedTokenMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenMobileKey) ?? "";
  }

  static Future<void> saveLoggedInUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('user_id', userId);
  }

  static Future<int> getLoggedInUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') ?? 0;
  }
}
