class Cat {
    Cat({
        this.id,
        this.parentId,
        this.name,
        this.isActive,
        this.position,
        this.level,
        this.productCount,
        this.childrenData,
    });

    int id;
    int parentId;
    String name;
    bool isActive;
    int position;
    int level;
    int productCount;
    List<Cat> childrenData;

    factory Cat.fromJson(Map<String, dynamic> json) => Cat(
        id: json["id"],
        parentId: json["parent_id"],
        name: json["name"],
        isActive: json["is_active"],
        position: json["position"],
        level: json["level"],
        productCount: json["product_count"],
        childrenData: List<Cat>.from(json["children_data"].map((x) => Cat.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": parentId,
        "name": name,
        "is_active": isActive,
        "position": position,
        "level": level,
        "product_count": productCount,
        "children_data": List<dynamic>.from(childrenData.map((x) => x.toJson())),
    };
}