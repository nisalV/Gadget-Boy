import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gadget_boy/screens/videoplayer.dart';
import 'package:gadget_boy/screens/viewPdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/link.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Information extends StatefulWidget {
  final String searchType;
  final String searchData;
  final String typeFirebase;

  const Information(this.searchData, this.searchType, this.typeFirebase,
      {Key? key})
      : super(key: key);

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  late String copyLink = '';

  late double width;
  late double height;
  var pad;
  late double newHeight;
  late bool hasData = false;
  late bool pdfExist = false;
  late bool equal = false;
  late bool greater = false;
  late bool greaterStart = false;
  late bool less = false;
  late bool lessStart = false;

  var resDescription;
  List<String> resLinks = [];
  List<String> resVidLinks = [];
  List<String> resVideos = [];
  List<String> resImages = [];
  List<String> resNotes = [];
  List<String> resImgLink = [];
  List<String> resPdf = [];
  List<String> resPdfLink = [];
  List<String> resNoteImages = [];
  List<String> resNoteImgLink = [];

  @override
  void initState() {
    getData().whenComplete(() {
      setState(() {
        resDescription;
        resImgLink;
        resNotes;
        resVidLinks;
        resImages;
        resLinks;
        resVideos;
        hasData;
        resNoteImages;
        resNoteImgLink;
      });
    });
    super.initState();
  }

  Future getData() async {
    var collection = FirebaseFirestore.instance.collection(widget.typeFirebase);
    var docSnapshot = await collection.doc(widget.searchData).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      resDescription = data!['description'];
      try {
        resLinks = List.from(data['links']);
      } catch (e) {}
      try {
        resNotes = List.from(data['notes']);
      } catch (e) {}
      try {
        resImages = List.from(data['images']);
      } catch (e) {}
      try {
        resPdf = List.from(data['pdf']);
      } catch (e) {}
      try {
        resVideos = List.from(data['videos']);
      } catch (e) {}
      try {
        resNoteImages = List.from(data['noteImages']);
      } catch (e) {}

      hasData = true;
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Can not find a result",
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ));
    }

    try {
      for (var element in resPdf) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child("${widget.typeFirebase}/${widget.searchData}/pdf/$element");
        String link = await ref.getDownloadURL();
        resPdfLink.add(link);
      }
    } catch (e) {}
    try {
      for (var element in resImages) {
        Reference ref = FirebaseStorage.instance.ref().child(
            "${widget.typeFirebase}/${widget.searchData}/images/$element");
        String link = await ref.getDownloadURL();
        resImgLink.add(link);
      }
    } catch (e) {}
    try {
      for (var element in resVideos) {
        Reference ref = FirebaseStorage.instance.ref().child(
            "${widget.typeFirebase}/${widget.searchData}/videos/$element");
        String link = await ref.getDownloadURL();
        resVidLinks.add(link);
      }
    } catch (e) {}
    try {
      for (var element in resNoteImages) {
        Reference ref = FirebaseStorage.instance.ref().child(
            "${widget.typeFirebase}/${widget.searchData}/noteImages/$element");
        String link = await ref.getDownloadURL();
        resNoteImgLink.add(link);
      }
    } catch (e) {}

    if (resNoteImgLink.length == resNotes.length) equal = true;
    if (resNoteImgLink.length < resNotes.length) greater = true;
    if (resNoteImgLink.length > resNotes.length) less = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  ///////

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context)
        .size
        .width; // getting width,height (safe area) of the screen
    height = MediaQuery.of(context).size.height;
    pad = MediaQuery.of(context).padding;
    newHeight = height - pad.top - pad.bottom;

    return DefaultTabController(
      length: 5,
      key: _scaffoldKey,
      child: hasData
          ? Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: BackButton(
                  color: Colors.redAccent,
                  onPressed: () async {
                    var appDir = (await getExternalStorageDirectory())?.path;
                    Directory(appDir!).delete(recursive: true);
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: Text(
                  widget.searchType,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.redAccent,
                  ),
                ),
                actions: [
                  Container(),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),

                          // Description

                          Card(
                            elevation: 0.0,
                            color: const Color(0xFA168FFC),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.searchData, //Searched title
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 5),
                                      child: Text(
                                        //Description
                                        resDescription.toString(),
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //Search text

                          const SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                      const TabBar(indicatorColor: Colors.redAccent, tabs: [
                        Tab(
                          icon: Icon(Icons.image_rounded,
                              color: Colors.redAccent),
                        ),
                        Tab(
                          icon: Icon(Icons.note, color: Colors.redAccent),
                        ),
                        Tab(
                          icon: Icon(Icons.picture_as_pdf_rounded,
                              color: Colors.redAccent),
                        ),
                        Tab(
                          icon: Icon(Icons.video_library_rounded,
                              color: Colors.redAccent),
                        ),
                        Tab(
                          icon:
                              Icon(Icons.link_rounded, color: Colors.redAccent),
                        ),
                      ]),
                      SizedBox(
                        height: newHeight - 100,
                        child: TabBarView(children: [
                          //Image Viewer
                          PhotoViewGallery.builder(
                            scrollDirection: Axis.vertical,
                            scrollPhysics: const BouncingScrollPhysics(),
                            builder: (BuildContext context, int index) {
                              return PhotoViewGalleryPageOptions(
                                imageProvider: CachedNetworkImageProvider(
                                    resImgLink[index]), //Image at 'index'
                                initialScale: PhotoViewComputedScale.covered,
                                basePosition: Alignment.center,
                                minScale: PhotoViewComputedScale.covered,
                              );
                            },
                            backgroundDecoration:
                                BoxDecoration(color: Colors.redAccent[100]),
                            itemCount: resImgLink.length,
                            loadingBuilder: (context, event) => const Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 20.0,
                                  height: 20.0,
                                  child: CircularProgressIndicator(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                            pageController: PageController(),
                          ),

                          equal
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 15),
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: resNoteImgLink.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 3.5, 10, 0),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                " ${resNotes[index]}",
                                                style: const TextStyle(
                                                    color: Colors.redAccent),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 10),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: CachedNetworkImage(
                                                      imageUrl:
                                                          resNoteImgLink[index],
                                                      placeholder: (context,
                                                              url) =>
                                                          const Center(
                                                              child: Padding(
                                                                padding: EdgeInsets.all(4),
                                                                child: SizedBox(
                                                                    width: 16,
                                                                    height: 16,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Colors
                                                                          .redAccent,
                                                                    )),
                                                              )),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : greater
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 15),
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: resNotes.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 3.5, 10, 0),
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    " ${resNotes[index]}",
                                                    style: const TextStyle(
                                                        color:
                                                            Colors.redAccent),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 4,
                                                        horizontal: 10),
                                                    child: index >
                                                            (resNoteImgLink
                                                                    .length -
                                                                1)
                                                        ? Container()
                                                        : ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                          child: CachedNetworkImage(
                                                              imageUrl: resNoteImgLink[index],
                                                              placeholder: (context, url) => const Center(
                                                                  child: Padding(
                                                                    padding: EdgeInsets.all(4),
                                                                    child: SizedBox(
                                                                        width: 16,
                                                                        height: 16,
                                                                        child: CircularProgressIndicator(
                                                                          color:
                                                                              Colors.redAccent,
                                                                        )),
                                                                  )),
                                                              errorWidget: (context, url, error) => const Icon(Icons.error)),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : less
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 15),
                                          child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: resNoteImgLink.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 3.5, 10, 0),
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      index >
                                                              (resNotes.length -
                                                                  1)
                                                          ? Container()
                                                          : Text(
                                                              " ${resNotes[index]}",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .redAccent),
                                                            ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4,
                                                                horizontal: 10),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(8),
                                                          child: CachedNetworkImage(
                                                              imageUrl: resNoteImgLink[index],
                                                              placeholder: (context, url) => const Center(
                                                                  child: Padding(
                                                                    padding: EdgeInsets.all(4),
                                                                    child: SizedBox(
                                                                        width: 16,
                                                                        height: 16,
                                                                        child: CircularProgressIndicator(
                                                                          color:
                                                                              Colors.redAccent,
                                                                        )),
                                                                  )),
                                                              errorWidget: (context, url, error) => const Icon(Icons.error)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Container(),
                          ListView.builder(
                            itemCount: resPdf.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                child: GestureDetector(
                                  onTap: () async {
                                    resPdfLink.isNotEmpty
                                        ? await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ViewPDF(
                                                    resPdf[index],
                                                    resPdfLink[index])))
                                        : ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content: Text(
                                              "Database error: Link doesn't exist!",
                                              style:
                                                  TextStyle(color: Colors.red),
                                              textAlign: TextAlign.center,
                                            ),
                                          ));
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 15, 8, 0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Flexible(
                                          child: SizedBox(
                                            width: width - 50,
                                            child: Text(
                                              resPdf[index],
                                              overflow: TextOverflow.visible,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  color: Colors.redAccent),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          ListView.builder(
                            itemCount: resVideos.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                child: GestureDetector(
                                  onTap: () async {
                                    resVidLinks.isNotEmpty
                                        ? await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => VideoPlay(
                                                    resVidLinks[index],
                                                    resVideos[index])))
                                        : ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content: Text(
                                              "Database error: Link doesn't exist!",
                                              style:
                                                  TextStyle(color: Colors.red),
                                              textAlign: TextAlign.center,
                                            ),
                                          ));
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 15, 8, 0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.play_circle_outline_rounded,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Flexible(
                                          child: SizedBox(
                                            width: width - 50,
                                            child: Text(
                                              resVideos[index],
                                              overflow: TextOverflow.visible,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          ListView.builder(
                            itemCount: resLinks.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.insert_link_rounded,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Flexible(
                                        child: SizedBox(
                                          width: width - 100,
                                          child: Link(
                                            uri: Uri.parse(
                                                "https://" + resLinks[index]),
                                            builder: (context, followLink) =>
                                                GestureDetector(
                                              onLongPress: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: resLinks[index]));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                    "Link copied",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ));
                                              },
                                              onTap: followLink,
                                              child: Text(
                                                resLinks[index],
                                                overflow: TextOverflow.visible,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
    );
  }
}
