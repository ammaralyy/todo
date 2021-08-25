import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/shared/components/components.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/shared/cubit/cubit.dart';
import 'package:task_manager/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, AppState state) {
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (context, AppState state) {

          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.appTitle[cubit.currentIndex],
              ),
            ),
            body: state is! AppGetDatabaseLoadingState
                ? cubit.screens[cubit.currentIndex]
                : Center(child: CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                }
                else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: EdgeInsets.all(20),
                          color: Colors.grey[100],
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                customFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Title must be added!';
                                    }
                                    return null;
                                  },
                                  label: 'Task Title',
                                  prefix: Icons.title,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                customFormField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                    print('Time taped');
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Time must be added!';
                                    }
                                    return null;
                                  },
                                  label: 'Task Time',
                                  prefix: Icons.watch_later_outlined,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                customFormField(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2021, 9, 25),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                      print(DateFormat.yMMMd().format(value));
                                    });
                                    print('Date taped');
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Date must be added!';
                                    }
                                    return null;
                                  },
                                  label: 'Date Time',
                                  prefix: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit
                    );
                    // setState(() {
                    //   floatingActionButtonIcon = Icons.edit;
                    // });
                  });
                  cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add);
                }
              },
              child: Icon(cubit.floatingActionButtonIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  print(index);
                  cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archived',
                  ),
                ]),
          );
        },
      ),
    );
  }

}
