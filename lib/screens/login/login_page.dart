import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../apiservice.dart';
import '../../components/forward_button.dart';
import '../../components/header_text.dart';
import '../../components/trapozoid_cut_colored_image.dart';
import '../../goto_welcome_listener.dart';
import '../../utility/app_constant.dart';
import '../../utility/color_utility.dart';
import '../home/home.dart';
import 'activationcode.dart';
import 'login_animation.dart';



class LoginPage extends StatefulWidget {
  final AnimationController controller;
  final GoToWelcomeListener goToWelcomeListener;

  LoginPage({
    required this.controller,
    required this.goToWelcomeListener,

  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginEnterAnimation enterAnimation;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String regnum = '';
  final TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    enterAnimation = LoginEnterAnimation(widget.controller);
  }




  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    return Stack(
      key: _scaffoldKey,
      children: <Widget>[
        _trapoziodView(size, textTheme),
        _buttonContainer(context, size, textTheme),
      ],
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
                child: _buildTextFormUsername(textTheme),
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

  Widget _buildTextFormUsername(TextTheme textTheme) {
    return FadeTransition(
      opacity: enterAnimation.userNameOpacity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.blueAccent,
            width: 1.5,
          ),
        ),
        child: TextFormField(
          style: textTheme
              .bodyMedium
              ?.copyWith(color: Colors.black87, letterSpacing: 1.2),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: PHONE_AUTH_HINT,
            hintStyle:
            textTheme.bodyMedium?.copyWith(color: Colors.grey),
            icon: const Icon(
              Icons.person,
              color: Colors.black87,
            ),
            contentPadding: EdgeInsets.zero,
          ),
          keyboardType: TextInputType.text,
          controller: emailController,
          validator: (val) =>
          val?.length == 0
              ? PHONE_AUTH_VALIDATION_EMPTY
              : val!.length < 10 ? PHONE_AUTH_VALIDATION_INVALID : null,
        ),
      ),
    );
  }

  Widget _buttonContainer(BuildContext context, Size size,
      TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.8),
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildSocialMediaAppButton(
              COLOR_GOOGLE,
              IMAGE_PATH_GOOGLE,
              40,
              enterAnimation.googleScaleTranslation.value,
            ),
            SizedBox(
              width: 8,
            ),
            _buildSocialMediaAppButton(
              COLOR_FACEBOOK,
              IMAGE_PATH_FACEBOOK,
              48,
              enterAnimation.facebookScaleTranslation.value,
            ),
            SizedBox(
              width: 8,
            ),
            _buildSocialMediaAppButton(
              COLOR_TWITTER,
              IMAGE_PATH_TWITTER,
              56,
              enterAnimation.twitterScaleTranslation.value,
            ),
            SizedBox(
              width: size.width * 0.1,
            ),
            Transform(
              transform: Matrix4.translationValues(
                enterAnimation.translation.value * 200,
                0.0,
                0.0,
              ),
              child: ForwardButton(
                onPressed: () {
                  String regnum = emailController.text;
                  String code = codeController.text;

                  // Validate if regnum is not empty
                  if (regnum.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CodeActivation(
                          controller: widget.controller,
                          goToWelcomeListener: widget.goToWelcomeListener,
                          regnum: regnum,

                        ),
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Please enter regnum',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                },
                label: BUTTON_PROCEED,
              ),
            ),
          ],
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
        child: HeaderText(
          text: TEXT_MSU_LABEL,
          imagePath: IMAGE_SLIPPER_PATH,
        ),
      ),
    );
  }
}