//Events
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/models/cms_page.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';

abstract class CmsEvent {}

class OnLoadCms extends CmsEvent {
  final String url;
  OnLoadCms(this.url);
}

//States
abstract class CmsState {}

class CmsLoading extends CmsState {}

class CmsLoaded extends CmsState {
  final CmsPage page;
  CmsLoaded(this.page);
}

class CmsError extends CmsState {}

//Bloc
class CmsBloc extends Bloc<CmsEvent, CmsState> {
  CmsBloc() : super(CmsLoading());
  @override
  Stream<CmsState> mapEventToState(CmsEvent event) async* {
    yield CmsLoading();
    if (event is OnLoadCms) {
      try {
        final response = await RemoteRepository().getCmsPage(event.url);
        yield CmsLoaded(response.data);
      } on Failure catch (_) {
        yield CmsError();
      }
    }
  }
}
