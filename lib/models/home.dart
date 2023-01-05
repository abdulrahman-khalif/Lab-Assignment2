class Homes {
  String? homeId;
  String? userId;
  String? name;
  String? homeDesc;
  String? price;
  String? states;
  String? local;
  String? lat;
  String? lng;
  String? date;

  Homes(
      {this.homeId,
      this.userId,
      this.name,
      this.homeDesc,
      this.price,
      this.states,
      this.local,
      this.lat,
      this.lng,
      this.date});

  Homes.fromJson(Map<String, dynamic> json) {
    homeId = json['home_id'];
    userId = json['user_id'];
    name = json['name'];
    homeDesc = json['home_desc'];
    price = json['price'];
    states = json['states'];
    local = json['local'];
    lat = json['lat'];
    lng = json['lng'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home_id'] = this.homeId;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['home_desc'] = this.homeDesc;
    data['price'] = this.price;
    data['states'] = this.states;
    data['local'] = this.local;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['date'] = this.date;
    return data;
  }
}
