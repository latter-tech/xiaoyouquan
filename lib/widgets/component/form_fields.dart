
import 'package:flutter/material.dart';
import '../../common/app_color.dart';
import '../count_down_button.dart';

class FormFields {

  static Widget entryFeild(String hint, {TextEditingController? controller, bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        //autofocus: true,
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: LatterColor.primary)
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  static Widget captchaFeild(
      String hint,
      String type,
      {
        TextEditingController? controller,
        TextEditingController? mobilephoneController
      }) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(children: [
          Expanded(
              child:TextField(
                //autofocus: true,
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: LatterColor.primary)
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              )
          ),
          CountdownButton(
              controller: mobilephoneController,
              type: type
          )
        ])
    );
  }

  static Widget submitButton(BuildContext context, String buttonTxt, Function callback){
    return Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () { callback(); },
          child: Text(buttonTxt,style:TextStyle(color: Colors.white)),
        )
    );
  }

}