//Events
import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/models/product.dart';
import 'package:vismaya/repositories/remote/failure.dart';
abstract class SortEvent {}

class OnSort extends SortEvent {
  final String named;
  final List list;
  OnSort(this.named, this.list);
}

class OnRefreshSortProductList extends SortEvent {}

class OnVariantPositionChangedSort extends SortEvent {
  final int productPosition;
  final int variantPosition;
  OnVariantPositionChangedSort(this.productPosition, this.variantPosition);
}

//States
abstract class SortState {}

class SortLoading extends SortState {}

class SortLoaded extends SortState {
  final List<Product> list;
  SortLoaded(this.list);
}

class SortError extends SortState {
  final String errorMessage;
  SortError(this.errorMessage);
}

//Bloc
class SortBloc extends Bloc<SortEvent, SortState> {
  SortBloc() : super(SortLoading());

  @override
  Stream<SortState> mapEventToState(SortEvent event) async* {
    final _currentState = state;
    yield SortLoading();
    if (event is OnSort) {
      try {
        String name = event.named;
        List list = event.list;
        final response = _getProductsByFilterBrand(name, list);
        yield SortLoaded(response);
      } on Failure catch (e) {
        yield SortError(e.message);
      }
    } else if (event is OnVariantPositionChangedSort) {
      if (_currentState is SortLoaded) {
        final product = _currentState.list[event.productPosition];
        product.variantPosition = event.variantPosition;
        yield SortLoaded(_currentState.list);
      }
    } else if (event is OnRefreshSortProductList) {
      if (_currentState is SortLoaded) {
        yield SortLoaded(_currentState.list);
      }
    }
  }
}

_getProductsByFilterBrand(String name, List lists) {
  var _sortTerm = name.toString();
  List<Product> list = [];
  Set<String> set = Set();
  for (int i = 0; i < lists.length; i++) {
    final item = lists[i];
    list.add(item);
    set.add(item.getGroupName());
  }
  if (_sortTerm.compareTo("Sort by Price Low to High") == 0) {
    for (var i = 0; i < list.length; i++) {
      list.sort((a, b) => a.getPrice().compareTo(b.getPrice()));
    }
  } else if (_sortTerm.compareTo("Sort by Price High to Low") == 0) {
    for (var i = 0; i < list.length; i++) {
      list.sort((a, b) => a.getPrice().compareTo(b.getPrice()));
      list = new List.from(list.reversed);
    }
  } else if (_sortTerm.compareTo("Relevance") == 0) {
    return lists;
  } else if (_sortTerm.compareTo("Sort by Z to A") == 0) {
    list = new List.from(lists.reversed);
  } else {
    list = list;
  }
  return list;
}
