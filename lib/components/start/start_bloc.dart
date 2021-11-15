//Events
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/domain/basket_usecase.dart';
import 'package:vismaya/events/cart_change_event.dart';
import 'package:vismaya/repositories/local/db_manager.dart';
import 'package:vismaya/repositories/local/pref_manager.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';
import 'package:vismaya/utils/rxbus.dart';

abstract class StartEvent {}

class OnLoadStart extends StartEvent {
  int tabPosition;
  OnLoadStart([this.tabPosition = 0]);
}

class OnStartTabPressed extends StartEvent {
  int tabPosition;
  OnStartTabPressed(this.tabPosition);
}

class OnCartChanged extends StartEvent {}

//States
abstract class StartState {}

class StartLoading extends StartState {}

class StartTabSelected extends StartState {
  final int tabPosition;
  StartTabSelected(this.tabPosition);
}

class StartError extends StartState {
  final String errorMessage;
  StartError(this.errorMessage);
}

//Bloc
class StartBloc extends Bloc<StartEvent, StartState> {
  StartBloc() : super(StartLoading()) {
    RxBus.register<CartChangeEvent>().listen((event) => _onCartChanged());
  }

  @override
  Stream<StartState> mapEventToState(StartEvent event) async* {
    final _currentState = state;
    if (event is OnLoadStart) {
      try {
        await prefManager.initialized;
        await config.initialized;
        await dbManager.initialized;
        //Get Store config
        final storeConfiguration = await RemoteRepository().getStoreConfig();
        config.setStoreConfig(storeConfiguration);
        //Load brand names
        final brandNamesMap =
            await RemoteRepository().getProductAttributeOptions(159);
        config.setBrandNamesMap(brandNamesMap);
        //Load packsizes
        final packSizesMap =
            await RemoteRepository().getProductAttributeOptions(145);
        config.setPackSizesMap(packSizesMap);
        //Load CategoryName
        final categoryNamesMap=
            await RemoteRepository().getCategories1();
        config.setCategoryNamesMap(categoryNamesMap);

        yield StartTabSelected(event.tabPosition);

        //Set config cart
        try {
          final response = await BasketUsecase.getCart();
          config.cart = response.data;
        } on Failure catch (e) {}
        yield StartTabSelected(event.tabPosition);
      } on Failure catch (e) {
        yield StartError(e.message);
      }
    } else if (event is OnStartTabPressed) {
      yield StartTabSelected(event.tabPosition);
    } else if (event is OnCartChanged) {
      final tabPosition =
          (_currentState is StartTabSelected) ? _currentState.tabPosition : 0;
      yield StartTabSelected(tabPosition);
    }
  }

  @override
  Future<void> close() {
    RxBus.destroy();
    return super.close();
  }

  _onCartChanged() {
    add(OnCartChanged());
  }
}
