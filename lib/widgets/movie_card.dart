import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String label;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
    this.label = '',
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Card.outlined(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        httpHeaders: const {
                           'Referer': 'https://movie.douban.com/',
                          'User-Agent':
                              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36 Edg/154.0.0.0'
                        },
                        width: double.infinity,
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Tooltip(
                        message: title,
                        child: Text(
                          title,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                if (label.isNotEmpty)
                  Positioned(
                    left: 0,
                    top: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(95),
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(50),
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        label,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
