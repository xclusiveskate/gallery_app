// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:gallery_app/gallery/model/model.dart';
import 'package:http/http.dart' as http;

String imageUrl = 'https://api.pexels.com/v1/curated?page=1&per_page=20';

class ServiceCall {
  static getCall() async {
    try {
      var info = Uri.parse(imageUrl);
      var response = await http.get(info, headers: {'Authorization': ""});

      var refinedData = jsonDecode(response.body);
      var photos = refinedData['photos'] as List;
      imageUrl = refinedData['next_page'];

      // addPhoto(photos);

      for (var photo in photos) {
        images.add(PhotoModel.fromMap(photo));
      }

      // photos.forEach((photo) {
      //   images.add(PhotoModel.fromMap(photo));
      // });
    } catch (e) {
      print(e);
    }
  }

  // static addPhoto(List imagese) {
  //   for (var image in imagese) {
  //     images.add(PhotoModel.fromMap(image));
  //   }
  // }

  static getSearch(String url) async {
    try {
      var info = Uri.parse(url);
      var response = await http.get(info, headers: {'Authorization': ""});
      var refinedPhoto = jsonDecode(response.body);
      var sPhotos = refinedPhoto['photos'] as List;
      url = refinedPhoto['next_page'];

      for (var photo in sPhotos) {
        sImages.add(PhotoModel.fromMap(photo));
      }
    } catch (e) {
      print(e);
    }
  }
}
