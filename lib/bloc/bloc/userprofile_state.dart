abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String imageUrl;
  final DateTime createdAt;

  ProfileLoaded({
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.createdAt,
  });
}

class ProfileError extends ProfileState {
  final String errorMessage;
  ProfileError(this.errorMessage);
}

class ProfileUpdated extends ProfileState {}
