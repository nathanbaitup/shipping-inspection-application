import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/utils/colours.dart';
import 'package:shipping_inspection_app/utils/back_button.dart';
import 'package:shipping_inspection_app/utils/textfield.dart';

class AddTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
        padding: const EdgeInsets.fromLTRB(
        0,
        20,
        0,
        20,
    ),
        child: Column(
          children: <Widget>[
            Padding(child: MyBackButton(),
              padding: EdgeInsets.only(left: 20),

            ),
            SizedBox(height: 30.0),
            Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              child: appTextField(
                                label: 'Title',
                              )),
                          SizedBox(width: 40),

                        ],
                      ),
                      SizedBox(height: 20),
                      appTextField(
                        maxLines: 3,
                        label: 'Description',
                        minLines: 3,

                      ),
                      SizedBox(height: 15),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Stage',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                  fontWeight:FontWeight.w500

                              ),
                            ),
                            SizedBox(height: 10),

                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              //direction: Axis.vertical,
                              runSpacing: 0,
                              verticalDirection: VerticalDirection.down,
                              alignment: WrapAlignment.start,


                              //textDirection: TextDirection.rtl,
                              spacing: 10.0,
                              children: <Widget>[
                                Chip(
                                  labelStyle: TextStyle(color: Colors.white),
                                  backgroundColor: LightColors.sRed,
                                    label: Container(
                                      padding: EdgeInsets.all(7),

                                      child: Text("To-Do"),
                                    )

                                ),
                                Chip(
                                  backgroundColor: LightColors.sDarkYellow,
                                  label: Container(
                                    padding: EdgeInsets.all(7),
                                    child: Text("In Progress"),
                                  )

                                ),
                                Chip(
                                    labelStyle: TextStyle(color: Colors.white),
                                    backgroundColor: LightColors.sBlue,
                                    label: Container(
                                      padding: EdgeInsets.all(7),

                                      child: Text("Done"),
                                )

                                ),

                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            Container(
              width: width,
              height: 80,

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Create Task',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,

                          fontSize: 18),
                    ),

                    width: width - 40,
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: LightColors.sPurple,
                      borderRadius: BorderRadius.circular(30),

                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        )
      ),
    );
  }
}