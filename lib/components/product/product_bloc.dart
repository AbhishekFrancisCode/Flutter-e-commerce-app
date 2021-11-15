import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/models/product.dart';

abstract class ProductEvent {}

class OnLoadProduct extends ProductEvent {
  final Product product;
  OnLoadProduct(this.product);
}

class OnPackSizeClicked extends ProductEvent {
  final Product product;
  OnPackSizeClicked(this.product);
}

//States
abstract class ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final Product product;
  ProductLoaded(this.product);
}

//Bloc
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductLoading());

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is OnLoadProduct) {
      yield ProductLoaded(event.product);
    } else if (event is OnPackSizeClicked) {
      yield ProductLoaded(event.product);
    }
  }
}
