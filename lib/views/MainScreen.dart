import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/home.dart';
import '../models/user.dart';
import 'MainManue.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Homes> homelist = <Homes>[];
  String titlecenter = "";
  final df = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  void initState() {
    super.initState();
    _loadallhome();
  }

  @override
  void dispose() {
    homelist = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Stay"),
      ),
      body: homelist.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(homelist.length, (index) {
                    return Card(
                      child: Column(children: [
                        Flexible(
                          flex: 6,
                          child: CachedNetworkImage(
                            width: 150,
                            fit: BoxFit.cover,
                            imageUrl:
                                "http://10.19.42.192/homestay/assets/home_images/${homelist[index].homeId}.png",
                            placeholder: (context, url) =>
                                const LinearProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(homelist[index].homeDesc.toString()),
                        Text("RM ${homelist[index].price.toString()} par day"),
                        Text(df.format(
                            DateTime.parse(homelist[index].date.toString()))),
                      ]),
                    );
                  }),
                ),
              ),
            ]),
      drawer: MainManue(user: widget.user),
    );
  }

  void _loadallhome() {
    http
        .get(
      Uri.parse("http://10.19.42.192/homestay/php/loadallhome.php"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['homes'] != null) {
            homelist = <Homes>[];
            extractdata['homes'].forEach((v) {
              homelist.add(Homes.fromJson(v));
            });
            titlecenter = "Found";
          } else {
            titlecenter = "No Home Available";
            homelist.clear();
          }
        }
      } else {
        titlecenter = "No Home Available";
        homelist.clear();
      }

      setState(() {});
    });
  }
}
