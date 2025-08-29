class FollowMasjedResponse {
  String? status;
  String? action;
  int? masjidId;
  int? followersCount;

  FollowMasjedResponse(
      {this.status, this.action, this.masjidId, this.followersCount});

  FollowMasjedResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    action = json['action'];
    masjidId = json['masjid_id'];
    followersCount = json['followers_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['action'] = action;
    data['masjid_id'] = masjidId;
    data['followers_count'] = followersCount;
    return data;
  }
}
