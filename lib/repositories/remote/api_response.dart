class ApiResponse<T> {
  T data;
  final bool isSuccess;
  final String message;

  ApiResponse({this.data, this.isSuccess = true, this.message});
}
