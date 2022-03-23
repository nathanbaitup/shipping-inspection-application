import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

import 'package:shipping_inspection_app/utils/colours.dart';

class ARIntroduction extends StatefulWidget {
  const ARIntroduction({Key? key}) : super(key: key);

  @override
  _ARIntroductionState createState() => _ARIntroductionState();
}

class _ARIntroductionState extends State<ARIntroduction> {
  @override
  void initState() {
    super.initState();
    materialButton = _nextButton;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: LightColors.sPurple,
          secondary: LightColors.sPurpleLL,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Onboarding(
        pages: onboardingPagesList,
        onPageChange: (int pageIndex) => _buildButton(pageIndex),
        footer: Footer(
          child: materialButton,
          indicator: Indicator(
            indicatorDesign: IndicatorDesign.line(
              lineDesign: LineDesign(
                lineType: DesignType.line_uniform,
              ),
            ),
          ),
          footerPadding: const EdgeInsets.all(45.0),
        ),
      ),
    );
  }

  late Material materialButton;

  // REFERENCE accessed 23/03/2022 https://pub.dev/packages/onboarding
  // Used to create the next and finish buttons.
  void _buildButton(int pageIndex) {
    if (pageIndex == 2) {
      setState(() {
        materialButton = _finishButton;
      });
    } else {
      setState(() {
        materialButton = _nextButton;
      });
    }
  }

  Material get _nextButton {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: defaultSkipButtonColor,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {},
        child: const Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Next',
            style: defaultSkipButtonTextStyle,
          ),
        ),
      ),
    );
  }

  Material get _finishButton {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: defaultProceedButtonColor,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () {},
        child: const Padding(
          padding: defaultProceedButtonPadding,
          child: Text(
            'Finish and Enter AR view',
            style: defaultProceedButtonTextStyle,
          ),
        ),
      ),
    );
  }
  // END REFERENCE

  // REFERENCE accessed 23/03/2022 https://pub.dev/packages/onboarding
  // Used template to create on-boarding widget with instructions on how to use the AR scene.
  final onboardingPagesList = [
    PageModel(
      widget: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 45.0,
              vertical: 45.0,
            ),
            child: Image.asset('images/avatar.png'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 45.0,
            ),
            alignment: Alignment.center,
            child: const Text(
              'Welcome to the AR Viewer.',
              style: pageTitleStyle,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 45.0,
              vertical: 15.0,
            ),
            alignment: Alignment.center,
            child: const Text(
              'This guide will give you all the information needed to interact with and use the AR viewer.',
              style: pageInfoStyle,
            ),
          ),
        ],
      ),
    ),
  ];
}
