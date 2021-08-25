import 'package:flutter/material.dart';
import 'package:task_manager/shared/cubit/cubit.dart';

Widget customFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? onTap,
  bool isPassword = false,
  required String? Function(String?) validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function()? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffix,
          ),
        )
            : null,
        border: OutlineInputBorder(),
      ),
    );


// buildTaskItem widget
Widget buildTaskItem (Map model, context) =>Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction)
  {
    AppCubit.get(context).delete(id: model['id']);
  },
  child:   Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(
  
      children: [
  
        CircleAvatar(
  
          radius: 40,
  
          child: Text(
  
            '${model['time']}',
  
          ),
  
        ),
  
        SizedBox(
  
          width: 20,
  
        ),
  
        Expanded(
  
          child: Column(
  
            crossAxisAlignment: CrossAxisAlignment.start,
  
            mainAxisSize: MainAxisSize.min,
  
            children: [
  
              Text(
  
                '${model['title']}',
  
                style: TextStyle(
  
                  fontSize: 16,
  
                  fontWeight: FontWeight.bold,
  
                ),
  
              ),
  
              Text(
  
                '${model['date']}',
  
                style: TextStyle(
  
                    color: Colors.grey
  
                ),
  
              ),
  
            ],
  
          ),
  
        ),
  
        SizedBox(
  
          width: 20,
  
        ),
  
        IconButton(
  
            onPressed: (){
  
              AppCubit.get(context).
  
              update(status: 'done', id: model['id']);
  
            },
  
            icon: Icon(
  
              Icons.check_box,
  
              color: Colors.green,
  
            ),
  
        ),
  
        IconButton(
  
          onPressed: (){
  
            AppCubit.get(context).
  
            update(status: 'archive', id: model['id']);
  
          },
  
          icon: Icon(
  
            Icons.archive,
  
            color: Colors.black54,
  
          ),
  
        ),
  
      ],
  
    ),
  
  ),
);