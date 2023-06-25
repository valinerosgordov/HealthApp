import 'package:flutter/material.dart';
import 'package:health_app/core/my_colors.dart';
import 'package:health_app/domain/data/become_data.dart';
import 'package:get/get.dart';

class BecomeList extends StatefulWidget {
  const BecomeList(this.list, {Key? key}) : super(key: key);

  final List<BecomeData> list;

  @override
  _BecomeListState createState() => _BecomeListState();
}

class _BecomeListState extends State<BecomeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_outlined,
            color: MyColors.green_016938,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            ...widget.list
                .map(
                  (e) => ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            e.whom,
                            style: TextStyle(
                                fontSize: 14, color: MyColors.black_4A5568),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        e.status ?? false ? Icon(
                          Icons.check_box,
                          color: MyColors.green_4CAD79,
                        ) : Icon(
                          Icons.check_box_outline_blank,
                          color: MyColors.grey_939393,
                        )
                      ],
                    ),
                    selected: true,
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }
}
