// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      org: json['org'] == null
          ? null
          : Org.fromJson(json['org'] as Map<String, dynamic>),
      roleList: (json['roleList'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      permissionList: (json['permissionList'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
      permissions: json['permissions'] as List<dynamic>?,
      token: json['token'] as String?,
      accessTokenModel: json['accessTokenModel'] == null
          ? null
          : AccessTokenModel.fromJson(
              json['accessTokenModel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'user': instance.user?.toJson(),
      'org': instance.org?.toJson(),
      'roleList': instance.roleList,
      'permissionList': instance.permissionList,
      'roles': instance.roles?.map((e) => e.toJson()).toList(),
      'permissions': instance.permissions,
      'token': instance.token,
      'accessTokenModel': instance.accessTokenModel?.toJson(),
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      userLoginPwd: json['userLoginPwd'] as String?,
      userSfzh: json['userSfzh'],
      userMobile: json['userMobile'],
      userKind: (json['userKind'] as num?)?.toInt(),
      userStatus: (json['userStatus'] as num?)?.toInt(),
      orgId: json['orgId'] as String?,
      userLoginName: json['userLoginName'] as String?,
      updateTime: json['updateTime'] == null
          ? null
          : DateTime.parse(json['updateTime'] as String),
      userOrder: json['userOrder'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'userLoginPwd': instance.userLoginPwd,
      'userSfzh': instance.userSfzh,
      'userMobile': instance.userMobile,
      'userKind': instance.userKind,
      'userStatus': instance.userStatus,
      'orgId': instance.orgId,
      'userLoginName': instance.userLoginName,
      'updateTime': instance.updateTime?.toIso8601String(),
      'userOrder': instance.userOrder,
    };

Org _$OrgFromJson(Map<String, dynamic> json) => Org(
      orgId: json['orgId'] as String?,
      orgOrder: (json['orgOrder'] as num?)?.toInt(),
      orgName: json['orgName'] as String?,
      orgCode: json['orgCode'],
      orgDepth: (json['orgDepth'] as num?)?.toInt(),
      orgDescription: json['orgDescription'],
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      updateTime: json['updateTime'] == null
          ? null
          : DateTime.parse(json['updateTime'] as String),
      orgFid: json['orgFid'] as String?,
      orgType: (json['orgType'] as num?)?.toInt(),
      orgIdPath: json['orgIdPath'] as String?,
      orgNamePath: json['orgNamePath'] as String?,
    );

Map<String, dynamic> _$OrgToJson(Org instance) => <String, dynamic>{
      'orgId': instance.orgId,
      'orgOrder': instance.orgOrder,
      'orgName': instance.orgName,
      'orgCode': instance.orgCode,
      'orgDepth': instance.orgDepth,
      'orgDescription': instance.orgDescription,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'updateTime': instance.updateTime?.toIso8601String(),
      'orgFid': instance.orgFid,
      'orgType': instance.orgType,
      'orgIdPath': instance.orgIdPath,
      'orgNamePath': instance.orgNamePath,
    };

AccessTokenModel _$AccessTokenModelFromJson(Map<String, dynamic> json) =>
    AccessTokenModel(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      expiresTime: (json['expiresTime'] as num?)?.toInt(),
      refreshExpiresTime: (json['refreshExpiresTime'] as num?)?.toInt(),
      clientId: json['clientId'] as String?,
      loginId: json['loginId'] as String?,
      openid: json['openid'] as String?,
      scope: json['scope'] as String?,
      expiresIn: (json['expiresIn'] as num?)?.toInt(),
      refreshExpiresIn: (json['refreshExpiresIn'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AccessTokenModelToJson(AccessTokenModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresTime': instance.expiresTime,
      'refreshExpiresTime': instance.refreshExpiresTime,
      'clientId': instance.clientId,
      'loginId': instance.loginId,
      'openid': instance.openid,
      'scope': instance.scope,
      'expiresIn': instance.expiresIn,
      'refreshExpiresIn': instance.refreshExpiresIn,
    };

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      roleId: json['roleId'] as String?,
      roleName: json['roleName'] as String?,
      description: json['description'] as String?,
      status: (json['status'] as num?)?.toInt(),
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
      clientId: json['clientId'] as String?,
      clientName: json['clientName'] as String?,
      roleOrder: (json['roleOrder'] as num?)?.toInt(),
      rl: json['rl'] as String?,
      viewLevel: (json['viewLevel'] as num?)?.toInt(),
      roleType: json['roleType'] as String?,
      roleTypeId: json['roleTypeId'] as String?,
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'roleId': instance.roleId,
      'roleName': instance.roleName,
      'description': instance.description,
      'status': instance.status,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'clientId': instance.clientId,
      'clientName': instance.clientName,
      'roleOrder': instance.roleOrder,
      'rl': instance.rl,
      'viewLevel': instance.viewLevel,
      'roleTypeId': instance.roleTypeId,
      'roleType': instance.roleType,
    };
