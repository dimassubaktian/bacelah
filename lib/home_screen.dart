import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import '../news_detail_screen.dart';
import '../utils/color.dart';
import '../utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:slugify/slugify.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _newsData = [];
  String _source = "cnn-news";
  bool _loading = true;
  late Future _fGetData;

  @override
  void initState() {
    super.initState();
    _loading = false;
    _fGetData = _getData();
  }

  Future _getData() async {
    try {
      final response = await http.get(
        Uri.parse(api + _source),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _newsData = data['data'];
        });
      }
    } catch (e) {
      // if (kDebugMode) {
      //   print(e);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Bacelah'),
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text('Pilih Sumber Berita'),
                  const SizedBox(
                    width: 15,
                  ),
                  DropDown(
                    items: const ["CNN News", "CNBC News", "Republika News", "Kumparan News", "Okezone News"],
                    hint: const Text("CNN News"),
                    icon: const Icon(
                      Icons.expand_more,
                      color: Colors.blue,
                    ),
                    onChanged: (p0) {
                      setState(() {
                        _loading = true;
                        _source = slugify(p0!);
                        _fGetData = _getData();
                        Future.delayed(const Duration(milliseconds: 250)).then((onValue) {
                          _loading = false;
                        });
                      });
                    },
                  ),
                ],
              )),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _getData,
              child: FutureBuilder(
                future: _fGetData,
                initialData: "Loading",
                builder: (context, snapshot) {
                  if (snapshot.hasData || _loading == true) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(greenprimary),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      itemCount: _newsData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Container(
                            color: Colors.grey[200],
                            height: 100,
                            width: 100,
                            child: _newsData[index]['image']['small'] != null && _newsData[index]['image']['small'] != ""
                                ? Image.network(
                                    _newsData[index]['image']['small'],
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(greenprimary),
                                          ),
                                        );
                                      }
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(greenprimary),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(),
                          ),
                          title: Text(
                            '${_newsData[index]['title']}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${_newsData[index]['contentSnippet'] ?? (_newsData[index]['description'] ?? _newsData[index]['content'])}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailScreen(
                                  author: _newsData[index]['author'],
                                  content: _newsData[index]['contentSnippet'] ?? (_newsData[index]['description'] ?? _newsData[index]['content']),
                                  publishedAt: _newsData[index]['isoDate'],
                                  title: _newsData[index]['title'],
                                  url: _newsData[index]['link'],
                                  urlToImage: _newsData[index]['image']['large'] ?? _newsData[index]['image']['small'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
