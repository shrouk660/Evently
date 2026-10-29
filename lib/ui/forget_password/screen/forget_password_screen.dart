import 'package:evently/core/resources/assets_manager.dart';
import 'package:evently/core/resources/string_manager.dart';
import 'package:evently/core/reusable_components/arrow_icon.dart';
import 'package:evently/core/reusable_components/custom_button.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: ArrowIcon(
            icon: AssetsManager.arrowLeft,
            onClick: Navigator.of(context).pop,
          ),
        ),
        title: Text(StringsManager.ForgetPassword,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            SizedBox(height: 32,),
            Image.asset(AssetsManager.forgetPass,
                fit: BoxFit.contain,
                color: Theme.of(context).colorScheme.onPrimary
            ),
            SizedBox(height: 45,),
            CustomButton(
                title: StringsManager.resetPassword,
                onClick: (){

                }
            )

          ],
        ),
      ),
    );
  }
}
