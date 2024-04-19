// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

import 'dart:convert';
import 'dart:ffi';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//import 'package:wakelock/wakelock.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteToggleIconButton extends StatefulWidget {
  final Map<dynamic, dynamic> data;
  final int pos;
  final Function() onStateChanged; // 增加一个回调函数，用于通知外部收藏状态变化

  const FavoriteToggleIconButton({
    super.key,
    required this.data,
    required this.pos,
    required this.onStateChanged,
  });

  @override
  _FavoriteToggleIconButtonState createState() =>
      _FavoriteToggleIconButtonState();
}

class _FavoriteToggleIconButtonState extends State<FavoriteToggleIconButton> {
  late List<String> favoriteList;
  bool isFavorite = false;
  late String favoriteJsonString;

  @override
  void initState() {
    super.initState();

    loadFavorites().then((value) {
      setState(() {
        favoriteList = value;
        isFavorite = favoriteList.contains(_generateFavoriteJsonString());
      });
    });
  }

  Future<List<String>> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('影视收藏') ?? [];
  }

  String _generateFavoriteJsonString() {
    String resourceUrl = widget.data["资源网链接"];
    String id = widget.data["影视ID"][widget.pos];
    String allUrl = "$resourceUrl?ac=detail&ids=$id";

    var jsonData = {
      'url': allUrl,
      'name': widget.data["标题"][widget.pos],
      'imgUrl': widget.data["图片"][widget.pos],
    };

    return jsonEncode(jsonData);
  }

  void _toggleFavorite() async {
    String newFavoriteJsonString = _generateFavoriteJsonString();

    if (!isFavorite) {
      favoriteList.add(newFavoriteJsonString);
    } else {
      favoriteList.remove(newFavoriteJsonString);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('影视收藏', favoriteList);
    setState(() {
      isFavorite = !isFavorite;
    });

    widget.onStateChanged();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "收藏",
      icon: isFavorite
          ? const Icon(Icons.favorite)
          : const Icon(Icons.favorite_border),
      onPressed: _toggleFavorite,
    );
  }
}

class VideoScreen extends StatefulWidget {
  final Map data;
  final int pos;

  const VideoScreen({super.key, required this.data, required this.pos});

  @override
  // ignore: library_private_types_in_public_api
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int currentCollection = 0;
  FijkPlayer player = FijkPlayer();

  _VideoScreenState();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 1);
    setData();
    //Wakelock.enable();
    //player.setDataSource(widget.url, autoPlay: true);
  }

  setData() async {
    String resourceUrl = widget.data["资源网链接"];
    String id = widget.data["影视ID"][widget.pos];
    String allUrl = "$resourceUrl?ac=detail&ids=$id";
    var jsonData = {
      'url': allUrl,
      'name': widget.data["标题"][widget.pos],
      'imgUrl': widget.data["图片"][widget.pos],
    };
    String jsonString = jsonEncode(jsonData);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? historyList = prefs.getStringList('历史记录') ?? [];
    if (!historyList.contains(jsonString)) {
      historyList.add(jsonString);
    } else {
      historyList.remove(jsonString);
      historyList.add(jsonString);
    }
    prefs.setStringList('历史记录', historyList);
  }

  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable();
    List<String> urlListOld;

    if (widget.data["播放地址"][widget.pos].toString().contains("\$\$\$")) {
      urlListOld = widget.data["播放地址"][widget.pos]
          .toString()
          .split("\$\$\$")[1]
          .split("#");
    } else {
      urlListOld = widget.data["播放地址"][widget.pos].toString().split("#");
    }
    var brief = widget.data["简介"][widget.pos]
        .toString()
        .replaceAll(" ", "")
        .replaceAll("<p>", "")
        .replaceAll("<br/>", "")
        .replaceAll("　", "")
        .replaceAll("</p>", "");

    var urlListNew = [];
    urlListNew.clear();
    for (var element in urlListOld) {
      RegExp regExp = RegExp(r'\$(.*)');
      Match? match = regExp.firstMatch(element);
      if (match != null) {
        String url = match.group(1)!;
        urlListNew.add(url);
      } else {}
    }
    player.setDataSource(urlListNew[currentCollection], autoPlay: true);
    final List<double> speedList = [0.5, 1.0,1.5, 2.0,];
    final List<String> menuOptions = ['X0.5', 'x1.0', 'X1.5' ,'X2.0'];
    var localSpeed = "x1.0";
    return Scaffold(
        appBar: AppBar(
          actions: [
            // IconButton(tooltip: "倍数", onPressed: (){}, icon: Icon(Icons.speed)),
            PopupMenuButton(
              onSelected: (String result) {
                localSpeed = result;
                player.setSpeed(speedList[menuOptions.indexOf(result)]);
              },
              icon: const Icon(Icons.speed),
              itemBuilder: (BuildContext context) =>
                  menuOptions.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Row(
                    children: [
                      localSpeed == choice
                          ? Icon(Icons.check,
                              color: Theme.of(context).primaryColor)
                          : const Icon(null),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(choice)
                    ],
                  ),
                );
              }).toList(),
            ),
            FavoriteToggleIconButton(
                data: widget.data, pos: widget.pos, onStateChanged: () {}),
            const SizedBox(width: 10)
          ],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.data["标题"][widget.pos]),
              const SizedBox(height: 4.0),
              Text(
                "第${currentCollection + 1}集",
                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              alignment: Alignment.center,
              child: FijkView(
                color: Colors.black,
                player: player,
              ),
            ),
            SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data["标题"][widget.pos],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                        //textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.data["副标题"][widget.pos],
                        //textAlign: TextAlign.left,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('简介'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(brief),
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
                              });
                        },
                        child: Text(
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          brief,
                          //textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                )),
            TabBar(
                tabAlignment: TabAlignment.start,
                controller: _tabController,
                isScrollable: true,
                tabs: const [
                  Tab(
                    text: 'M3U8',
                  ),
                ]),
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 2.7,
                    crossAxisCount: 3,
                  ),
                  itemCount: urlListNew.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: OutlinedButton.icon(
                          icon: currentCollection == index
                              ? const Icon(Icons.check)
                              : const SizedBox.shrink(),
                          onPressed: () async {
                            if (currentCollection != index) {
                              await player.reset();
                              player.setDataSource(urlListNew[index],
                                  autoPlay: true);
                              setState(() {
                                currentCollection = index;
                              });
                            }
                          },
                          label: Text("第${index + 1}集")),
                    );
                  }),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
    WakelockPlus.disable();
    //Wakelock.disable();
  }
}
