import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/app/core/utils/extensions.dart';
import 'package:taskmanager/app/modules/home/controller.dart';


class DoingList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
   DoingList({Key? key}) : super(key: key);



@override
  Widget build(BuildContext context) {
    
    return Obx(
      () => homeCtrl.doingTodos.isEmpty && homeCtrl.doneTodos.isEmpty
          ? Column(
              children: [
                
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.0.wp,
                    horizontal: 4.0.wp,
                  ),
                  child: Text('Add a Task to Get Started',
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),),
                )
              ],
          ): ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              ...homeCtrl.doingTodos
              .map((element) => Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 2.0.wp,
                  horizontal: 8.0.wp,
                  ),
                child: Row(
                  children: [
                  SizedBox(
                    width: 4.0.wp,
                    height: 4.0.wp,
                    child: Checkbox(
                      //fillColor: MaterialStateProperty.resolveWith((states) => Colors.grey),
                      value: element['done'],
                      onChanged: (value) {
                        homeCtrl.doneTodo(element['title']);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.0.wp,
                    ),
                    child: Text(element['title'],
                    overflow: TextOverflow.ellipsis,),
                  )
                ],
                ),
              )
              ),
              if(homeCtrl.doingTodos.isNotEmpty) Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 2.0.wp,
                  horizontal: 4.0.wp,
                ),
                child: Divider(thickness: 2, color: Colors.grey[300]),
              )
            ],

          ));
  }
}