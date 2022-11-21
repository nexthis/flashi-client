import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Macro {
  String name;
  String code;
  Macro({this.name = '', this.code = ''});
  factory Macro.fromJson(Map<String, dynamic> json) => _$MacroFromJson(json);
  Map<String, dynamic> toJson() => _$MacroToJson(this);
}
