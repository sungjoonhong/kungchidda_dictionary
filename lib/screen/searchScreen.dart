import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  // const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController textEditingController = TextEditingController();
  late StreamController streamController;
  late Stream _stream;
  late Timer _debounce;

  String url = "https://api.twinword.com/api/word/definition_kr/latest/?entry=";
  String token = "dd4f76822e180bea6b489b6b2f4a224560e9fa24";

  @override
  void initState() {
    super.initState();
    streamController = StreamController();
    _stream = streamController.stream;
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      searchText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Dictionary",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12, bottom: 11),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      color: Colors.white),
                  child: TextFormField(
                    onChanged: (String text) {
                      if (_debounce.isActive) {
                        _debounce.cancel();
                      }
                      _debounce = Timer(const Duration(milliseconds: 1000), () {
                        searchText();
                      });
                      // searchText();
                    },
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      hintText: "Search for a word",
                      contentPadding: EdgeInsets.only(left: 24),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () => searchText(),
              )
            ],
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Text("Enter a search word"),
              );
            }
            if (snapshot.data == "waiting") {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == "NoData") {
              return const Center(
                child: Text(
                  'No Defination 😭',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              );
            }
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return ListBody(
                  children: [
                    Container(
                        color: Colors.grey[300],
                        child: ListTile(
                            // leading: snapshot.data["definitions"][index]
                            //             ["image_url"] ==
                            //         null
                            //     ? null
                            //     : CircleAvatar(
                            //         backgroundImage: NetworkImage(snapshot
                            //             .data["definitions"][index]["image_url"]),
                            //       ),
                            title: Text(textEditingController.text.trim()))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(snapshot.data["meaning"]["korean"]),
                    ),
                    snapshot.data["meaning"]["adjective"] != ""
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(snapshot.data["meaning"]["adjective"]),
                          )
                        : Container(),
                    snapshot.data["meaning"]["adverb"] != ""
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(snapshot.data["meaning"]["adverb"]),
                          )
                        : Container(),
                    snapshot.data["meaning"]["noun"] != ""
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(snapshot.data["meaning"]["noun"]),
                          )
                        : Container(),
                    snapshot.data["meaning"]["noun"] != ""
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(snapshot.data["meaning"]["verb"]),
                          )
                        : Container(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // search function
  searchText() async {
    if (textEditingController.text.isEmpty) {
      streamController.add(null);
      return;
    }
    streamController.add("waiting");
    Uri targetUrl = Uri.parse(url + textEditingController.text.trim());

    Response response = await get(targetUrl, headers: {
      "Content-Type": "application/json",
      "Host": "api.twinword.com",
      "X-Twaip-Key":
          "ScL8P2+zWln8zWKpfpHFprBFIzYWeZs6DVhuMrIvIvTqsicQf8RugVSs7kSjXh2L5fatiHHNiho1ERq6hk4iDA=="
    });

    if (response.statusCode == 200) {
      streamController.add(json.decode(response.body));
    }
    // if (response.body.contains('[{"message":"No definition :("}]')) {
    //   streamController.add("NoData");
    //   return;
    // } else {
    //   streamController.add(json.decode(response.body));
    //   return;
    // }
  }
}
