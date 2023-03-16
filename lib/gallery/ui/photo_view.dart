// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:math';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:animated_page_transition/animated_page_transition.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import 'package:gallery_app/gallery/model/model.dart';

class PhotoView extends StatefulWidget {
  final PhotoModel photo;

  const PhotoView({super.key, required this.photo});

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  // List<PhotoModel> image = images;

  bool isLiked = false;
  String picked = '';
  @override
  void initState() {
    picked = widget.photo.src.portrait;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> imageOrientations = [
      {'name': "Portrait", "orientation": widget.photo.src.portrait},
      {'name': "Landscape", "orientation": widget.photo.src.landscape},
      {'name': "Large", "orientation": widget.photo.src.large},
      {'name': "Large2x", "orientation": widget.photo.src.large2x},
      {'name': "Original", "orientation": widget.photo.src.original},
      {
        'name': "Small",
        "orientation": widget.photo.src.small,
      }
    ];
    return PageTransitionReceiver(
      scaffold: Scaffold(
          backgroundColor: const Color.fromARGB(255, 238, 243, 196),
          appBar: AppBar(
            title: const Text("Photo View"),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Photographer : ${widget.photo.photographer}",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width / 1.3,
                            width: MediaQuery.of(context).size.width,
                            // decoration: const BoxDecoration(color: Colors.amber),
                            child: Image.network(
                              picked,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        left: 100,
                        top: 250,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.lime.withOpacity(0.5),
                          ),
                          child: IconButton(
                              onPressed: () => downloadImage(context, picked),
                              icon: const Icon(
                                Icons.download,
                                color: Colors.white,
                                weight: 30,
                                size: 36,
                              )),
                        )),
                    Positioned(
                        left: 20,
                        top: 250,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.lime.withOpacity(0.5),
                          ),
                          child: IconButton(
                              onPressed: () => share(context),
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                                weight: 30,
                                size: 36,
                              )),
                        )),
                    Positioned(
                        left: 345,
                        top: 245,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.green.withOpacity(0.5),
                          ),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isLiked = !isLiked;
                                });
                              },
                              icon: isLiked
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      weight: 30,
                                      size: 32,
                                    )
                                  : const Icon(
                                      Icons.favorite_outline,
                                      color: Colors.red,
                                      weight: 34,
                                      size: 34,
                                    )),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                const Text(
                  "Pick the Orientation of your choice:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        imageOrientations.length,
                        (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  changeOrientation(
                                      imageOrientations[index]['orientation']);
                                  toast(imageOrientations[index]['name']);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4.5,
                                        width:
                                            MediaQuery.of(context).size.height /
                                                4.5,
                                        child: Image.network(
                                            imageOrientations[index]
                                                ['orientation'],
                                            fit: BoxFit.cover),
                                      ),
                                      Positioned(
                                          left: 105,
                                          top: 90,
                                          child: Transform.rotate(
                                            angle: -math.pi / 2,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              decoration: BoxDecoration(
                                                  color: Colors.lime
                                                      .withOpacity(.6)),
                                              child: Text(
                                                imageOrientations[index]
                                                    ['name'],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            )),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  changeOrientation(orientation) {
    setState(() {
      picked = orientation;
    });
  }

  downloadImage(context, String orientation) async {
    if (Platform.isIOS || Platform.isAndroid) {
      await askPermission();
      var response = await Dio()
          .get(picked, options: Options(responseType: ResponseType.bytes));
      await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
          quality: 60);
      toast("Image Saved", duration: const Duration(seconds: 2));
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      Directory dir = await getApplicationDocumentsDirectory();
      var pathList = dir.path.split('\\');
      pathList[pathList.length - 1] = 'Pictures';
      var picturePath = pathList.join('\\');
      var round = Random();
      var nextRound = round.nextInt(1000000).toString();
      var image =
          await File(join(picturePath, "flutter_image", "image$nextRound.png"))
              .create(recursive: true);

      var response = await Dio()
          .get(picked, options: Options(responseType: ResponseType.bytes));
      await image.writeAsBytes(Uint8List.fromList(response.data));
      toast('Image Saved', duration: const Duration(seconds: 1));
    }
    Navigator.pop(context);
  }

  askPermission() async {
    if (Platform.isIOS) {
      await Permission.photos.request();
    } else {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.storage].request();
      final info = statuses[Permission.storage].toString();
      toast(info);
    }
  }

  share(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox;
    final urlImage = picked;
    final image = await http.get(Uri.parse(urlImage));
    final response = image.bodyBytes;
    final directory = (await getApplicationDocumentsDirectory()).path;
    final path = '$directory/image.png';
    File(path).writeAsBytesSync(response);
    await Share.shareXFiles([XFile(path)],
        text: 'images',
        subject: 'Share now',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    // await Share.share(widget.photo.src.portrait,
    //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
