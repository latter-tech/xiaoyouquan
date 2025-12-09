
class BlogAssetModel {
  int? id;
  int? type;
  int? uid;
  int? blogId;
  int? size;
  int? width;
  int? height;
  String? path;
  String? createdAt;
  String? large;
  String? middle;
  String? small;
  String? video;

  BlogAssetModel(
      {this.id,
        this.type,
        this.uid,
        this.blogId,
        this.size,
        this.width,
        this.height,
        this.path,
        this.createdAt,
        this.large,
        this.middle,
        this.small,
        this.video});

  BlogAssetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    uid = json['uid'];
    blogId = json['blogId'];
    size = json['size'];
    width = json['width'];
    height = json['height'];
    path = json['path'];
    createdAt = json['createdAt'];
    large = json['large'];
    middle = json['middle'];
    small = json['small'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['uid'] = this.uid;
    data['blogId'] = this.blogId;
    data['size'] = this.size;
    data['width'] = this.width;
    data['height'] = this.height;
    data['path'] = this.path;
    data['createdAt'] = this.createdAt;
    data['large'] = this.large;
    data['middle'] = this.middle;
    data['small'] = this.small;
    data['video'] = this.video;
    return data;
  }
}