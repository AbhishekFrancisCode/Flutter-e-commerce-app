//Events
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/models/category.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';

abstract class CategoriesEvent {}

class OnLoadCategories extends CategoriesEvent {
  final Category category;
  OnLoadCategories({this.category});
}

//States
abstract class CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;
  CategoriesLoaded(this.categories);
}

class CategoriesError extends CategoriesState {
  final String errorMessage;
  CategoriesError(this.errorMessage);
}

//Bloc
class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(CategoriesLoading());

  @override
  Stream<CategoriesState> mapEventToState(CategoriesEvent event) async* {
    if (event is OnLoadCategories) {
      try {
        if (event.category != null) {
          yield CategoriesLoaded(event.category.children);
        } else {
          final response = await RemoteRepository().getCategories();
          yield CategoriesLoaded(response.data);
        }
      } on Failure catch (e) {
        yield CategoriesError(e.message);
      }
    }
  }
}
