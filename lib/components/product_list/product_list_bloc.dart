//Events
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/models/category.dart';
import 'package:vismaya/models/product.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';

abstract class ProductListEvent {}

class OnLoadProductList extends ProductListEvent {
  final Category category;
  final List<Category> siblings;
  OnLoadProductList(this.category, this.siblings);
}

class OnRefreshProductList extends ProductListEvent {}

class OnSiblingClicked extends ProductListEvent {
  final int siblingPosition;
  final int categoryId;
  OnSiblingClicked(this.siblingPosition, this.categoryId);
}

class OnVariantPositionChanged extends ProductListEvent {
  final int productPosition;
  final int variantPosition;
  OnVariantPositionChanged(this.productPosition, this.variantPosition);
}

//States
abstract class ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final int siblingPosition;
  final List<Product> list;
  final bool isLoading;
  ProductListLoaded(this.list,
      [this.isLoading = false, this.siblingPosition = 0]);
}

class ProductListError extends ProductListState {
  final String errorMessage;
  ProductListError(this.errorMessage);
}

//Bloc
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc() : super(ProductListLoading());

  @override
  Stream<ProductListState> mapEventToState(ProductListEvent event) async* {
    final _currentState = state;
    if (event is OnLoadProductList) {
      try {
        final categoryId = event.category.id;
        final response =
            await RemoteRepository().getProductsByCategoryId(categoryId);
        int siblingPosition =
            event.siblings.indexWhere((e) => categoryId == e.id);
        yield ProductListLoaded(response.data, false, siblingPosition);
      } on Failure catch (e) {
        yield ProductListError(e.message);
      }
    } else if (event is OnVariantPositionChanged) {
      if (_currentState is ProductListLoaded) {
        final product = _currentState.list[event.productPosition];
        product.variantPosition = event.variantPosition;
        yield ProductListLoaded(_currentState.list);
      }
    } else if (event is OnSiblingClicked) {
      try {
        yield ProductListLoaded([], true, event.siblingPosition);
        final categoryId = event.categoryId;
        final response =
            await RemoteRepository().getProductsByCategoryId(categoryId);
        yield ProductListLoaded(response.data, false, event.siblingPosition);
      } on Failure catch (e) {
        yield ProductListError(e.message);
      }
    } else if (event is OnRefreshProductList) {
      if (_currentState is ProductListLoaded) {
        yield ProductListLoaded(_currentState.list);
      }
    }
  }
}
