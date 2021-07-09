import 'package:flutter/widgets.dart';

abstract class Clonable<T> {
  /// Clone the current object.
  @required
  T clone();
}
