import 'dart:ui';

class ModelBooking{
  String? image;
  String? name;
  String? date;
  String? rating;
  double? price;
  String? owner;
  String? tag;
  int? bgColor;
  Color textColor;

  ModelBooking(this.image, this.name, this.date, this.rating, this.price,
      this.owner, this.tag,this.bgColor,this.textColor);
}