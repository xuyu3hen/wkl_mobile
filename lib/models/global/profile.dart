import 'package:json_annotation/json_annotation.dart';
part 'profile.g.dart';

@JsonSerializable(explicitToJson: true)
class Profile {
  User? user;
  Org? org;
  List<String?>? roleList;
  List<String?>? permissionList;
  List<Role>? roles;
  List<dynamic>? permissions;
  String? token;
  AccessTokenModel? accessTokenModel;

  Profile({
    this.user,
    this.org,
    this.roleList,
    this.permissionList,
    this.roles,
    this.permissions,
    this.token,
    this.accessTokenModel,
  });

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

@JsonSerializable()
class User {
  String? userId;
  String? userName;
  String? userLoginPwd;
  dynamic userSfzh;
  dynamic userMobile;
  int? userKind;
  int? userStatus;
  String? orgId;
  String? userLoginName;
  DateTime? updateTime;
  String? userOrder;

  User({
    this.userId,
    this.userName,
    this.userLoginPwd,
    this.userSfzh,
    this.userMobile,
    this.userKind,
    this.userStatus,
    this.orgId,
    this.userLoginName,
    this.updateTime,
    this.userOrder,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Org {
  String? orgId;
  int? orgOrder;
  String? orgName;
  dynamic orgCode;
  int? orgDepth;
  dynamic orgDescription;
  DateTime? startTime;
  DateTime? endTime;
  DateTime? updateTime;
  String? orgFid;
  int? orgType;
  String? orgIdPath;
  String? orgNamePath;

  Org({
    this.orgId,
    this.orgOrder,
    this.orgName,
    this.orgCode,
    this.orgDepth,
    this.orgDescription,
    this.startTime,
    this.endTime,
    this.updateTime,
    this.orgFid,
    this.orgType,
    this.orgIdPath,
    this.orgNamePath,
  });

  factory Org.fromJson(Map<String, dynamic> json) => _$OrgFromJson(json);
  Map<String, dynamic> toJson() => _$OrgToJson(this);
}

@JsonSerializable()
class AccessTokenModel {
  String? accessToken;
  String? refreshToken;
  int? expiresTime;
  int? refreshExpiresTime;
  String? clientId;
  String? loginId;
  String? openid;
  String? scope;
  int? expiresIn;
  int? refreshExpiresIn;

  AccessTokenModel({
    this.accessToken,
    this.refreshToken,
    this.expiresTime,
    this.refreshExpiresTime,
    this.clientId,
    this.loginId,
    this.openid,
    this.scope,
    this.expiresIn,
    this.refreshExpiresIn,
  });

  factory AccessTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccessTokenModelToJson(this);
}

@JsonSerializable()
class Role {
  Role({
    this.roleId,
    this.roleName,
    this.description,
    this.status,
    this.createTime,
    this.updateTime,
    this.clientId,
    this.clientName,
    this.roleOrder,
    this.rl,
    this.viewLevel,
    this.roleType,
    this.roleTypeId,
  });

  String? roleId;
  String? roleName;
  String? description;
  int? status;
  String? createTime;
  String? updateTime;
  String? clientId;
  String? clientName;
  int? roleOrder;
  String? rl;
  int? viewLevel;
  String? roleTypeId;
  String? roleType;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
