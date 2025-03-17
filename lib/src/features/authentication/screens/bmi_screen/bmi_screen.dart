import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/src/common_widget/field_form_widget.dart';
import 'package:login/src/features/authentication/models/Field_form_model.dart';

import '../../../../repository/authentication_repository/authentication_repository.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  String result=''.trim();
  var ht = TextEditingController();
  var wt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;




    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Stack(
          children: [Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormFieldWidget(model: Fieldformmodel(field: ht, label: "Enter Height", preicon: Icons.height_outlined)),
              SizedBox(height: 10,),
              FormFieldWidget(model: Fieldformmodel(field: wt, label: "Enter Weight", preicon: Icons.line_weight_outlined,)),
              SizedBox(height: 20,),
              SizedBox(
                  height: 60,
                  width: size.width,
                  child: ElevatedButton(
                      onPressed: () {
                        var kht=ht.text.toString();
                        var kwt=wt.text.toString();

                        if(kht!='' && kwt!=''){
                          var iht=double.parse(kht);
                          var iwt=double.parse(kwt);
                          var bmi = iwt/(iht*iht);
                          setState(() {
                            result=bmi.toString();
                          });


                        }
                        else{
                          Get.snackbar('Empty', 'Please fill all the fields');
                        }
                      },
                      child: Text(
                        "Calculate",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ))),

              SizedBox(height: 30,),

             Container(height: 70,width: size.width,decoration: BoxDecoration(border: Border.all(width: 2),borderRadius: BorderRadius.circular(8)), child: Center(child: Text(result,style: Theme.of(context).textTheme.bodyLarge,)),)
            ],
          ),
            Positioned(right: 0,top: 0, child:  ElevatedButton.icon(onPressed: () {AuthenticationRepository.instance.logout();},icon: Icon(Icons.keyboard_backspace_rounded), label:  Text("Logout")),)

          ]
        ),
      ),
    ));
  }
}
