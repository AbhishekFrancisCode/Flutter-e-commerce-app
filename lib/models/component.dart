import 'dart:collection';

import 'package:html_unescape/html_unescape.dart';

class Component {
  int id = 0;
  String label = "";
  bool visible = true;
  String imageUrl = "";
  String backgroundColor = "";
  bool showLabel = false;
  String type = "";
  List<Component> children;

  Component(
      {this.id = 0,
      this.label = "",
      this.visible = true,
      this.imageUrl = "",
      this.type = "",
      this.backgroundColor = "",
      this.showLabel = false,
      this.children = const []});

  static List<Component> fromJson(Map<String, dynamic> json) {
    final list = json["components"];
    return _getComponents(list);
  }

  static List<Component> _getComponents(list) {
    final _itemQueue = Queue<dynamic>();
    final _componentQueue = Queue<Component>();
    final _list = <Component>[];
    for (final item in list) {
      final component = _getComponent(item);
      if (!component.visible) continue;
      _itemQueue.add(item);
      _componentQueue.add(component);
      _list.add(component);
    }

    do {
      final item = _itemQueue.removeFirst();
      final children = item["children"] ?? [];
      final component = _componentQueue.removeFirst();
      for (final _child in children) {
        final _component = _getComponent(_child);
        if (!component.visible) continue;
        component.children.add(_component);
      }
    } while (_itemQueue.isNotEmpty);
    return _list;
  }

  static Component _getComponent(dynamic item) {
    final label = item["label"] ?? "";
    final _label = HtmlUnescape().convert(label);
    return Component(
        id: item["id"],
        label: _label,
        visible: item["visible"],
        imageUrl: item["image_url"],
        type: item["type"],
        backgroundColor: item["background_color"] ?? "",
        showLabel: item['show_label'] ?? false,
        children: List());
  }
}
