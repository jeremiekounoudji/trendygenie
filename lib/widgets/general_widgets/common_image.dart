import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/shimmer.dart';

class CommonImageWidget extends StatefulWidget {
  const CommonImageWidget(
      {super.key,
       this.loadingWidget,
       this.errorWidget,
      required this.isLocalImage,
      this.localImagePath,
      this.onlineImagePath,
      required this.rounded,
       this.height,
       this.width});
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final bool isLocalImage;
  final String? localImagePath;
  final String? onlineImagePath;
  final double rounded;
  final double? height;
  final double? width;

  @override
  State<CommonImageWidget> createState() => _CommonImageWidgetState();
}

class _CommonImageWidgetState extends State<CommonImageWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.rounded),
        child: widget.isLocalImage
            ? Image.asset(
                widget.localImagePath!,
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                imageUrl: widget.onlineImagePath!,
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => widget.loadingWidget ?? const LoadingShimmer(h: 100, w: 100),
                errorWidget: (context, url, error) => widget.errorWidget ?? Container(
                  color: firstColor.withOpacity(0.1),
                ),
              ),
      ),
    );
  }
}
