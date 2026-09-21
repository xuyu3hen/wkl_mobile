// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myapkversion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyApkVersion _$MyApkVersionFromJson(Map<String, dynamic> json) => MyApkVersion(
      name: json['name'] as String?,
      version: json['version'] as String?,
      url: json['url'] as String?,
      dec: json['dec'] as String?,
      id: json['id'] as String?,
      createTime: json['createTime'] as String?,
      abolished: (json['abolished'] as num?)?.toInt(),
      updatePolicy: json['updatePolicy'] as String?,
    );

Map<String, dynamic> _$MyApkVersionToJson(MyApkVersion instance) =>
    <String, dynamic>{
      'name': instance.name,
      'version': instance.version,
      'url': instance.url,
      'dec': instance.dec,
      'id': instance.id,
      'createTime': instance.createTime,
      'updatePolicy': instance.updatePolicy,
      'abolished': instance.abolished,
    };
