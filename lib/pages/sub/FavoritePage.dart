// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:love_search_padi/pages/player/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<String> favoriteList = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteList = prefs.getStringList('影视收藏') ?? [];
      favoriteList = favoriteList.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('收藏'),
        ),
        body: favoriteList.isNotEmpty
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.6,
                ),
                itemCount: favoriteList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return const AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CircularProgressIndicator(),
                                Padding(
                                  padding: EdgeInsets.only(top: 26.0),
                                  child: Text("正在加载，请稍后..."),
                                )
                              ],
                            ),
                          );
                        },
                      );

                      try {
                        var response = await Dio().get(
                            jsonDecode(favoriteList[index].toString())["url"]);
                        Navigator.of(context).pop();
                        if (response.statusCode == 200) {
                          List<String> vodNamelist = <String>[];
                          List<String> vodClasslist = <String>[];
                          List<String> vodPiclist = <String>[];
                          List<String> vodPlayUrllist = <String>[];
                          List<String> vodContentList = <String>[];
                          List<String> subTitlelist = <String>[];
                          List<String> vodIdlist = <String>[];
                          Map data0 = {};
                          var content = jsonDecode(response.data)["list"];
                          for (var element in content) {
                            var vodName = element['vod_name'];
                            var vodPic = element['vod_pic'];
                            var vodClass = element['vod_class'];
                            var vodPlayUrl = element['vod_play_url'] + "#";
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
                            final RegExp regex = RegExp(r'^.*?(?=\?)');
                            Match match = regex.firstMatch(jsonDecode(
                                    favoriteList[index].toString())["url"])
                                as Match;
                            data0["资源网链接"] = match.group(0);
                          });

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return VideoScreen(
                              data: data0,
                              pos: 0,
                            );
                          }));
                        } else {
                          Navigator.of(context).pop();
                          showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('提示'),
                                  content: const SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text("网络请求错误"),
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
                        }
                      } catch (e) {
                        showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('错误'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(e.toString()),
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
                      }
                    },
                    child: Card.outlined(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Stack(
                        children: [
                          Column(children: [
                            Expanded(
                              child: CachedNetworkImage(
                                  width: double.infinity,
                                  imageUrl: jsonDecode(
                                      favoriteList[index].toString())["imgUrl"],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Icon(Icons.error),
                                        ),
                                      )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    jsonDecode(
                                        favoriteList[index].toString())["name"],
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                              ],
                            ),
                          ]),
                        ],
                      ),
                    )),
                  );
                })
            : Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/images/null.png'),
                ),
              ));
  }
}
