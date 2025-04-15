abstract class BasicInfoEvent {}

class UpdateName extends BasicInfoEvent {
  final String name;
  UpdateName(this.name);
}

class UpdateExperience extends BasicInfoEvent {
  final String experience;
  UpdateExperience(this.experience);
}

class UpdateExpertise extends BasicInfoEvent {
  final String expertise;
  UpdateExpertise(this.expertise);
}

class UpdateBio extends BasicInfoEvent {
  final String bio;
  UpdateBio(this.bio);
}

class SubmitBasicInfo extends BasicInfoEvent {
  final String userId;
  SubmitBasicInfo(this.userId);
}
