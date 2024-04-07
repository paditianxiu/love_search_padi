// ignore_for_file: file_names
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:love_search_padi/pages/player/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  List<String> searchTabs = [];
  late TabController _tabSearchController;
  List<String> searchUrlList = <String>[];
  List<String> hotImgUrlList = <String>[];
  List<String> hotTitleList = <String>[];
  List<String> laterImgUrlList = <String>[];
  List<String> laterTitleList = <String>[];
  List<String> laterTimeList = <String>[];
  int currentIndex = 0;
  bool _isDisposed = false;
  var searchFilmController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getSearchData();
    _tabController = TabController(vsync: this, length: 2);
    getHotData();
    getLaterData();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  final Dio dio = Dio();

  Future<Uint8List> loadImageFromUrl(String imageUrl) async {
    var response = await dio.get(imageUrl,
        options: Options(headers: {
          'User-Agent': 'PostmanRuntime/7.37.0',
        }, responseType: ResponseType.bytes));
    return response.data;
  }

  getHotData() async {
    var response = await Dio().get(
        "https://movie.douban.com/j/search_subjects?&type=movie&sort=recommend&tag=%E7%83%AD%E9%97%A8&page_limit=21&page_start=1");
    var objectList = response.data['subjects'] as List;
    if (!_isDisposed && mounted) {
      setState(() {
        for (var i = 0; i < objectList.length; i++) {
          hotImgUrlList.add(objectList[i]['cover']);
          hotTitleList.add(objectList[i]['title']);
        }
      });
    }
  }

  getLaterData() async {
    var response = await Dio().get("https://movie.douban.com/cinema/later/");
    var document = parse(response.data);
    var mod = document.querySelectorAll(".item");
    debugPrint(mod.length.toString());
    for (var element in mod) {
      var allContent = element.innerHtml;
      var allDocument = parse(allContent);
      var imgUrl = allDocument.querySelector("img")!.attributes["src"];
      var title = allDocument
          .querySelector("h3")
          ?.text
          .replaceAll("\n", "")
          .replaceAll(" ", "");
      var time = allDocument.querySelector(".dt")!.text;
      if (!_isDisposed && mounted) {
        setState(() {
          laterTitleList.add(title!);
          laterImgUrlList.add(imgUrl!);
          laterTimeList.add(time);
        });
      }
    }
  }

  getSearchData() async {
    var response = await Dio().get("https://wds.ecsxs.com/216237.json");
    var objectList = response.data as List;
    if (!_isDisposed && mounted) {
      setState(() {
        searchTabs.clear();
        debugPrint(objectList.length.toString());
        for (var i = 0; i < objectList.length; i++) {
          searchTabs.add(objectList[i]["name"]);
          searchUrlList.add(objectList[i]['url']);
        }
        _tabSearchController =
            TabController(vsync: this, length: searchTabs.length);
      });
    }
  }

  bool isSearch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('爱搜片'),
        actions: [
          IconButton(
              onPressed: () {
                if (searchUrlList.isNotEmpty) {
                  showSearchDialog("");
                } else {
                  final context = this.context;
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('提示'),
                        content: const SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text("搜索源正在初始化，请稍后..."),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('确定'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              icon: const Icon(Icons.search)),
          const SizedBox(width: 10)
        ],
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.whatshot),
                Text('热门推荐'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_note),
                Text('即将上映'),
              ],
            ),
          ),
        ]),
      ),
      body: TabBarView(controller: _tabController, children: [
        ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: hotImgUrlList.isNotEmpty
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: hotImgUrlList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildGridItem(hotTitleList[index],
                          hotImgUrlList[index], "", true, {}, index);
                    })
                : const Center(child: CircularProgressIndicator())),
        ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: laterImgUrlList.isNotEmpty
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: hotImgUrlList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildGridItem(
                          laterTitleList[index],
                          laterImgUrlList[index],
                          laterTimeList[index],
                          true,
                          {},
                          index);
                    })
                : const Center(child: CircularProgressIndicator())),
      ]),
    );
  }

  showSearchDialog(String keyword) {
    List<String> vodNamelist = <String>[];
    List<String> vodClasslist = <String>[];
    List<String> vodPiclist = <String>[];
    List<String> vodPlayUrllist = <String>[];
    List<String> vodContentList = <String>[];
    List<String> subTitlelist = <String>[];
    List<String> vodIdlist = <String>[];
    Map data0 = {};
    searchFilmController = TextEditingController(text: keyword);
    if (searchUrlList.isEmpty) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('提示'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("搜索源正在初始化，请稍后..."),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext innerContext, StateSetter setState) {
              return Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      )),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.movie),
                        trailing: FilledButton.icon(
                            onPressed: () async {
                              if (searchFilmController.text.isEmpty) {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('提示'),
                                      content: const SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text("输入不能为空"),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('确定'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }
                              FocusScope.of(context).unfocus();
                              String currentSearchUrl =
                                  "${searchUrlList[currentIndex]}?ac=detail&wd=${Uri.encodeComponent(searchFilmController.text)}";
                              debugPrint(currentSearchUrl);
                              setState(() {
                                isSearch = true;
                                vodNamelist.clear();
                                vodPiclist.clear();
                                vodClasslist.clear();
                                vodPlayUrllist.clear();
                                vodContentList.clear();
                                subTitlelist.clear();
                                vodIdlist.clear();
                              });

                              try {
                                var response =
                                    await Dio().get(currentSearchUrl);
                                var data =
                                    json.decode(response.data)['list'] as List;
                                for (var element in data) {
                                  var vodName = element['vod_name'];
                                  var vodPic = element['vod_pic'];
                                  var vodClass = element['vod_class'];
                                  var vodPlayUrl =
                                      element['vod_play_url'] + "#";
                                  var vodContent = element['vod_content'];
                                  var vodId = element['vod_id'].toString();
                                  var subTitle = element['vod_year'] +
                                      " / " +
                                      element['vod_area'] +
                                      " / " +
                                      vodClass +
                                      " / " +
                                      element['vod_time'];

                                  vodNamelist.add(vodName);
                                  vodPiclist.add(vodPic);
                                  vodClasslist.add(vodClass);
                                  vodPlayUrllist.add(vodPlayUrl);
                                  vodContentList.add(vodContent);
                                  subTitlelist.add(subTitle);
                                  vodIdlist.add(vodId);
                                }
                                setState(() {
                                  data0["标题"] = vodNamelist;
                                  data0["副标题"] = subTitlelist;
                                  data0["图片"] = vodPiclist;
                                  data0["简介"] = vodContentList;
                                  data0["播放地址"] = vodPlayUrllist;
                                  data0["影视ID"] = vodIdlist;
                                  data0["资源网链接"] = searchUrlList[currentIndex];
                                  isSearch = false;
                                });
                              } catch (e) {
                                final context = this.context;
                                Future.delayed(const Duration(seconds: 1), () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('错误'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text("$e\n可能是搜索次数太多,过一伙在搜索吧。"),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('确定'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              }
                            },
                            icon: const Icon(Icons.search),
                            label: const Text("搜索")),
                        title: TextField(
                          controller: searchFilmController,
                          decoration: const InputDecoration(
                              labelText: '输入搜索的关键词...',
                              border: OutlineInputBorder()),
                        ),
                      ),
                      TabBar(
                          tabAlignment: TabAlignment.start,
                          onTap: (value) {
                            setState(() {
                              currentIndex = value;
                            });
                          },
                          isScrollable: true,
                          controller: _tabSearchController,
                          tabs: searchTabs.map((e) => Tab(text: e)).toList()),
                      ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height - 400,
                          ),
                          child: !isSearch
                              ? GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.6,
                                  ),
                                  itemCount: vodNamelist.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return buildGridItem(
                                        vodNamelist[index],
                                        vodPiclist[index],
                                        vodClasslist[index],
                                        false,
                                        data0,
                                        index);
                                  })
                              : const Center(
                                  child: CircularProgressIndicator())),
                    ],
                  ));
            },
          );
        });
  }

  buildGridItem(String title, String imgUrl, String time, bool canSearch,
      Map map, index) {
    return GestureDetector(
      onTap: () {
        if (canSearch) {
          showSearchDialog(title);
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return VideoScreen(
              data: map,
              pos: index,
            );
          }));
        }
      },
      child: Card.outlined(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          httpHeaders: const {
                            'User-Agent': 'PostmanRuntime/7.37.0'
                          },
                          width: double.infinity,
                          height: 100,
                          imageUrl: imgUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.error),
                          ),
                        ),
                        //
                        //     FutureBuilder<Uint8List>(
                        //   future: loadImageFromUrl(imgUrl),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.hasData) {
                        //       return Image.memory(
                        //           width: double.infinity,
                        //           snapshot.data ?? Uint8List(0),
                        //           fit: BoxFit.cover);
                        //     } else if (snapshot.hasError) {
                        //       return Center(
                        //           child: Text('Error: ${snapshot.error}'));
                        //     }
                        //     return const Center(
                        //       child: CircularProgressIndicator(),
                        //     );
                        //   },
                        // )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              textAlign: TextAlign.center,
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                        ],
                      ),
                    ],
                  ),
                  time != ""
                      ? Positioned(
                          left: 0,
                          top: 10,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withAlpha(95),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(time,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    )),
                              )))
                      : const Text("")
                ],
              ))),
    );
  }
}
