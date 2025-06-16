import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:taskmanager/app/core/values/colors.dart';
import 'package:taskmanager/app/data/models/task.dart';
import 'package:taskmanager/app/modules/ai_chat/view.dart';
import 'package:taskmanager/app/modules/home/controller.dart';
import 'package:taskmanager/app/core/utils/extensions.dart';
import 'package:taskmanager/app/modules/home/widgets/add_card.dart';
import 'package:taskmanager/app/modules/home/widgets/add_dialog.dart';
import 'package:taskmanager/app/modules/home/widgets/task_card.dart';
import 'package:taskmanager/app/modules/report/view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            ReportPage(),
            SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(4.0.wp),
                  child: Text(
                    'My List',
                    style : TextStyle(
                    fontSize: 20.0.sp,
                    fontWeight: FontWeight.bold,
                    ),  
                  ),
                ), 
                Obx(
                  () => GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children : [
                      ...controller.tasks
                        .map((element) => LongPressDraggable(
                          data : element,
                          onDragStarted: () => controller.changeDeleting(true),
                          onDraggableCanceled: (_, __) => controller.changeDeleting(false),
                          onDragEnd: (_) => controller.changeDeleting(false),
                          feedback: Opacity(
                            opacity: 0.8, 
                            child: TaskCard(task: element)) ,
                          child: TaskCard(task: element)))
                        .toList(),
                    AddCard()
                  ],
                )
                )
              ],
            ),
          ),
            AIChat()
          ]
        ),
      ),
      floatingActionButton: DragTarget<Task>(
        builder: (_, __, ___) => Obx(
          () => FloatingActionButton(
            backgroundColor: controller.deleting.value ? const Color.fromARGB(255, 167, 102, 97) : Colors.blueGrey,
            foregroundColor: Colors.white,
            onPressed: () {
              if(controller.tasks.isNotEmpty){
                Get.to(() => AddDialog(),transition: Transition.downToUp);
              } else {
                EasyLoading.showInfo("Please create your task type");
              }
              
              
            },
            child: Icon(controller.deleting.value ? Icons.delete : Icons.add),
          ),
        ),
        onAcceptWithDetails: (DragTargetDetails<Task> details) {
          controller.deleteTask(details.data);
          EasyLoading.showSuccess('Delete Success');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Obx(() => BottomNavigationBar(
            onTap: (int index) => controller.changeTabIndex(index),
            currentIndex: controller.tabIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                label: 'Report',
                icon: Icon(Icons.data_usage),
                ),
                BottomNavigationBarItem(
                label: 'Home',
                icon:  Icon(Icons.home),
                ),
              BottomNavigationBarItem(
                label: 'AIChat',
                icon: Icon(Icons.auto_awesome),
                ),
          
          
            ],
          ),
        ),
      ),
    );
  }
}