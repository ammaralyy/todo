import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/modules/archived_tasks.dart';
import 'package:task_manager/modules/done_tasks.dart';
import 'package:task_manager/modules/new_task.dart';
import 'package:task_manager/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List appTitle = ['New Task', 'Done Task', 'Archived Task'];

  List screens = [NewTask(), DoneTask(), ArchivedTask()];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  bool isBottomSheetShown = false;
  IconData floatingActionButtonIcon = Icons.edit;

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    floatingActionButtonIcon = icon;

    emit(AppChangeBottomSheetState());
  }

  late Database database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];


  void createDatabase() {
    String sql =
        'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)';

    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');

        database.execute(sql).then((value) {
          print('table created');
        }).catchError((err) {
          print('error when creating table => ${err.toString()}');
        });
      },
      onOpen: (database) {
        print('database opened');

        getData(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    String sql =
        'INSERT INTO tasks (title, date, time, status) VALUES("$title", "$date", "$time", "new")';

    await database.transaction((txn) async {
      txn.rawInsert(sql).then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getData(database);
      }).catchError((err) {
        print('error when inserting in table => ${err.toString()}');
      });
      return await null;
    });
  }

  void getData(database)
  async {

     newTasks = [];
     doneTasks = [];
     archivedTasks = [];

    emit(AppGetDatabaseLoadingState());

     database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element){
        if(element['status'] == 'new'){
          newTasks.add(element);
        } else if(element['status'] == 'done'){
          doneTasks.add(element);
        }else if(element['status'] == 'archive'){
          archivedTasks.add(element);
        }
      });

      emit(AppGetDatabaseState());
    });
  }

  void update(
      {required String status,
        required int id})
  async {
    return await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).
    then((value)  {
      getData(database);
          emit(AppUpdateDatabaseState());
    });
  }

  void delete({
    required int id
      }) async {
     database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).
    then((value)  {
      getData(database);
      emit(AppDeleteDatabaseState());
    });
  }


}
