import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:vismaya/common/progress_indicator_widget.dart';
import 'package:vismaya/common/show_error_widget.dart';
import 'package:vismaya/config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cms_page_bloc.dart';

class MyCMSPage extends StatelessWidget {
  final String title;
  final String url;

  MyCMSPage(this.title, this.url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: config.brandColor,
        ),
        body: BlocProvider(
          create: (context) => CmsBloc()..add(OnLoadCms(url)),
          child: BlocBuilder<CmsBloc, CmsState>(builder: (context, state) {
            if (state is CmsLoaded) {
              return SingleChildScrollView(
                  // child: Html(
                  //   data: state.page.content,
                  //   onLinkTap: (link) {
                  //     launch(link);
                  //   },
                  // ),
                  );
            } else if (state is CmsError) {
              return ShowErrorWidget("Oops! Something is wrong. Please retry!",
                  onPressed: () {
                context.bloc<CmsBloc>().add(OnLoadCms(url));
              });
            }
            return ProgressIndicatorWidget();
          }),
        ));
  }
}
