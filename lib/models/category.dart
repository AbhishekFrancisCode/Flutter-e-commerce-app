import 'dart:collection';

class Category {
  int id = 0;
  String name = "";
  bool isActive = false;
  int level = 0;
  int count = 0;
  List<Category> children;

  Category(
      {this.id = 0,
      this.name = "",
      this.isActive = true,
      this.level = 0,
      this.count = 0,
      this.children = const []});

  //From server
  factory Category.fromJson(Map<String, dynamic> json) {
    final queue = Queue<dynamic>();
    final catQueue = Queue<Category>();
    final parent = _getCategory(json);
    queue.add(json);
    catQueue.add(parent);
    do {
      final _json = queue.removeFirst();
      final _parent = catQueue.removeFirst();
      final list = _json['children_data'] as List;
      if (list.length > 0) {
        //Add copy of parent as first
        if (_parent.level > 1) {
          final _first = Category(
              id: _parent.id,
              name: "All ${_parent.name}",
              count: _parent.count,
              level: _parent.level + 1);
          _parent.children.add(_first);
        }
      }
      for (var i = 0; i < list.length; i++) {
        final _item = list[i];
        bool _isActive = _item["is_active"];
        if (!_isActive) continue;
        final _category = _getCategory(_item);
        queue.add(_item);
        catQueue.add(_category);
        _parent.children.add(_category);
      }
    } while (queue.isNotEmpty);
    return parent;
  }

  static Category _getCategory(Map<String, dynamic> json) => Category(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
      level: json['level'],
      count: json['product_count'],
      children: List());
}
