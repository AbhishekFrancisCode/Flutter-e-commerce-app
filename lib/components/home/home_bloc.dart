//Events
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/models/component.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';

abstract class HomeEvent {}

class OnLoadHome extends HomeEvent {}

//State
abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String errorMessage;
  HomeError(this.errorMessage);
}

class HomeLoaded extends HomeState {
  final List<Component> list;
  HomeLoaded(this.list);
}

//Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is OnLoadHome) {
      try {
        final response = await RemoteRepository().getHomeComponentList();
        yield HomeLoaded(response.data);
      } on Failure catch (e) {
        yield HomeError(e.message);
      }
    }
  }
}
