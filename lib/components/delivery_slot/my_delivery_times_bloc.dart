//Event
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/models/delivery_times/delivery_times.dart';
import 'package:vismaya/models/delivery_times/selected_delivery_time.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';

abstract class DeliveryTimesEvent {}

class OnLoadDeliveryTimes extends DeliveryTimesEvent {
  final SelectedDeliveryTime selectedDeliveryTime;
  OnLoadDeliveryTimes(this.selectedDeliveryTime);
}

class OnDeliveryTimeSelected extends DeliveryTimesEvent {
  final SelectedDeliveryTime selectedDeliveryTime;
  OnDeliveryTimeSelected(this.selectedDeliveryTime);
}

//States
abstract class DeliveryTimesState {}

class DeliveryTimesLoading extends DeliveryTimesState {}

class DeliveryTimesLoaded extends DeliveryTimesState {
  final DeliveryTimes deliveryTimes;
  final SelectedDeliveryTime selectedDeliveryTime;
  DeliveryTimesLoaded(this.deliveryTimes, this.selectedDeliveryTime);
}

//Bloc
class DeliveryTimesBloc extends Bloc<DeliveryTimesEvent, DeliveryTimesState> {
  DeliveryTimesBloc() : super(DeliveryTimesLoading());

  @override
  Stream<DeliveryTimesState> mapEventToState(DeliveryTimesEvent event) async* {
    final _currentState = state;
    if (event is OnLoadDeliveryTimes) {
      final response = await RemoteRepository().getDeliveryTimes();
      yield DeliveryTimesLoaded(response.data, event.selectedDeliveryTime);
    } else if (event is OnDeliveryTimeSelected) {
      if (_currentState is DeliveryTimesLoaded) {
        yield DeliveryTimesLoaded(
            _currentState.deliveryTimes, event.selectedDeliveryTime);
      }
    }
  }
}
