import 'package:flutter/material.dart';

abstract class DialodUtils {
   static void showMassageDialog(
       {
         required BuildContext context,
         required String content,
       }
       ){
     showDialog(
         context: context,
         barrierDismissible: false,
         builder: (context) => AlertDialog(
           title: Text("Warning"),
           content:Text(content) ,
           actions: [
             TextButton(onPressed: (){
               Navigator.of(context).pop();

             }, child: Text("OK"))
           ],

         )
     );
   }
   static void showLoadingDialog(BuildContext context){
     showDialog(context: context,
         builder: (context) => AlertDialog(
           content: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               Row(
                 children: [
                   Text("Loading..."),
                   Center(child: CircularProgressIndicator(),)
                 ],
               ),
             ],
           ),
         )
     );

   }
}