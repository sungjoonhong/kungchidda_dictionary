import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String url = "https://owlbot.info/api/v4/dictionary/";
  String token = "dd4f76822e180bea6b489b6b2f4a224560e9fa24";

  TextEditingController textEditingController = TextEditingController();

  // Stream for loading the text as soon as it is typed
  late StreamController streamController;
  late Stream _stream;

  late Timer _debounce;

  // search function
  searchText() async {
    if (textEditingController.text.isEmpty) {
      streamController.add(null);
      return;
    }
    streamController.add("waiting");
    Uri targetUrl = Uri.parse(url + textEditingController.text.trim());

    Response response =
        await get(targetUrl, headers: {"Authorization": "Token " + token});

    if (response.statusCode == 200) {
      streamController.add(json.decode(response.body));
    }
    if (response.body.contains('[{"message":"No definition :("}]')) {
      streamController.add("NoData");
      return;
    } else {
      streamController.add(json.decode(response.body));
      return;
    }
  }

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
              itemCount: snapshot.data["definitions"].length,
              itemBuilder: (BuildContext context, int index) {
                return ListBody(
                  children: [
                    Container(
                        color: Colors.grey[300],
                        child: ListTile(
                          leading: snapshot.data["definitions"][index]
                                      ["image_url"] ==
                                  null
                              ? null
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot
                                      .data["definitions"][index]["image_url"]),
                                ),
                          title: Text(textEditingController.text.trim() +
                              "(" +
                              snapshot.data["definitions"][index]["type"] +
                              ")"),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          snapshot.data["definitions"][index]["definition"]),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
