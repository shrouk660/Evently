import 'package:evently/core/resources/dialod_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/remote/network/firestore_manager.dart';
import 'package:evently/model/users.dart' as usermodel ;
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
                      return StringsManager.nameCantEmpty;
                    }
                    return null;
                  },
                  hint: StringsManager.enterYourName,
                  prefixPath: AssetsManager.profile,
                  controller: nameController,
                  keyboard: TextInputType.name,
                ),
                SizedBox(height: 16,),
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
                SizedBox(height: 16,),
                CustomField(
                  isPassword: true,
                  validation: (value) {
                    if(value != passController.text){
                      return StringsManager.passwordsDontMatch;
                    }
                    return null;
                  },
                  hint: StringsManager.confirmYourPassword,
                  prefixPath: AssetsManager.lock,
                  controller: confirmPassController,
                  keyboard: TextInputType.text,
                ),
                SizedBox(height: 52,),

                CustomButton(title: StringsManager.signUp, onClick: () {
                  if(formKey.currentState?.validate()??false){
                    createNeweAccount();
                  }
                },),
                SizedBox(height: 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(StringsManager.alreadyHaveAnAccount,style: Theme
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
                        child: Text(StringsManager.login,style:Theme.of(context).textTheme.titleSmall)
                    ),
                  ],
                ),
                SizedBox(height: 25,),
                Ordivider(),
                SizedBox(height: 20,),
                GoogleButton(
                  title: StringsManager.signUpWithGoogle,
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
      FirestoreManager.saveUser(usermodel.Users(
        id: credential.user?.uid,
        name: nameController.text ,
        email: emailController.text,
        favorites: [],

      ));
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(RoutesManager.Home);
    }on FirebaseAuthException catch (e){
      Navigator.of(context).pop();
      if (e.code == StringsManager.weakPassword) {
        DialodUtils.showMassageDialog(context: context, content: StringsManager.thePasswordProvidedIsTooWeak);
      } else if (e.code == StringsManager.emailAlreadyInUse) {
        DialodUtils.showMassageDialog(context: context, content: StringsManager.theAccountAlreadyExistsForThatEmail);
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
        content: StringsManager.googleSignUpFailed,
      );
      print(e.toString());
    }
  }
}
