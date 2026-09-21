import 'package:json_annotation/json_annotation.dart';
part 'myapkversion.g.dart';

@JsonSerializable()
class MyApkVersion {

  MyApkVersion({
    this.name,
    this.version,
    this.url,
    this.dec,
    this.id,
    this.createTime,
    this.abolished,
    this.updatePolicy,
  });

  String? name;
  String? version;
  String? url;
  String? dec;
  String? id;
  String? createTime;
  String? updatePolicy;
  int? abolished;

  factory MyApkVersion.fromJson(Map<String,dynamic> json) => _$MyApkVersionFromJson(json);
  Map<String, dynamic> toJson() => _$MyApkVersionToJson(this);
}
