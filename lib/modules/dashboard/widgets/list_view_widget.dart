// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:filtercoffee/global/utils/utillity_section.dart';
import 'package:filtercoffee/main.dart';
import 'package:filtercoffee/modules/dashboard/bloc/dashboard_state.dart';
import 'package:flutter/material.dart';

class ListViewWidget extends StatefulWidget {
  late CountryLoadingSuccessState? state;
  ListViewWidget({
    this.state,
    super.key,
  });

  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  late CameraController controller;
  XFile? captureImage;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return (captureImage == null)
        ? Stack(
            children: [
              SizedBox(
                  width: context.screenWidth,
                  height: context.screenHeight,
                  child: CameraPreview(controller)),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    controller.takePicture().then((c) {
                      setState(() {
                        captureImage = c;
                      });
                    });
                  },
                  label: const Text("Capture"),
                  icon: const Icon(Icons.camera),
                ),
              )
            ],
          )
        : Stack(
            children: [
              SizedBox(
                  width: context.screenWidth,
                  height: context.screenHeight * .5,
                  child: Image.file(File(captureImage!.path))),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      label: const Text("Save"),
                      icon: const Icon(Icons.save),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          captureImage = null;
                        });
                      },
                      label: const Text("Cancel"),
                      icon: const Icon(Icons.cancel_rounded),
                    ),
                  ],
                ),
              )
            ],
          );
  }
}
