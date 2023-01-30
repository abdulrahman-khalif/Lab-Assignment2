import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homestay/models/home.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ServerConfig.dart';
import '../models/user.dart';
import '../utils/mycolor.dart';

class HomeStayDetails extends StatefulWidget {
  final User user;
  final Homes homes;
  final User seller;
  const HomeStayDetails(
      {super.key,
      required this.user,
      required this.homes,
      required this.seller});

  @override
  State<HomeStayDetails> createState() => _HomeStayDetailsState();
}

class _HomeStayDetailsState extends State<HomeStayDetails> {
  late double screenHeight, screenWidth, resWidth;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.90;
    }

    return Scaffold(
      backgroundColor: AppColors.kBgColor,
      appBar: AppBar(
        title: const Text("Details",
            style: TextStyle(
              color: Colors.black,
            )),
      ),
      body: Column(children: [
        SizedBox(
          height: 250,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            Card(
              elevation: 8,
              child: Container(
                  height: screenHeight / 3,
                  width: 350,
                  child: CachedNetworkImage(
                    width: resWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${ServerConfig.SERVER}/assets/home_images/${widget.homes.homeId}.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )),
            ),
            Card(
              elevation: 8,
              child: Container(
                  height: screenHeight / 3,
                  width: 350,
                  child: CachedNetworkImage(
                    width: resWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${ServerConfig.SERVER}/assets/home_images/${widget.homes.homeId}_2.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )),
            ),
            Card(
              elevation: 8,
              child: Container(
                  height: screenHeight / 3,
                  width: 350,
                  child: CachedNetworkImage(
                    width: resWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${ServerConfig.SERVER}/assets/home_images/${widget.homes.homeId}_3.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )),
            ),
          ]),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
            child: Stack(children: [
          Container(
              padding: const EdgeInsets.only(top: 30, right: 40, left: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.homes.name}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$ ${widget.homes.price} par day',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Home Stay Description',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.homes.homeDesc}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.homes.states}, ${widget.homes.local}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Oner Name',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      ' ${widget.seller.name}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                        child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                iconSize: 22,
                                onPressed: makePhoneCall,
                                icon: const Icon(Icons.call)),
                            IconButton(
                                iconSize: 22,
                                onPressed: makemessage,
                                icon: const Icon(Icons.message)),
                            // IconButton(
                            //     iconSize: 22,
                            //     onPressed: whatsapp,
                            //     icon: const Icon(Icons.whatsapp)),
                            IconButton(
                                iconSize: 22,
                                onPressed: onRoute,
                                icon: const Icon(Icons.map)),
                            IconButton(
                                iconSize: 22,
                                onPressed: onShowMap,
                                icon: const Icon(Icons.maps_home_work))
                          ],
                        ),
                      ),
                    )),
                  ])),
        ])),
      ]),
    );
  }

  Future<void> makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: widget.seller.phone,
    );
    await launchUrl(launchUri);
  }

  Future<void> makemessage() async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: widget.seller.phone,
    );
    await launchUrl(launchUri);
  }

  // void whatsapp() async {
  //   var whatsapp = widget.seller.phone;
  //   var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=hello";
  //   var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
  //   if (Platform.isIOS) {
  //     // for iOS phone only
  //     if (await canLaunch(whatappURLIos)) {
  //       await launch(whatappURLIos, forceSafariVC: false);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("whatsapp not installed")));
  //     }
  //   } else {
  //     // android , web
  //     if (await canLaunch(whatsappURlAndroid)) {
  //       await launch(whatsappURlAndroid);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("whatsapp not installed")));
  //     }
  //   }
  // }

  Future<void> onRoute() async {
    final Uri launchUri = Uri(
        scheme: 'https',
        // ignore: prefer_interpolation_to_compose_strings
        path: "www.google.com/maps/@" +
            widget.homes.lat.toString() +
            "," +
            widget.homes.lng.toString() +
            "20z");
    await launchUrl(launchUri);
  }

  int generateIds() {
    var rng = Random();
    int randomInt;
    randomInt = rng.nextInt(100);
    return randomInt;
  }

  void onShowMap() {
    double lat = double.parse(widget.homes.lat.toString());
    double lng = double.parse(widget.homes.lng.toString());
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    int markerIdVal = generateIds();
    MarkerId markerId = MarkerId(markerIdVal.toString());
    final Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(
        lat,
        lng,
      ),
    );
    markers[markerId] = marker;
    CameraPosition pos = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.4746,
    );
    Completer<GoogleMapController> ncontroller =
        Completer<GoogleMapController>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Location",
            style: TextStyle(),
          ),
          content: Container(
            //color: Colors.red,
            height: screenHeight,
            width: screenWidth,
            child: GoogleMap(
              mapType: MapType.satellite,
              initialCameraPosition: pos,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                ncontroller.complete(controller);
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
