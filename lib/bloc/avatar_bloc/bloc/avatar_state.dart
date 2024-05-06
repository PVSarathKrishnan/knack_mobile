part of 'avatar_bloc.dart';

sealed class AvatarState extends Equatable {
  const AvatarState();

  @override
  List<Object> get props => [];
}

final class AvatarPickerInitial extends AvatarState {}

class AvatarUpdateState extends AvatarState {
  final Uint8List avatarFile;

  AvatarUpdateState({required this.avatarFile});
  
  @override
  List<Object> get props => [avatarFile];
}
