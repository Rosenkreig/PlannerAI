import 'package:get/get.dart';
import 'package:taskmanager/app/data/providers/task/provider.dart';
import 'package:taskmanager/app/data/services/storage/repository.dart';
import 'package:taskmanager/app/modules/home/controller.dart';

class HomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(
      taskRepository: TaskRepository(
        taskProvider: TaskProvider(),
        ),
      ),
    );
  }
}