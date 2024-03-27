import 'package:flutter/material.dart';
import 'package:newmsu/screens/welcome/welcome_animation.dart';
import '../../components/forward_button.dart';
import '../../components/header_text.dart';
import '../../components/trapozoid_cut_colored_image.dart';
import '../../utility/app_constant.dart';
import '../../utility/color_utility.dart';

abstract class GoToLoginListener {
  void onGoAheadTap();
}

class WelcomePage extends StatelessWidget {
  WelcomePage(
      {required AnimationController controller,
      required this.goTOLoginListener})
      : welcomeEnterAnimation =  WelcomeEnterAnimation(controller);

  final WelcomeEnterAnimation welcomeEnterAnimation;
  final GoToLoginListener goTOLoginListener;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Stack(
      children: <Widget>[
        _trapoziodView(size, textTheme),
        _buttonContainer(size),
      ],
    );
  }

  Widget _trapoziodView(Size size, TextTheme textTheme) {
    return Transform(
      transform: Matrix4.translationValues(
          0.0, -welcomeEnterAnimation.translation.value * size.height, 0.0),
      child: TrapozoidTopBar(
          child: Container(
        height: size.height * 0.7,
        color: Color(getColorHexFromStr('#E8F2F4')),
        child: Stack(
          children: <Widget>[
            _buildBackgroundImage(),
            _buildTextHeader(size, textTheme),
          ],
        ),
      )),
    );
  }

  Widget _buttonContainer(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.8),
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Transform(
                  transform: Matrix4.translationValues(
                      -welcomeEnterAnimation.translation.value * 200, 0.0, 0.0),
                  child: HeaderText(
                    text:'WELCOME',
                    imagePath: IMAGE_SLIPPER_PATH,
                  )),
            ),
            const SizedBox(
              width: 16,
            ),
            Transform(
              transform: Matrix4.translationValues(
                  welcomeEnterAnimation.translation.value * 200, 0.0, 0.0),
              child: ForwardButton(
                onPressed: () {
                  goTOLoginListener.onGoAheadTap();
                },
                label: BUTTON_GOAHEAD,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration:  BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
            image:  AssetImage(IMAGE_WELCOME_PATH),
            fit: BoxFit.cover,
          )),
    );
  }

  Widget _buildTextHeader(Size size, TextTheme textTheme) {
    return FadeTransition(
      opacity: welcomeEnterAnimation.titleLabelOpacity,
      child: Padding(
        padding: EdgeInsets.only(top: size.height * 0.15, left: 24, right: 24),
        child: Container(
          width: double.infinity,
          child: Text(
           '',
            style: textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.normal,
                wordSpacing: 1.2),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
