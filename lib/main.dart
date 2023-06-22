import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/AppCubit/cubit.dart';
import 'package:news_app/layout/NewsLayout.dart';
import 'package:news_app/layout/cubit.dart';
import 'package:news_app/layout/states.dart';

import 'AppCubit/states.dart';
import 'Dio/Dio.dart';
import 'Shared/shared.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();
  bool isDark = CacheHelper.getData(key: 'isDark');
  runApp(MyApp(isDark));
}

class MyApp extends StatelessWidget {

   final bool? isDark;
   MyApp(this.isDark);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..changeAppMode(fromShared: isDark),
      child: BlocConsumer<AppCubit,AppStates>(
         listener: (context,state){},
         builder: (context,state) {
           return MaterialApp(
             debugShowCheckedModeBanner: false,
             themeMode: AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
             home: NewsLayout(),
           );
         },
      ),
    );
  }
}

