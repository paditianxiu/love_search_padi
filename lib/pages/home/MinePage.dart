// ignore_for_file: file_names, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:love_search_padi/pages/sub/FavoritePage.dart';
import 'package:love_search_padi/pages/sub/HistroyPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: Card.outlined(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                  memCacheWidth: 100,
                  imageUrl:
                      "http://q.qlogo.cn/headimg_dl?spec=640&img_type=jpg&dst_uin=3373587110",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  errorWidget: (context, url, error) => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(Icons.error),
                        ),
                      )),
            )),
          ),
          const SizedBox(height: 2.0),
          const Text(
            '帕帝天秀',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const Text(
            '大专一年级，喜欢Ctrl+C+V',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 8.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FilledButton.icon(
                onPressed: () async {
                  const url =
                      'mqqapi://card/show_pslcard?src_type=internal&version=1&uin=715805346&card_type=group&source=qrcode';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                icon: SvgPicture.string(
                  '''<svg t="1711846523118" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="18996" width="32" height="32"><path d="M515.437714 187.428571a251.428571 251.428571 0 0 1 251.282286 242.797715l0.146286 8.630857v8.594286l30.171428 45.348571c59.684571 79.579429 49.444571 184.685714-15.030857 254.793143l-6.217143 6.473143a32.109714 32.109714 0 0 1-5.558857 4.425143 86.308571 86.308571 0 0 1-32.182857 58.733714c-15.652571 12.507429-35.108571 19.346286-55.149714 19.346286H344.32a92.379429 92.379429 0 0 1-91.721143-81.700572 7.241143 7.241143 0 0 1-0.950857-0.804571c-67.84-67.84-81.956571-172.617143-27.574857-252.416l5.302857-7.387429 31.195429-46.884571V438.857143a251.428571 251.428571 0 0 1 242.797714-251.282286l12.068571-0.146286z m215.222857 321.133715l1.974858-0.438857c-103.753143 25.929143-210.944 33.28-316.635429 22.052571V566.857143a32 32 0 0 1-63.744 4.022857l-0.256-4.022857v-45.750857a909.714286 909.714286 0 0 1-41.691429-8.484572l-14.116571-3.364571-14.592 21.942857c-34.962286 46.592-34.450286 106.057143-4.864 152.502857l48.054857-48.054857a32 32 0 0 1 48.128 41.984l-2.852571 3.291429-51.456 51.382857-0.365715 0.731428a28.379429 28.379429 0 0 0 8.338286 33.28l3.145143 2.194286c3.291429 2.011429 6.985143 3.291429 10.788571 3.803429l3.803429 0.256h338.578286l4.096-0.365715a24.283429 24.283429 0 0 0 14.884571-39.058285l-52.516571-52.224-2.852572-3.291429a32 32 0 0 1 48.128-41.984l52.882286 52.845714c31.305143-45.092571 34.157714-103.972571 1.828571-152.356571l-4.534857-6.4-14.153143-21.174857z m-216.905142-257.170286L512 251.428571a187.428571 187.428571 0 0 0-187.245714 179.492572L324.534857 438.857143v11.337143l1.645714 0.402285c122.624 27.648 249.892571 27.574857 372.48-0.182857l4.132572-1.024 0.036571-10.532571a187.428571 187.428571 0 0 0-179.492571-187.245714l-9.618286-0.219429z" fill="#FFFFFF" p-id="18997"></path></svg>''',
                  width: 28,
                  height: 28,
                ),
                label: const Text("QQ群")),
            const SizedBox(height: 4.0)
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                  onPressed: () async {
                    const url =
                        'mqqapi://card/show_pslcard?src_type=internal&source=sharecard&version=1&uin=3373587110';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                    //callQQ();
                  },
                  icon: SvgPicture.string(
                    '''<svg t="1711843567329" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4443" id="mx_n_1711843567329" width="32" height="32"><path d="M824.8 613.2c-16-51.4-34.4-94.6-62.7-165.3C766.5 262.2 689.3 112 511.5 112 331.7 112 256.2 265.2 261 447.9c-28.4 70.8-46.7 113.7-62.7 165.3-34 109.5-23 154.8-14.6 155.8 18 2.2 70.1-82.4 70.1-82.4 0 49 25.2 112.9 79.8 159-26.4 8.1-85.7 29.9-71.6 53.8 11.4 19.3 196.2 12.3 249.5 6.3 53.3 6 238.1 13 249.5-6.3 14.1-23.8-45.3-45.7-71.6-53.8 54.6-46.2 79.8-110.1 79.8-159 0 0 52.1 84.6 70.1 82.4 8.5-1.1 19.5-46.4-14.5-155.8z" p-id="4444" fill="#FFFFFF"></path></svg>''',
                    width: 28,
                    height: 28,
                  ),
                  label: const Text("QQ")),
              const SizedBox(width: 4.0),
              FilledButton.icon(
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: "paditianxiu"));
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('提示'),
                          content: const SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('已将微信号复制到剪切板'),
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
                  },
                  icon: SvgPicture.string(
                    '''<svg t="1711843664783" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="5711" width="32" height="32"><path d="M664.250054 368.541681c10.015098 0 19.892049 0.732687 29.67281 1.795902-26.647917-122.810047-159.358451-214.077703-310.826188-214.077703-169.353083 0-308.085774 114.232694-308.085774 259.274068 0 83.708494 46.165436 152.460344 123.281791 205.78483l-30.80868 91.730191 107.688651-53.455469c38.558178 7.53665 69.459978 15.308661 107.924012 15.308661 9.66308 0 19.230993-0.470721 28.752858-1.225921-6.025227-20.36584-9.521864-41.723264-9.521864-63.862493C402.328693 476.632491 517.908058 368.541681 664.250054 368.541681zM498.62897 285.87389c23.200398 0 38.557154 15.120372 38.557154 38.061874 0 22.846334-15.356756 38.156018-38.557154 38.156018-23.107277 0-46.260603-15.309684-46.260603-38.156018C452.368366 300.994262 475.522716 285.87389 498.62897 285.87389zM283.016307 362.090758c-23.107277 0-46.402843-15.309684-46.402843-38.156018 0-22.941502 23.295566-38.061874 46.402843-38.061874 23.081695 0 38.46301 15.120372 38.46301 38.061874C321.479317 346.782098 306.098002 362.090758 283.016307 362.090758zM945.448458 606.151333c0-121.888048-123.258255-221.236753-261.683954-221.236753-146.57838 0-262.015505 99.348706-262.015505 221.236753 0 122.06508 115.437126 221.200938 262.015505 221.200938 30.66644 0 61.617359-7.609305 92.423993-15.262612l84.513836 45.786813-23.178909-76.17082C899.379213 735.776599 945.448458 674.90216 945.448458 606.151333zM598.803483 567.994292c-15.332197 0-30.807656-15.096836-30.807656-30.501688 0-15.190981 15.47546-30.477129 30.807656-30.477129 23.295566 0 38.558178 15.286148 38.558178 30.477129C637.361661 552.897456 622.099049 567.994292 598.803483 567.994292zM768.25071 567.994292c-15.213493 0-30.594809-15.096836-30.594809-30.501688 0-15.190981 15.381315-30.477129 30.594809-30.477129 23.107277 0 38.558178 15.286148 38.558178 30.477129C806.808888 552.897456 791.357987 567.994292 768.25071 567.994292z" fill="#FFFFFF" p-id="5712"></path></svg>''',
                    width: 28,
                    height: 28,
                  ),
                  label: const Text("微信"))
            ],
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                  onPressed: () async {
                    const url = 'https://space.bilibili.com/384556554';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  icon: SvgPicture.string(
                    '''<svg t="1711843958793" class="icon" viewBox="0 0 2241 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="12269" width="32" height="32"><path d="M626.875 734.993c-32.227-24.43-68.613-41.584-106.038-56.658-76.41-30.148-156.46-41.064-238.067-38.985-19.233 0-38.465 1.56-58.218 2.6 0-1.56-1.56-3.64-1.56-6.238-5.197-58.218-11.435-116.435-15.593-173.613-3.639-47.82-5.198-95.642-6.238-143.463-1.559-92.005-1.559-183.489-1.559-275.493 0-21.831-1.56-19.232-18.193-11.955C129.95 51.98 79.01 72.252 27.55 92.004c-1.56 1.56-4.158 6.757-3.119 9.356 15.594 58.218 27.03 117.994 34.827 177.251 7.797 51.46 14.554 101.36 21.831 151.78 6.238 44.184 10.396 88.366 15.594 133.069 5.198 45.222 11.436 90.445 16.634 136.187 5.198 43.663 10.396 85.766 15.594 129.43 3.638 31.187 6.757 61.855 9.356 93.043 1.56 24.43 3.639 48.86 4.158 72.252 0 5.198 1.56 7.797 6.758 7.797 11.435 0 21.831 1.559 32.747 0 53.02-5.198 106.039-8.837 158.018-16.634 40.025-6.238 79.01-15.594 117.474-28.589 54.579-18.193 101.36-49.38 146.583-85.247 19.233-14.554 34.826-32.227 41.584-54.578 14.554-36.906 8.317-61.856-18.713-82.128zM327.472 908.085c-7.797-58.217-15.594-114.875-23.39-171.013 30.147 6.757 156.978 57.178 163.215 64.975-46.261 34.826-92.004 70.172-139.825 106.038z m605.044-145.023c-2.6-30.148-5.198-61.856-8.837-92.004-3.638-41.584-7.797-83.168-11.435-125.271-3.639-38.465-5.198-76.41-7.797-114.875-3.639-53.02-7.797-106.039-11.436-159.058l-7.797-117.474c-1.04-14.555-6.757-18.193-21.831-17.154-18.193 1.56-35.866 2.6-54.06 3.639-15.593 1.56-31.187 3.639-46.261 5.198 46.782 248.463 67.574 497.446 92.004 744.35 28.589 2.598 54.579 4.158 81.608 6.757 5.198 1.04 7.797 0 7.797-5.198l-2.599-28.59c-2.08-34.306-5.718-67.573-9.356-100.32zM790.09 794.25c-3.638-31.188-6.757-61.856-10.396-93.044-3.638-35.346-6.757-71.212-11.435-106.558-2.6-21.832-6.238-42.624-9.356-63.416-1.04-7.796-6.238-11.435-14.555-10.395-14.554 1.559-30.148 1.559-45.222 3.638-20.792 2.6-41.584 6.238-63.415 8.837a46036.03 46036.03 0 0 0 79.009 402.842c31.188-4.158 60.816-7.797 90.964-11.435-1.04-10.396-2.599-20.792-3.638-30.148-4.159-34.307-8.317-67.574-11.956-100.321z m310.839 138.786c-1.04-51.46-2.599-101.36-3.639-152.82-1.04-63.416 0-127.87 0-191.286 0-14.035-1.04-27.03-1.559-41.064 0-6.238-3.639-11.436-10.396-11.436a2135.975 2135.975 0 0 0-81.608-1.559c-10.396 0-19.752 1.56-30.148 3.639 1.04 3.638 1.04 6.237 1.04 8.836 3.638 43.663 7.796 86.806 11.435 129.43 3.638 41.583 7.797 84.207 11.435 125.79 4.159 45.223 7.797 90.445 11.956 135.668 0 2.598 4.158 6.757 6.757 6.757 27.55 1.04 56.658 0 85.767 0-1.04-5.718-1.04-9.356-1.04-11.955z m-350.863-462.1c-5.198-49.38-9.356-96.162-14.035-143.984-1.04-6.237-3.638-9.356-8.836-9.356-16.634 0-33.787 0-51.46 1.04 6.757 53.019 12.995 103.959 19.752 156.458 19.233-1.559 36.386-2.079 54.579-4.158z m343.066 7.797V346.705c0-9.357-3.639-11.956-11.436-11.956h-45.222v151.78c19.752 1.04 38.465 1.56 56.658 2.6v-10.396z m-419.476-1.56v-10.395c-2.6-27.03-6.238-53.02-8.837-80.05-1.56-17.152-3.638-33.786-5.198-51.459-1.04-4.158 1.04-10.396-6.237-9.356-16.634 1.56-32.747 5.198-49.38 6.757 9.355 51.46 18.192 101.36 27.548 151.78l42.104-7.276z m344.105 8.837v-79.009c0-20.792-1.04-42.623 0-63.415 0-7.797-2.599-9.357-9.356-9.357h-46.262c4.159 54.06 7.797 105 11.955 155.42 14.035-1.04 28.07-2.08 43.663-3.639z m711.083 248.983c-32.228-24.43-68.614-41.584-106.039-56.658-76.41-30.148-156.459-41.064-238.067-38.985-19.232 0-38.465 1.56-58.217 2.6 0-1.56-1.56-3.64-1.56-6.238-5.198-58.218-11.435-116.435-15.593-173.613-3.64-47.82-5.198-95.642-6.238-143.463-1.56-92.005-1.56-183.489-1.56-275.493 0-21.831-1.559-19.232-18.192-11.955-51.46 20.792-102.4 41.064-153.86 60.816-1.56 1.04-4.159 6.238-3.639 8.837 15.594 58.217 27.03 117.994 34.827 177.25 7.797 51.46 14.554 101.36 21.831 151.781 6.238 44.183 10.396 88.366 15.594 133.068 5.198 45.222 11.436 90.445 16.633 136.187 5.198 43.663 10.396 85.766 15.594 129.43 3.639 31.187 6.758 61.855 9.357 93.043 1.56 24.43 3.638 48.86 4.158 72.252 0 5.198 1.56 7.797 6.757 7.797 11.436 0 21.832 1.56 32.748 0 53.019-5.198 106.038-8.837 158.018-16.634 40.024-6.237 79.01-15.594 117.474-28.589 54.579-18.192 101.36-49.38 146.583-85.246 19.232-14.555 34.826-32.228 41.584-54.579 15.074-36.386 8.836-61.336-18.193-81.608z m-299.403 173.092c-7.797-58.217-15.594-114.875-23.391-171.013 30.148 6.757 156.978 57.178 163.216 64.975-46.262 34.826-92.004 70.172-139.825 106.038z m605.043-145.023c-2.599-30.148-5.198-61.856-8.836-92.004-3.639-41.584-7.797-83.168-11.436-125.271-3.638-38.465-5.198-76.41-7.797-114.875-3.638-53.02-7.797-106.039-11.435-159.058l-7.797-117.474c-1.04-14.555-6.758-18.193-21.832-17.154-18.193 1.56-35.866 2.6-54.059 3.639-15.594 1.56-31.187 3.639-46.262 5.198 46.782 248.463 67.574 497.446 92.005 744.35 28.588 2.598 54.578 4.158 81.608 6.757 5.198 1.04 7.797 0 7.797-5.198l-2.6-28.59c-2.079-34.306-5.717-67.573-9.356-100.32zM1892.06 794.25c-3.639-31.188-6.757-61.856-10.396-93.044-3.639-35.346-6.757-71.212-11.436-106.558-2.599-21.832-6.237-42.624-9.356-63.416-1.04-7.796-6.237-11.435-14.554-10.395-14.555 1.559-30.148 1.559-45.223 3.638-20.791 2.6-41.583 6.238-63.415 8.837a46036.03 46036.03 0 0 0 79.01 402.842c31.187-4.158 60.816-7.797 90.964-11.435-1.04-10.396-2.6-20.792-3.639-30.148-4.158-34.307-8.317-67.574-11.955-100.321z m310.838 138.786c-1.04-51.46-2.598-101.36-3.638-152.82-1.04-63.416 0-127.87 0-191.286 0-14.035-1.04-27.03-1.56-41.064 0-6.238-3.638-11.436-10.395-11.436-27.03-1.04-54.58-1.559-81.609-1.559-10.395 0-19.752 1.56-30.148 3.639 1.04 3.638 1.04 6.237 1.04 8.836 3.638 43.663 7.797 86.806 11.435 129.43 3.639 41.583 7.797 84.207 11.436 125.79 4.158 45.223 7.797 90.445 11.955 135.668 0 2.598 4.159 6.757 6.758 6.757 27.549 1.04 56.657 0 85.766 0-1.04-5.718-1.04-9.356-1.04-11.955z m-350.862-462.1c-5.198-49.38-9.357-96.162-14.035-143.984-1.04-6.237-3.639-9.356-8.837-9.356-16.633 0-33.786 0-51.46 1.04 6.758 53.019 12.996 103.959 19.753 156.458 19.232-1.559 36.386-2.079 54.579-4.158z m343.066 7.797V346.705c0-9.357-3.639-11.956-11.436-11.956h-45.222v151.78c19.752 1.04 38.465 1.56 56.658 2.6v-10.396z m-419.477-1.56v-10.395c-2.599-27.03-6.237-53.02-8.836-80.05-1.56-17.152-3.639-33.786-5.198-51.459-1.04-4.158 1.04-10.396-6.238-9.356-16.633 1.56-32.747 5.198-49.38 6.757 9.356 51.46 18.192 101.36 27.549 151.78l42.103-7.276z m344.106 8.837v-79.009c0-20.792-1.04-42.623 0-63.415 0-7.797-2.599-9.357-9.356-9.357h-46.262c4.158 54.06 7.797 105 11.955 155.42 14.035-1.04 28.07-2.08 43.663-3.639z m0 0" fill="#FFFFFF" p-id="12270"></path></svg>''',
                    width: 14,
                    height: 14,
                  ),
                  label: const Text("哔哩哔哩")),
              const SizedBox(width: 4.0),
              FilledButton.icon(
                  onPressed: () async {
                    const url = 'https://t.me/paditianxiu';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  icon: SvgPicture.string(
                    '''<svg t="1711843996907" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="13404" width="32" height="32"><path d="M834.24 127.872a95.168 95.168 0 0 0-29.856 7.136h-0.128c-9.12 3.616-52.48 21.856-118.4 49.504l-236.224 99.488c-169.504 71.36-336.128 141.632-336.128 141.632l1.984-0.768s-11.488 3.776-23.488 12a64.96 64.96 0 0 0-18.752 18.144c-5.888 8.64-10.624 21.856-8.864 35.52 2.88 23.104 17.856 36.96 28.608 44.608 10.88 7.744 21.248 11.36 21.248 11.36h0.256l156.256 52.64c7.008 22.496 47.616 156 57.376 186.752 5.76 18.368 11.36 29.856 18.368 38.624 3.392 4.48 7.36 8.224 12.128 11.232a35.808 35.808 0 0 0 7.872 3.392l-1.6-0.384c0.48 0.128 0.864 0.512 1.216 0.64 1.28 0.352 2.144 0.48 3.776 0.736 24.736 7.488 44.608-7.872 44.608-7.872l1.12-0.896 92.256-84 154.624 118.624 3.52 1.504c32.224 14.144 64.864 6.272 82.112-7.616 17.376-13.984 24.128-31.872 24.128-31.872l1.12-2.88 119.488-612.128c3.392-15.104 4.256-29.248 0.512-42.976a57.824 57.824 0 0 0-24.992-33.504 59.904 59.904 0 0 0-34.144-8.64z m-3.232 65.6c-0.128 2.016 0.256 1.792-0.64 5.664v0.352l-118.368 605.76c-0.512 0.864-1.376 2.752-3.744 4.64-2.496 1.984-4.48 3.232-14.88-0.896l-189.12-144.992-114.24 104.128 24-153.28 308.992-288c12.736-11.84 8.48-14.336 8.48-14.336 0.896-14.528-19.232-4.256-19.232-4.256l-389.632 241.376-0.128-0.64-186.752-62.88v-0.128l-0.48-0.096a8.64 8.64 0 0 0 0.96-0.384l1.024-0.512 0.992-0.352s166.752-70.272 336.256-141.632c84.864-35.744 170.368-71.744 236.128-99.52 65.76-27.616 114.368-47.872 117.12-48.96 2.624-1.024 1.376-1.024 3.264-1.024z" p-id="13405" fill="#FFFFFF"></path></svg>''',
                    width: 28,
                    height: 28,
                  ),
                  label: const Text("Telegram"))
            ],
          ),
          const Divider(),
          ListBody(children: [
            ListTile(
              onTap: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('捐赠'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            const Text(
                              '如果收款人不是*浩，昵称不是帕帝，请勿捐赠，软件可能被人修改，加群获取最新版.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Center(
                                child: Column(
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child:
                                      Image.asset('assets/images/wechat.png'),
                                ),
                                const Divider(),
                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child:
                                      Image.asset('assets/images/alipay.png'),
                                ),
                              ],
                            ))
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
              },
              title: const Text("我要捐赠"),
              leading: const Icon(Icons.coffee_outlined),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const FavoritePage();
                }));
              },
              title: const Text("我的收藏"),
              leading: const Icon(Icons.favorite_border),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const HistroyPage();
                }));
              },
              title: const Text("观看历史"),
              leading: const Icon(Icons.history),
            ),
            ListTile(
              onTap: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('特别鸣谢(排名不分前后)'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            buildThanksView("Tom", "2246921312"),
                            buildThanksView("a'ゞゞName debug", "1652965610"),
                            buildThanksView("川意", "3299699002"),
                            buildThanksView("桜", "2576206327"),
                            buildThanksView("学业繁忙，请勿打扰", "2116996207"),
                            buildThanksView("噬心", "1602965165"),
                            buildThanksView("一碗椰子粥", "295502133"),
                            buildThanksView("月下鱼猫", "2830430757"),
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
              },
              title: const Text("特别鸣谢"),
              leading: const Icon(Icons.card_giftcard_outlined),
            ),
            ListTile(
              onTap: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('免责声明'),
                      content: const SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                                '''1:本软件是第三方自定义搜索工具，仅供学习参考。本软件不存储视频，请在下载后24小时内删除。

2:软件以非人工的方式索引内容，任何通过软件搜索链接到第三方网页均系他人制作或提供，您可以从第三方网页上获得相关服务，我们对于您搜索到的网页及其内容不承担任何法律责任。

3:本软件所有可搜索到的内容均来自各网站提供的公开引用资源，所有图片及视频版权归原作者及网站所有，本软件不存储、不制作、不上传。

4:任何单位或个人通过搜索链接到的第三方网页内容可能涉嫌侵权，请向本APP发送邮件告知，在收到邮件后将会尽快断开相关搜索链接内容。'''),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('我知道了'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              title: const Text("免责申明"),
              leading: const Icon(Icons.error_outline),
            ),
          ])
        ],
      )),
    );
  }
}

buildThanksView(String name, String qq) {
  return ListTile(
      onTap: () async {
        var url =
            'mqqapi://card/show_pslcard?src_type=internal&source=sharecard&version=1&uin=$qq';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      title: Text(name),
      leading: Card.outlined(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: SizedBox(
            width: 40,
            height: 40,
            child: CachedNetworkImage(
                imageUrl: "https://q2.qlogo.cn/headimg_dl?dst_uin=$qq&spec=100",
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error),
                    )),
          ),
        ),
      ));
}
