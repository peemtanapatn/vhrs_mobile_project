import 'package:flutter/material.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;

class NetworkImageShow extends StatelessWidget {
  const NetworkImageShow({
    Key? key,
    required this.imageName,
    this.radius = 0.0,
    this.fit = BoxFit.cover,
    this.width = 100,
    this.height = 100,
  }) : super(key: key);

  final String imageName;
  final double radius;
  final double width;
  final double height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    String path = '${service.serverPath}/VHRSservice/uploads/';
    return Image.network(
      path + imageName,
      fit: fit,
      width: width,
      height: height,
      filterQuality: FilterQuality.low,
      loadingBuilder: ((context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );

    // CachedNetworkImage(
    //   imageUrl: path + imageName,
    //   width: double.infinity,
    //   imageBuilder: (context, imageProvider) => ClipRRect(
    //     borderRadius: BorderRadius.circular(radius),
    //     child: Container(
    //       color: Colors.grey.shade200,
    //       child: Image(
    //         image: imageProvider,
    //         fit: fit,
    //         width: width,
    //         height: height,
    //         filterQuality: FilterQuality.low,
    //       ),
    //     ),
    //   ),
    //   placeholder: (context, url) => placeholder(),
    //   errorWidget: (context, url, error) => errorWidget(),
    // );
  }

  Widget placeholder() {
    return const Center(
      child: SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
            strokeWidth: 2, color: Color.fromARGB(255, 8, 28, 138)),
      ),
    );
  }

  Widget errorWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: const Icon(
        Icons.error,
      ),
    );
  }
}
