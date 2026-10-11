// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../../widgets/app_layout.dart';

// class ClassificationPage extends StatelessWidget {
//   const ClassificationPage({super.key});
class ClassificationPage extends StatefulWidget {
  const ClassificationPage({super.key});

  @override
  State<ClassificationPage> createState() => _MyClassificationPageState();
}

class _MyClassificationPageState extends State<ClassificationPage> {
  int currentTab1Index = 0;
  int currentTab2Index = 0;
  int currentTab3Index = 0;
  int currentTab4Index = 0;
  int currentTab5Index = 0;

  Widget _filterRow(
    String label,
    List<String> values,
    int selected,
    ValueChanged<int> onSelected,
  ) =>
      LayoutBuilder(
        builder: (context, constraints) {
          final chips = List.generate(
            values.length,
            (index) => ChoiceChip(
              selected: index == selected,
              onSelected: (_) => onSelected(index),
              label: Text(values[index]),
            ),
          );
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    width: 52,
                    child: Text(label,
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                ),
                Expanded(
                  child: constraints.maxWidth >= AppLayout.navigationBreakpoint
                      ? Wrap(spacing: 8, runSpacing: 8, children: chips)
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: chips
                                .map((chip) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: chip,
                                    ))
                                .toList(),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      );

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
      appBar: AppBar(title: const Text('分类')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppLayout.contentMaxWidth),
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: AppLayout.contentPadding(constraints.maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _filterRow('类型', tab1, currentTab1Index,
                      (index) => setState(() => currentTab1Index = index)),
                  _filterRow('题材', tab1_1, currentTab2Index,
                      (index) => setState(() => currentTab2Index = index)),
                  _filterRow('地区', tab3, currentTab3Index,
                      (index) => setState(() => currentTab3Index = index)),
                  _filterRow('年份', tab4, currentTab4Index,
                      (index) => setState(() => currentTab4Index = index)),
                  _filterRow('排序', tab5, currentTab5Index,
                      (index) => setState(() => currentTab5Index = index)),
                  const Divider(height: 32),
                  Center(
                    child: FilledButton(
                      onPressed: () {},
                      child: const Text('没写完,捐赠加快进度'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
