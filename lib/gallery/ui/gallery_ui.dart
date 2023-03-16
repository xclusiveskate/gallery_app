import 'package:animated_page_transition/animated_page_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/gallery/model/model.dart';
import 'package:gallery_app/gallery/service/http_call.dart';
import 'package:gallery_app/gallery/ui/photo_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
// import 'package:animated_page_transition/animated_page_transition.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MobileView extends StatefulWidget {
  final dynamic width;
  const MobileView({super.key, this.width});

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> with TickerProviderStateMixin {
  bool isSearching = false;
  bool isListView = false;
  String searchUrl = '';
  ScrollController scroll = ScrollController();
  TextEditingController queryController = TextEditingController();
  getPhoto() async {
    await ServiceCall.getCall();
    setState(() {});
  }

  getSearchPhoto() async {
    if (queryController.text.isNotEmpty) {
      await ServiceCall.getSearch(searchUrl);
      setState(() {});
    }
  }

  @override
  void initState() {
    getPhoto();

//listener not working
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent &&
          images.length != 100) {
        print("photos");
        getPhoto();
      }
      if (scroll.position.pixels == scroll.position.maxScrollExtent &&
          sImages.length != 100 &&
          isSearching == true) {
        getSearchPhoto();
      }
    });
    super.initState();

    queryController.addListener(() {
      if (queryController.text.isEmpty) {
        setState(() {
          sImages.clear();
        });
      } else if (queryController.text.isNotEmpty) {
        setState(() {
          // isSearching = true;
          searchUrl =
              "https://api.pexels.com/v1/search?query=${queryController.text}&per_page=20";
        });
      }
    });
  }

  @override
  void dispose() {
    queryController.dispose();
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 243, 196),
      appBar: AppBar(
        title: const Text(" Gallery App"),
        actions: [
          isSearching ? searchBox(context) : const SizedBox.shrink(),
          IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
              icon: isSearching
                  ? const Icon(Icons.cancel)
                  : const Icon(Icons.search)),
          PopupMenuButton(
              onSelected: (value) {},
              color: Colors.lime.withOpacity(0.5),
              child: const Icon(Icons.more_vert),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      onTap: () {
                        setState(() {
                          isListView = !isListView;
                        });
                      },
                      value: 1,
                      child: isListView
                          ? const Text("Grid View")
                          : const Text("List View")),
                  const PopupMenuItem(value: 2, child: Text("Settings")),
                ];
              })
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            images.isEmpty
                ? const Center(
                    heightFactor: 200,
                    widthFactor: 200,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: Colors.blue,
                    ),
                  )
                : isListView
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        controller: scroll,
                        shrinkWrap: true,
                        itemCount: isSearching ? sImages.length : images.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PhotoView(
                                                      photo: isSearching
                                                          ? sImages[index]
                                                          : images[index],
                                                    )));
                                      },
                                      child: GridTile(
                                        child: Image.network(
                                          colorBlendMode: BlendMode.clear,
                                          isSearching
                                              ? sImages[index].src.landscape
                                              : images[index].src.landscape,
                                          fit: BoxFit.fitHeight,
                                          errorBuilder:
                                              ((context, error, stackTrace) =>
                                                  const Text('unable to load')),
                                        ),
                                      ))));
                        })
                    : StaggeredGridView.countBuilder(
                        controller: scroll,
                        mainAxisSpacing: .5,
                        crossAxisSpacing: .9,
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        itemCount: isSearching ? sImages.length : images.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: PageTransitionButton(
                                      vsync: this,
                                      nextPage: PhotoView(
                                          photo: isSearching
                                              ? sImages[index]
                                              : images[index]),
                                      child: GridTile(
                                        child: CachedNetworkImage(
                                          imageUrl: isSearching
                                              ? sImages[index].src.portrait
                                              : images[index].src.portrait,
                                          // fit: BoxFit.fitHeight,
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  CircularProgressIndicator(
                                            strokeWidth: 1.0,
                                            value: progress.progress,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Center(
                                            child: Text(error),
                                          ),
                                        ),
                                      ))));
                        },
                        staggeredTileBuilder: (int index) {
                          return StaggeredTile.count(
                              1, index.isEven ? 1.4 : 1.6);
                        },
                      )
          ],
        ),
      ),
    );
  }

  SizedBox searchBox(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          controller: queryController,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 1.0, color: Colors.green),
              ),
              contentPadding: const EdgeInsets.all(6),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              hintText: "Search Photo",
              suffixIcon: IconButton(
                  onPressed: () {
                    getSearchPhoto();
                  },
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Colors.black,
                  ))),
          onEditingComplete: () {
            getSearchPhoto();
          },
        ),
      ),
    );
  }
}
