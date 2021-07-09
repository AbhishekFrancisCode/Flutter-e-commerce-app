//Events
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/models/product.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';

abstract class SearchEvent {}

class OnSearch extends SearchEvent {
  final String term;
  OnSearch(this.term);
}

class OnRefreshProductList extends SearchEvent {}

class OnVariantPositionChanged extends SearchEvent {
  final int productPosition;
  final int variantPosition;
  OnVariantPositionChanged(this.productPosition, this.variantPosition);
}

//States
abstract class SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Product> list;
  SearchLoaded(this.list);
}

class SearchError extends SearchState {
  final String errorMessage;
  SearchError(this.errorMessage);
}

//Bloc
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchLoading());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    final _currentState = state;
    yield SearchLoading();
    if (event is OnSearch) {
      try {
        final term = event.term.trim();
        final response = await RemoteRepository().getProductsBySearch(term);
        yield SearchLoaded(response.data);
      } on Failure catch (e) {
        yield SearchError(e.message);
      }
    } else if (event is OnVariantPositionChanged) {
      if (_currentState is SearchLoaded) {
        final product = _currentState.list[event.productPosition];
        product.variantPosition = event.variantPosition;
        yield SearchLoaded(_currentState.list);
      }
    } else if (event is OnRefreshProductList) {
      if (_currentState is SearchLoaded) {
        yield SearchLoaded(_currentState.list);
      }
    }
  }
}
