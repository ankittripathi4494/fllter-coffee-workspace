import 'package:filtercoffee/global/utils/utillity_section.dart';
import 'package:flutter/material.dart';

class ImagePickerWidget {
  static imagePicker(BuildContext context,
      {Function()? galleryFunc, Function()? cameraFunc}) {
    return showModalBottomSheet(
      context: context,
      elevation: 20,
      scrollControlDisabledMaxHeightRatio: 0.4,
      builder: (context) {
        return SizedBox(
          width: context.screenWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Image",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              ((galleryFunc != null) && (cameraFunc != null))
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: galleryFunc,
                          child: const Column(
                            children: [
                              Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.green,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Gallery",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: cameraFunc,
                          child: const Column(
                            children: [
                              Icon(
                                Icons.camera,
                                size: 50,
                                color: Colors.deepPurple,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Camera",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : (((galleryFunc != null) && (cameraFunc == null)
                      ? InkWell(
                          onTap: galleryFunc,
                          child: const Column(
                            children: [
                              Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.green,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Gallery",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      : InkWell(
                          onTap: cameraFunc,
                          child: const Column(
                            children: [
                              Icon(
                                Icons.camera,
                                size: 50,
                                color: Colors.deepPurple,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Camera",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )))
            ],
          ),
        );
      },
    );
  }
}
