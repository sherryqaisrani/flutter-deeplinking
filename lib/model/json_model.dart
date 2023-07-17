class ModelClass {
  int? id;
  String? name;
  String? price;
  String? currency;
  String? image;
  String? url;

  ModelClass(
      {this.id, this.name, this.price, this.currency, this.image, this.url});

  ModelClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    currency = json['currency'];
    image = json['image'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['currency'] = currency;
    data['image'] = image;
    data['url'] = url;
    return data;
  }
}
