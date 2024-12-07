
abstract class ProfileEvent {}

class FetchProfile extends ProfileEvent {
  final String userId;
  FetchProfile({required this.userId});
}

class UpdateProfile extends ProfileEvent {
  final String? name;
  final String? imageUrl;

  UpdateProfile({this.name, this.imageUrl});

  List<Object?> get props => [name, imageUrl];
}
