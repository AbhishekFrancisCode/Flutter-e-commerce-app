//Events
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/models/product.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';

abstract class FilterEvent {}

class OnFilter extends FilterEvent {
  final  searchTerm;
  final List<String> brandChecked;
  final List<String> sizeChecked;
  final String categoryChecked;
  final String priceChecked;
  OnFilter(this.searchTerm, this.brandChecked, this.sizeChecked,
      this.categoryChecked, this.priceChecked);
}

class OnRefreshProductList extends FilterEvent {}

class OnVariantPositionChanged extends FilterEvent {
  final int productPosition;
  final int variantPosition;
  OnVariantPositionChanged(this.productPosition, this.variantPosition);
}

//States
abstract class FilterState {}

class FilterLoading extends FilterState {}

class FilterLoaded extends FilterState {
  final List<Product> list;
  FilterLoaded(this.list);
}

class FilterError extends FilterState {
  final String errorMessage;
  FilterError(this.errorMessage);
}

//Bloc
class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterLoading());

  @override
  Stream<FilterState> mapEventToState(FilterEvent event) async* {
    final _currentState = state;
    yield FilterLoading();
    if (event is OnFilter) {
      try {
        final searchTerm = event.searchTerm;
        final brandChecked = event.brandChecked;
        final sizeChecked = event.sizeChecked;
        final categoryChecked = event.categoryChecked;
        final priceChecked = event.priceChecked;
        final response = 
        searchTerm is int
            ? await RemoteRepository().getProductListByFilter(searchTerm,
                brandChecked, sizeChecked, priceChecked)
            :
             await RemoteRepository().getProductsByFilter(searchTerm,
                brandChecked, sizeChecked, categoryChecked, priceChecked);
        yield FilterLoaded(response.data);
      } on Failure catch (e) {
        yield FilterError(e.message);
      }
    } else if (event is OnVariantPositionChanged) {
      if (_currentState is FilterLoaded) {
        final product = _currentState.list[event.productPosition];
        product.variantPosition = event.variantPosition;
        yield FilterLoaded(_currentState.list);
      }
    } else if (event is OnRefreshProductList) {
      if (_currentState is FilterLoaded) {
        yield FilterLoaded(_currentState.list);
      }
    }
  }
}

