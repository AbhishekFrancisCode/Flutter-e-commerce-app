import 'package:vismaya/models/delivery_times/delivery_date.dart';
import 'package:vismaya/models/delivery_times/delivery_slot.dart';

class DeliveryTimes {
  String description = "";
  List<DeliverySlot> slots = [];
  Map<String, DeliveryDate> deliveryTimesMap = Map();
  DeliveryTimes({this.slots, this.deliveryTimesMap, this.description = ""});
}
