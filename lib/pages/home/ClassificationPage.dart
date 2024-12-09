// ignore_for_file: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class ClassificationPage extends StatelessWidget {
//   const ClassificationPage({super.key});
class ClassificationPage extends StatefulWidget {
  const ClassificationPage({super.key});

  @override
  State<ClassificationPage> createState() => _MyClassificationPageState();
}

int currentTab1Index = 0;
int currentTab2Index = 0;
int currentTab3Index = 0;
int currentTab4Index = 0;
int currentTab5Index = 0;

class _MyClassificationPageState extends State<ClassificationPage> {
  @override
  Widget build(BuildContext context) {
    List<String> tab1 = ['电视', '电影', '综艺', '动漫', '少儿'];
    List<String> tab1_1 = [
      '全部',
      '古装',
      '都市',
      '言情',
      '武侠',
      '战争',
      '青春',
      '喜剧',
      '家庭',
      '伦理',
      '谍战',
      '军旅',
      '犯罪',
      '动作',
      '奇幻',
      '神话',
      '历史',
      '剧情',
      '经典',
      '乡村',
      '情景',
      '商战',
      '网剧',
      '其他'
    ];
    List<String> tab3 = [
      '全部',
      '内地',
      '美国',
      '韩国',
      '香港',
      '台湾',
      '日本',
      '泰国',
      '英国',
      '新加坡',
      '其他地区'
    ];
    List<String> tab4 = [
      '全部',
      '2024',
      '2023',
      '2022',
      '2021',
      '2020',
      '2019',
      '2018',
      '2017',
      '2016',
      '2015',
      '2014',
      '2013',
      '2012',
      '2010',
      '00年代',
      '90年代',
      '80年代'
    ];
    List<String> tab5 = [
      '热门',
      '更新',
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text('分类'),
        ),
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ChoiceChip(
                            selected: index == currentTab1Index,
                            onSelected: (value) {
                              setState(() {
                                currentTab1Index = index;
                              });
                            },
                            label: Text(tab1[index]),
                          ),
                        );
                      },
                      childCount: tab1.length,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ChoiceChip(
                            selected: index == currentTab2Index,
                            onSelected: (value) {
                              setState(() {
                                currentTab2Index = index;
                              });
                            },
                            label: Text(tab1_1[index]),
                          ),
                        );
                      },
                      childCount: tab1_1.length,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ChoiceChip(
                            selected: index == currentTab3Index,
                            onSelected: (value) {
                              setState(() {
                                currentTab3Index = index;
                              });
                            },
                            label: Text(tab3[index]),
                          ),
                        );
                      },
                      childCount: tab3.length,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ChoiceChip(
                            selected: index == currentTab4Index,
                            onSelected: (value) {
                              setState(() {
                                currentTab4Index = index;
                              });
                            },
                            label: Text(tab4[index]),
                          ),
                        );
                      },
                      childCount: tab4.length,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ChoiceChip(
                            selected: index == currentTab5Index,
                            onSelected: (value) {
                              setState(() {
                                currentTab5Index = index;
                              });
                            },
                            label: Text(tab5[index]),
                          ),
                        );
                      },
                      childCount: tab5.length,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: Center(
                  child: FilledButton(
                      onPressed: () {}, child: const Text("没写完,捐赠加快进度"))),
            )
          ],
        ));
  }
}
