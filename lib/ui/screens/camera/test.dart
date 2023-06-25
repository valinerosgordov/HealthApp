import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app/core/my_colors.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:health_app/domain/data/health_data.dart';
import 'package:health_app/other/delayed_action.dart';
import 'package:health_app/other/other.dart';
import 'package:health_app/ui/screens/camera/snapping_list_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_html_all/flutter_html_all.dart';

class DetailHeath extends StatefulWidget {
  const DetailHeath(this.item, {Key? key}) : super(key: key);

  final HealthData item;

  @override
  State<DetailHeath> createState() => _DetailHeathState();
}

class _DetailHeathState extends State<DetailHeath> {
  var unescape = HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_outlined,
            color: MyColors.green_016938,
          ),
        ),
        actions: [
          widget.item.button != null ? GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              DelayedAction.run(() {
                launchInVC(Uri.parse(widget.item.site));
              });
            },
            child: Center(
              child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: MyColors.green_36B448,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.item.button!,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ) : const SizedBox(),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.item.photos != null && widget.item.photos!.isNotEmpty
                  ? SizedBox(
                      height: Get.width - (24 * 2),
                      child: SnappingListView(
                        paddingListView: const EdgeInsets.only(right: 24),
                        //controller: _controller,
                        scrollPhysics: SnappingListScrollPhysics(
                          itemExtent: Get.width - (24 * 2),
                        ),
                        itemExtent: Get.width - (24 * 2),
                        children: widget.item.photos!
                            .map(
                              (photo) => Padding(
                                padding: const EdgeInsets.only(left: 24),
                                child: Container(
                                  height: Get.width - (24 * 2),
                                  key: UniqueKey(),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: MyColors.grey_CBD5E0),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: photo,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.topCenter),
                                      ),
                                    ),
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.qr_code),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )
                  : Center(
                      child: SizedBox(
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            border: Border.all(color: MyColors.grey_CBD5E0),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.network(
                            widget.item.photo,
                            fit: BoxFit.cover,
                            width: Get.width - (24 * 2),
                            height: Get.width - (24 * 2),
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.item.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Html(
                data: widget.item.info,
                style: {
                  "html": Style(
                    padding: HtmlPaddings.zero,
                    margin: Margins.zero,
                  ),
                  "table": Style(
                    backgroundColor:
                        const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                  ),
                  "th": Style(
                    padding: HtmlPaddings.all(6),
                    backgroundColor: Colors.grey.withOpacity(.3),
                    textAlign: TextAlign.left,
                    verticalAlign: VerticalAlign.middle,
                  ),
                  "td": Style(
                    padding: HtmlPaddings.all(6),
                    border: const Border(
                      bottom: BorderSide(color: Colors.grey),
                    ),
                    textAlign: TextAlign.left,
                    verticalAlign: VerticalAlign.middle,
                  ),
                },
                extensions: [
                  TagWrapExtension(
                    tagsToWrap: {"table"},
                    builder: (child) {
                      return child;
                    },
                  ),
                  const TableHtmlExtension(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
