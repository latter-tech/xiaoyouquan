class UserModel {
  String? searchValue;
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  int? uid;
  int? fansCount;
  int? followsCount;
  int? userGroup;
  String? username;
  String? email;
  String? countryCode;
  String? mobilephone;
  String? password;
  String? salt;
  String? screenName;
  String? location;
  String? description;
  String? birthday;
  String? lang;
  String? profileImageUrl;
  String? profileBannerUrl;
  List<int>? listFans;
  List<int>? listFollows;
  String? ipaddr;
  DateTime? createdAt;
  String? signinAt;

  UserModel(
      {this.searchValue,
        this.createBy,
        this.createTime,
        this.updateBy,
        this.updateTime,
        this.remark,
        this.uid,
        this.fansCount,
        this.followsCount,
        this.userGroup,
        this.username,
        this.email,
        this.countryCode,
        this.mobilephone,
        this.screenName,
        this.location,
        this.description,
        this.birthday,
        this.lang,
        this.profileImageUrl,
        this.profileBannerUrl,
        this.listFans,
        this.listFollows,
        this.ipaddr,
        this.createdAt,
        this.signinAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    searchValue = json['searchValue'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    uid = json['uid'];
    fansCount = json['fansCount'];
    followsCount = json['followsCount'];
    userGroup = json['userGroup'];
    username = json['username'];
    email = json['email'];
    countryCode = json['countryCode'];
    mobilephone = json['mobilephone'];
    screenName = json['screenName'];
    location = json['location'];
    birthday = json['birthday'];
    lang = json['lang'];
    description = json['description'];
    profileImageUrl = json['profileImageUrl'];
    profileBannerUrl = json['profileBannerUrl'];
    listFans = <int>[];
    if( json['listFans'] != null ) {
      json['listFans'].forEach((value) {
        listFans?.add(value);
      });
    }
    listFollows = <int>[];
    if( json['listFollows'] != null ) {
      json['listFollows'].forEach((value) {
        listFollows?.add(value);
      });
    }
    ipaddr = json['ipaddr'];
    if(json['createdAt'] != null) {
      createdAt = DateTime.parse(json['createdAt']);
    }
    signinAt = json['signinAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchValue'] = this.searchValue;
    data['createBy'] = this.createBy;
    data['createTime'] = this.createTime;
    data['updateBy'] = this.updateBy;
    data['updateTime'] = this.updateTime;
    data['remark'] = this.remark;
    data['uid'] = this.uid;
    data['fansCount'] = this.fansCount;
    data['followsCount'] = this.followsCount;
    data['userGroup'] = this.userGroup;
    data['username'] = this.username;
    data['email'] = this.email;
    data['countryCode'] = this.countryCode;
    data['mobilephone'] = this.mobilephone;
    data['password'] = this.password;
    data['salt'] = this.salt;
    data['screenName'] = this.screenName;
    data['location'] = this.location;
    data['description'] = this.description;
    data['birthday'] = this.birthday;
    data['lang'] = this.lang;
    data['ipaddr'] = this.ipaddr;
    data['createdAt'] = this.createdAt;
    data['signinAt'] = this.signinAt;
    return data;
  }
}