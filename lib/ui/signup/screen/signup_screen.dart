import 'package:evently/core/resources/dialod_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/resources/app_constants.dart';
import '../../../core/resources/assets_manager.dart';
import '../../../core/resources/google_auth_service.dart';
import '../../../core/resources/routes_manager.dart';
import '../../../core/resources/string_manager.dart';
import '../../../core/reusable_components/OrDivider.dart';
import '../../../core/reusable_components/custom_button.dart';
import '../../../core/reusable_components/custom_field.dart';
import '../../../core/reusable_components/google_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passController;
  late TextEditingController confirmPassController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passController = TextEditingController();
    confirmPassController = TextEditingController();
  }
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
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
                Text(StringsManager.createAccTitle,style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600
                ),),
                SizedBox(height: 24,),
                CustomField(
                  validation: (value) {
                    if(value==null || value.isEmpty){
                      return "Name can't empty";
                    }
                    return null;
                  },
                  hint: "Enter your name",
                  prefixPath: AssetsManager.profile,
                  controller: nameController,
                  keyboard: TextInputType.name,
                ),
                SizedBox(height: 16,),
                CustomField(
                  validation: (value) {
                    if(value==null || value.isEmpty){
                      return "Email can't empty";
                    }
                    if(!RegExp(AppConstants.emailRegex).hasMatch(value)){
                      return "Invalid email";
                    }
                    return null;
                  },
                  hint: "Enter your email",
                  prefixPath: AssetsManager.email,
                  controller: emailController,
                  keyboard: TextInputType.emailAddress,
                ),
                SizedBox(height: 16,),
                CustomField(
                  validation: (value) {
                    if(value==null || value.isEmpty){
                      return "Password can't empty";
                    }
                    if(value.length<8){
                      return "Password can't be less than 8 characters";
                    }
                    return null;
                  },
                  isPassword: true,
                  hint: "Enter your password",
                  prefixPath: AssetsManager.lock,
                  controller: passController,
                  keyboard: TextInputType.text,
                ),
                SizedBox(height: 16,),
                CustomField(
                  isPassword: true,
                  validation: (value) {
                    if(value != passController.text){
                      return "Passwords don't match";
                    }
                    return null;
                  },
                  hint: "Confirm your password",
                  prefixPath: AssetsManager.lock,
                  controller: confirmPassController,
                  keyboard: TextInputType.text,
                ),
                SizedBox(height: 52,),

                CustomButton(title: "Sign Up", onClick: () {
                  if(formKey.currentState?.validate()??false){
                    createNeweAccount();
                  }
                },),
                SizedBox(height: 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",style: Theme
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
                          Navigator.of(context).pushReplacementNamed(RoutesManager.signin);
                        },
                        child: Text("Login",style:Theme.of(context).textTheme.titleSmall)
                    ),
                  ],
                ),
                SizedBox(height: 25,),
                Ordivider(),
                SizedBox(height: 20,),
                GoogleButton(
                  title: "Sign up with Google",
                  onClick: googleSignIn,
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

   Future<void> createNeweAccount()async{
    try {
      DialodUtils.showLoadingDialog(context);
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passController.text
      );
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(RoutesManager.Home);
    }on FirebaseAuthException catch (e){
      Navigator.of(context).pop();
      if (e.code == "weak-password") {
        DialodUtils.showMassageDialog(context: context, content: "The password provided is too weak.");
      } else if (e.code == "email-already-in-use") {
        DialodUtils.showMassageDialog(context: context, content: "The account already exists for that email.");
      }

    } catch(e){
      print("Error catch $e");

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
        content: "Google sign up failed",
      );
      print(e.toString());
    }
  }
}
