
import 'package:evently/core/resources/dialod_utils.dart';
import 'package:evently/core/resources/routes_manager.dart';
import 'package:evently/core/reusable_components/google_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/resources/app_constants.dart';
import '../../../core/resources/assets_manager.dart';
import '../../../core/resources/google_auth_service.dart';
import '../../../core/resources/string_manager.dart';
import '../../../core/reusable_components/OrDivider.dart';
import '../../../core/reusable_components/custom_button.dart';
import '../../../core/reusable_components/custom_field.dart';
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController emailController;
  late TextEditingController passController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    passController = TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(AssetsManager.logo,
          color: Theme.of(context).colorScheme.primary,
          width: screenWidth*0.45,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(StringsManager.loginTitle,style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600
                ),),
                SizedBox(height: 24,),
                CustomField(
                  validation: (value) {
                    if(value==null || value.isEmpty){
                      return StringsManager.emailCantEmpty;
                    }
                    if(!RegExp(AppConstants.emailRegex).hasMatch(value)){
                      return StringsManager.invalidEmail;
                    }
                    return null;
                  },
                  hint: StringsManager.enterYourEmail,
                  prefixPath: AssetsManager.email,
                  controller: emailController,
                  keyboard: TextInputType.emailAddress,
                ),
                SizedBox(height: 16,),
                CustomField(
                  validation: (value) {
                    if(value==null || value.isEmpty){
                      return StringsManager.passwordCantEmpty;
                    }
                    if(value.length<8){
                      return StringsManager.passwordCantBeLessThan8Characters;
                    }
                    return null;
                  },
                  isPassword: true,
                  hint: StringsManager.enterYourPassword,
                  prefixPath: AssetsManager.lock,
                  controller: passController,
                  keyboard: TextInputType.text,
                ),
                SizedBox(height: 8,),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: (){
                    Navigator.of(context).pushNamed(RoutesManager.forgetPass);

                    },
                    child: Text(StringsManager.forgetPassword,style:Theme.of(context).textTheme.titleSmall)
                  ),
                ),
                SizedBox(height: 48,),
                CustomButton(title: StringsManager.login, onClick: () {
                  if(formKey.currentState?.validate()??false){
                    SignIn();
                  }
                },),
                SizedBox(height: 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(StringsManager.dontHaveAnAccount,style: Theme
                        .of(context)
                        .textTheme
                        .bodySmall?.copyWith(
                        fontSize: 14
                    ),),
                    TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: (){
                          Navigator.of(context).pushReplacementNamed(RoutesManager.signup);
                        },
                        child: Text(StringsManager.signup,style:Theme.of(context).textTheme.titleSmall)
                    ),
                  ],
                ),
                SizedBox(height: 32,),
                Ordivider(),
                SizedBox(height: 24,),
                GoogleButton(
                  title: StringsManager.loginWithGoogle,
                  onClick: googleSignIn,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  SignIn()async{
    try {
      DialodUtils.showLoadingDialog(context);
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passController.text
      );
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(RoutesManager.Home);
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      if (e.code == StringsManager.userNotFound) {
        DialodUtils.showMassageDialog(context: context, content: StringsManager.noUserFoundForThatEmail);
      } else if (e.code == StringsManager.wrongPassword) {
        DialodUtils.showMassageDialog(context: context, content: StringsManager.wrongPasswordProvidedForThatUser);
      }
      print(e.toString());
    }

  }
  Future<void> googleSignIn() async {
    try {
      final credential = await GoogleAuthService.signIn();
      if (credential == null) return;
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(RoutesManager.Home);
    } catch (e) {
      if (!mounted) return;
      DialodUtils.showMassageDialog(
        context: context,
        content: StringsManager.googleSignInFailed,
      );
      print(e.toString());
    }
  }
}
