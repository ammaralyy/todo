import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/shared/components/components.dart';
import 'package:task_manager/shared/cubit/cubit.dart';
import 'package:task_manager/shared/cubit/states.dart';

class NewTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
        listener: (context, AppState state) {},
        builder: (context, AppState state) {
          var tasks = AppCubit.get(context).newTasks;

          return ListView.separated(
            itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              color: Colors.grey[300],
              height: 1,
            ),
            itemCount: tasks.length,
          );
        });
  }
}
