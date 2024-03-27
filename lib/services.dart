// Future<void> fetchUserIdmodules() async {
//   setState(() {
//     isLoading = true;
//   });
//
//   tokenmobile = await SharedPreferencesHelper.getSavedTokenMobile();
//
//
//   final response = await http.get(
//     Uri.parse('http://139.177.200.139:90/api/user-id-by-token'),
//     headers: {'tokenmobile': tokenmobile ?? ''},
//   );
//
//   setState(() {
//     isLoading = false;
//   });
//
//   if (response.statusCode == 200) {
//     final Map<String, dynamic> data = json.decode(response.body);
//     print(userId);
//     setState(() {
//       userId = data['user_id'];
//     });
//
//
//     fetchUserModules();
//   } else {
//     final message = json.decode(response.body)['message'];
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }
// Future<Map<String, dynamic>> getUserRegistrationStatus() async {
//   final dio = Dio();
//
//   try {
//     // Retrieve token from SharedPreferences
//     final tokenmobile = await SharedPreferencesHelper.getSavedTokenMobile();
//
//     // Make a GET request to the Laravel API endpoint
//     final response = await dio.get(
//       'http://139.177.200.139:90/api/user-registration-status/$userId', // Replace with your actual API endpoint
//       options: Options(
//         headers: {
//           'tokenmobile': tokenmobile,
//         },
//       ),
//     );
//
//     // Check if the response status is OK (200)
//     if (response.statusCode == 200) {
//       // Parse the response JSON
//       final Map<String, dynamic> data = response.data;
//       return data;
//     } else {
//       // Handle non-OK response
//       print('Error: ${response.statusCode}');
//       return {'status': 0, 'message': 'Failed to fetch user registration status'};
//     }
//   } catch (error) {
//     // Handle Dio errors
//     print('Dio Error: $error');
//     return {'status': 0, 'message': 'Failed to fetch user registration status'};
//   }
// }
//
// Future<void> fetchUserModules() async {
//   try {
//     setState(() {
//       isLoading = true;
//     });
//
//     // Make an HTTP request to retrieve user modules
//     final response = await http.get(
//       Uri.parse('http://139.177.200.139:90/api/user-modules/$userId'),
//       headers: {'tokenmobile': tokenmobile ?? ''},
//     );
//
//     setState(() {
//       isLoading = false;
//     });
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       setState(() {
//         modules = data['modules'];
//         tokenmobile = response.headers['tokenmobile'];
//       });
//     } else {
//       final message = json.decode(response.body)['message'];
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   } catch (error) {
//     // Handle network or other errors
//     print('Error: $error');
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Error'),
//         content: Text('An error occurred. Please try again.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// Future<Map<String, dynamic>> fetchUserId(BuildContext context) async {
//   // Set initial loading state
//   isLoading = true;
//
//   // Retrieve token from SharedPreferences
//   tokenmobile = await SharedPreferencesHelper.getSavedTokenMobilenew();
//   print(tokenmobile);
//
//   try {
//     // Make the HTTP GET request to get the user ID
//     final response = await http.get(
//       Uri.parse('http://139.177.200.139:90/api/user-id-by-token'),
//       headers: {'tokenmobile': tokenmobile ?? ''},
//     );
//
//     // Set loading state to false
//     isLoading = false;
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//
//       // Set the userId directly in the widget
//       userId = data['user_id'];
//
//       // Make the HTTP GET request to fetch user details
//       final userDetailsResponse = await http.get(
//         Uri.parse('http://139.177.200.139:90/api/users/$userId'),
//         headers: {'tokenmobile': tokenmobile ?? ''},
//       );
//
//       if (userDetailsResponse.statusCode == 200) {
//         final Map<String, dynamic> userDetails = json.decode(userDetailsResponse.body);
//         // Process the userDetails as needed
//         print('User Details: $userDetails');
//         return userDetails; // Return user details
//       } else {
//         print('HTTP Status Code: ${userDetailsResponse.statusCode}');
//         throw Exception('Failed to fetch user details');
//       }
//     } else {
//       final message = json.decode(response.body)['message'];
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//       throw Exception('Failed to fetch user ID');
//     }
//   } catch (e) {
//     // Handle any potential errors
//     print('Error: $e');
//     throw Exception('Failed to fetch user details');
//   }
// }
//
//
//
// Future<void> fetchUserIdmodules() async {
//   setState(() {
//     isLoading = true;
//   });
//
//   tokenmobile = await SharedPreferencesHelper.getSavedTokenMobile();
//
//
//   final response = await http.get(
//     Uri.parse('http://139.177.200.139:90/api/user-id-by-token'),
//     headers: {'tokenmobile': tokenmobile ?? ''},
//   );
//
//   setState(() {
//     isLoading = false;
//   });
//
//   if (response.statusCode == 200) {
//     final Map<String, dynamic> data = json.decode(response.body);
//     print(userId);
//     setState(() {
//       userId = data['user_id'];
//     });
//
//
//     fetchUserModules();
//   } else {
//     final message = json.decode(response.body)['message'];
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }
// Future<Map<String, dynamic>> getUserRegistrationStatus() async {
//   final dio = Dio();
//
//   try {
//     // Retrieve token from SharedPreferences
//     final tokenmobile = await SharedPreferencesHelper.getSavedTokenMobile();
//
//     // Make a GET request to the Laravel API endpoint
//     final response = await dio.get(
//       'http://139.177.200.139:90/api/user-registration-status/$userId', // Replace with your actual API endpoint
//       options: Options(
//         headers: {
//           'tokenmobile': tokenmobile,
//         },
//       ),
//     );
//
//     // Check if the response status is OK (200)
//     if (response.statusCode == 200) {
//       // Parse the response JSON
//       final Map<String, dynamic> data = response.data;
//       return data;
//     } else {
//       // Handle non-OK response
//       print('Error: ${response.statusCode}');
//       return {'status': 0, 'message': 'Failed to fetch user registration status'};
//     }
//   } catch (error) {
//     // Handle Dio errors
//     print('Dio Error: $error');
//     return {'status': 0, 'message': 'Failed to fetch user registration status'};
//   }
// }
// Future<void> fetchUserModules() async {
//   try {
//     setState(() {
//       isLoading = true;
//     });
//
//     // Make an HTTP request to retrieve user modules
//     final response = await http.get(
//       Uri.parse('http://139.177.200.139:90/api/user-modules/$userId'),
//       headers: {'tokenmobile': tokenmobile ?? ''},
//     );
//
//     setState(() {
//       isLoading = false;
//     });
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       setState(() {
//         modules = data['modules'];
//         tokenmobile = response.headers['tokenmobile'];
//       });
//     } else {
//       final message = json.decode(response.body)['message'];
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   } catch (error) {
//     // Handle network or other errors
//     print('Error: $error');
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Error'),
//         content: Text('An error occurred. Please try again.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
// Future<Map<String, dynamic>> fetchUserDetails(BuildContext context) async {
//   try {
//     // Set initial loading state
//     setState(() {
//       isLoading = true;
//     });
//
//     // Retrieve token from SharedPreferences
//     tokenmobile = await SharedPreferencesHelper.getSavedTokenMobile();
//     print(tokenmobile);
//
//     // Make the HTTP GET request to get the user ID
//     final response = await http.get(
//       Uri.parse('http://139.177.200.139:90/api/user-id-by-token'),
//       headers: {'tokenmobile': tokenmobile ?? ''},
//     );
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//
//       // Set the userId
//       setState(() {
//         userId = data['user_id'];
//       });
//
//       // Make the HTTP GET request to fetch user details
//       final userDetailsResponse = await http.get(
//         Uri.parse('http://139.177.200.139:90/api/users/$userId'),
//         headers: {'tokenmobile': tokenmobile ?? ''},
//       );
//
//       if (userDetailsResponse.statusCode == 200) {
//         final Map<String, dynamic> userDetails = json.decode(userDetailsResponse.body);
//         // Process the userDetails as needed
//         print('User Details: $userDetails');
//         return userDetails; // Return user details
//       } else {
//         print('HTTP Status Code: ${userDetailsResponse.statusCode}');
//         throw Exception('Failed to fetch user details');
//       }
//     } else {
//       final message = json.decode(response.body)['message'];
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//       throw Exception('Failed to fetch user ID');
//     }
//   } catch (e) {
//     // Handle any potential errors
//     print('Error: $e');
//     throw Exception('Failed to fetch user details');
//   } finally {
//     // Reset loading state
//     setState(() {
//       isLoading = false;
//     });
//   }
// }
//
//
// Padding(
// padding: const EdgeInsets.only(
// left: 24, right: 24, top: 8, bottom: 16),
// child: Row(
// children: <Widget>[
// Expanded(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: <Widget>[
// Text(
// 'PROGRAM',
// textAlign: TextAlign.center,
// style: TextStyle(
// fontFamily: MyMsuTheme.fontName,
// fontWeight: FontWeight.w500,
// fontSize: 14,
// letterSpacing: -0.2,
// color: MyMsuTheme.darkText,
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4),
// child: Container(
// height: 4,
// width: 70,
// decoration: BoxDecoration(
// color:
// HexColor('#87A0E5').withOpacity(0.2),
// borderRadius: const BorderRadius.all(
// Radius.circular(4.0)),
// ),
// child: Row(
// children: <Widget>[
// Container(
// width: ((70 / 1) * animation!.value),
// height: 4,
// decoration: BoxDecoration(
// gradient: LinearGradient(colors: [
// HexColor('#208f07'),
// HexColor('#208f07')
//     .withOpacity(0.5),
// ]),
// borderRadius: const BorderRadius.all(
// Radius.circular(4.0)),
// ),
// )
// ],
// ),
// ),
// ),
//
// FutureBuilder<Map<String, dynamic>>(
// future: fetchUserId(context),
// builder: (context, snapshot) {
// if (snapshot.connectionState == ConnectionState.waiting) {
// return CircularProgressIndicator();
// } else if (snapshot.hasError) {
// // Print the actual error message
// print('Error: ${snapshot.error}');
// return Text('Error: ${snapshot.error}');
// } else {
// // User details are available
// Map<String, dynamic> user = snapshot.data!;
//
// // Extract specific details
// String programName = user['student']['program_name'] ?? 'N/A';
// String levelName = user['student']['level_name'] ?? 'N/A';
// String attendanceTypeName = user['student']['attendance_type_name'] ?? 'N/A';
// return Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Padding(
// padding: const EdgeInsets.only(top: 6),
// child:
//
// Text(
// '$programName',
// textAlign: TextAlign.center,
// style: TextStyle(
// fontFamily: MyMsuTheme.fontName,
// fontWeight: FontWeight.w600,
// fontSize: 12,
// color:
// MyMsuTheme.grey.withOpacity(0.5),
// ),
// ),
// ),
// SizedBox(
// width: 4,
// height: 15,
// ),
//
// Padding(
// padding: const EdgeInsets.only(
// left: 0, right: 24, top: 8, bottom: 16),
// child: Row(
// children: <Widget>[
// Expanded(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: <Widget>[
// Text(
// 'ATTENDANCE TYPE',
// textAlign: TextAlign.center,
// style: TextStyle(
// fontFamily: MyMsuTheme.fontName,
// fontWeight: FontWeight.w500,
// fontSize: 14,
// letterSpacing: -0.2,
// color: MyMsuTheme.darkText,
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4),
// child: Container(
// height: 4,
// width: 70,
// decoration: BoxDecoration(
// color:
// HexColor('#87A0E5').withOpacity(0.2),
// borderRadius: const BorderRadius.all(
// Radius.circular(4.0)),
// ),
// child: Row(
// children: <Widget>[
// Container(
// width: ((70 / 1) * animation!.value),
// height: 4,
// decoration: BoxDecoration(
// gradient: LinearGradient(colors: [
// HexColor('#208f07'),
// HexColor('#208f07')
//     .withOpacity(0.5),
// ]),
// borderRadius: const BorderRadius.all(
// Radius.circular(4.0)),
// ),
// )
// ],
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 6),
// child: Text(
// '$attendanceTypeName',
// textAlign: TextAlign.center,
// style: TextStyle(
// fontFamily: MyMsuTheme.fontName,
// fontWeight: FontWeight.w600,
// fontSize: 12,
// color:
// MyMsuTheme.grey.withOpacity(0.5),
// ),
// ),
// ),
// ],
// ),
// ),
// SizedBox(
// width: 4,
// ),
//
//
// ],
// ),
// ),
// SizedBox(
// width: 4,
// ),
//
// Padding(
// padding: const EdgeInsets.only(
// left: 0, right: 24, top: 8, bottom: 16),
// child: Row(
// children: <Widget>[
// Expanded(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: <Widget>[
// Text(
// 'LEVEL',
// textAlign: TextAlign.center,
// style: TextStyle(
// fontFamily: MyMsuTheme.fontName,
// fontWeight: FontWeight.w500,
// fontSize: 14,
// letterSpacing: -0.2,
// color: MyMsuTheme.darkText,
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4),
// child: Container(
// height: 4,
// width: 70,
// decoration: BoxDecoration(
// color:
// HexColor('#87A0E5').withOpacity(0.2),
// borderRadius: const BorderRadius.all(
// Radius.circular(4.0)),
// ),
// child: Row(
// children: <Widget>[
// Container(
// width: ((70 / 1) * animation!.value),
// height: 4,
// decoration: BoxDecoration(
// gradient: LinearGradient(colors: [
// HexColor('#208f07'),
// HexColor('#208f07')
//     .withOpacity(0.5),
// ]),
// borderRadius: const BorderRadius.all(
// Radius.circular(4.0)),
// ),
// )
// ],
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 6),
// child: Text(
// '$levelName',
// textAlign: TextAlign.center,
// style: TextStyle(
// fontFamily: MyMsuTheme.fontName,
// fontWeight: FontWeight.w600,
// fontSize: 12,
// color:
// MyMsuTheme.grey.withOpacity(0.5),
// ),
// ),
// ),
// ],
// ),
// ),
// SizedBox(
// width: 4,
// ),
// ],
// ),
// ),
//
// SizedBox(
// width: 4,
// height: 15,
// ),
//
//
// ],
// );
//
// }
// },
// ),
//
// ],
// ),
// ),
//
// ],
// ),
// ),