part of 'image_picker_bloc.dart';

sealed class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();

  @override
  List<Object> get props => [];
}
class PickerInitial extends ImagePickerEvent{}

class GalleryPicker extends ImagePickerEvent{}

class CameraCapture extends ImagePickerEvent{}