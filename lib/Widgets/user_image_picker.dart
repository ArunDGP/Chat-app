import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  final Function(File _userImage) imagePickFn;
  UserImagePicker(this.imagePickFn);

    @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _userImage;

  void imagePicker() async {
    final userImageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _userImage = File(userImageFile!.path);
    });
    widget.imagePickFn(_userImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: _userImage != null ? FileImage(_userImage!) : null ),
        TextButton.icon(
            onPressed: imagePicker,
            icon: Icon(Icons.camera_alt),
            label: Text('Add an Image')),
      ],
    );
  }
}
