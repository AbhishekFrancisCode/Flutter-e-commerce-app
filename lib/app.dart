class App {
  static final App _singleton = App._internal();
  factory App() => _singleton;
  App._internal();

  String token = "";

  Future<void> init({bool refreshToken = false}) async {}
}
