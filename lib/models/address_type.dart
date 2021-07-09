class AddressType {
  final String label;

  const AddressType._internal(this.label);
  toString() => 'Enum.$label';

  static const SHIPPING = const AddressType._internal("Shipping address");
  static const BILLING = const AddressType._internal("Billing address");
  static const OTHER_ADDRESS = const AddressType._internal("Other address");
}
