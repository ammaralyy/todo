import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/layout/home_layout.dart';
import 'package:task_manager/shared/bloc_observer.dart';

void main() {

  Bloc.observer = MyBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}