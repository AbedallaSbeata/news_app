import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/states.dart';
import '../Business/BusinessScreen.dart';
import '../Dio/Dio.dart';
import '../Sports/SportsScreen.dart';
import '../Science/ScienceScreen.dart';
import '../Shared/shared.dart';


class NewsCubit extends Cubit<NewsStates>
{
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems =
  [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.business,
      ),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports,
      ),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.science,
      ),
      label: 'Science',
    ),
  ];

  List<Widget> screens =
  [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

  void changeBottomNavBar(int index)
  {
    currentIndex = index;
    if(index == 0)
      getBusiness();
    if(index == 1)
      getSports();
    if(index == 2)
      getScience();
    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];

  Future<void> getBusiness() async
  {
    emit(NewsGetBusinessLoadingState());

    await DioHelper.getData(
      url: 'v2/top-headlines',
      query:
      {
        'country':'sa',
        'category':'business',
        'apiKey':'65f7f556ec76449fa7dc7c0069f040ca',
      },
    ).then((value)
    {
      business = value.data['articles'];
      print(value.data['articles']);
      emit(NewsGetBusinessSuccessState());
    }).catchError((error){
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }

  List<dynamic> sports = [];

  Future<void> getSports() async
  {
    emit(NewsGetSportsLoadingState());
    await DioHelper.getData(
      url: 'v2/top-headlines',
      query:
      {
        'country':'sa',
        'category':'sports',
        'apiKey':'65f7f556ec76449fa7dc7c0069f040ca',
      },
    ).then((value)
    {
      sports = value.data['articles'];
      emit(NewsGetSportsSuccessState());
    }).catchError((error){
      emit(NewsGetSportsErrorState(error.toString()));
    });
  }

  List<dynamic> science = [];

  Future<void> getScience() async
  {
    emit(NewsGetScienceLoadingState());
    await DioHelper.getData(
      url: 'v2/top-headlines',
      query:
      {
        'country':'sa',
        'category':'science',
        'apiKey':'65f7f556ec76449fa7dc7c0069f040ca',
      },
    ).then((value)
    {
      science = value.data['articles'];
      emit(NewsGetScienceSuccessState());
    }).catchError((error){
      emit(NewsGetScienceErrorState(error.toString()));
    });
  }

  List<dynamic> search = [];

  Future<void> getSearch(String value) async
  {
    emit(NewsGetSearchLoadingState());

   await DioHelper.getData(
      url: 'v2/everything',
      query:
      {
        'q':'$value',
        'apiKey':'65f7f556ec76449fa7dc7c0069f040ca',
      },
    ).then((value)
    {
      search = value.data['articles'];
      emit(NewsGetSearchSuccessState());
    }).catchError((error){
      emit(NewsGetSearchErrorState(error.toString()));
    });

  }
}