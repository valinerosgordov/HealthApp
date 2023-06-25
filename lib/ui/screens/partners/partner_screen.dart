import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:health_app/controllers/rate_controller.dart';
import 'package:health_app/controllers/user_controller.dart';
import 'package:health_app/core/my_colors.dart';
import 'package:health_app/domain/data/partner_data.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:health_app/domain/data/user_data.dart';
import 'package:health_app/other/delayed_action.dart';
import 'package:health_app/other/other.dart';
import 'package:rate/rate.dart';

class PartnerScreen extends StatefulWidget {
  final PartnerData data;

  PartnerScreen({required this.data});

  @override
  State<StatefulWidget> createState() => PartnerScreenState();
}

class PartnerScreenState extends State<PartnerScreen> {
  final RateController _rateController = Get.find();
  final UserController _userController = Get.find();
  late ScrollController _scrollController;
  ValueNotifier<List<double>> rateNotifier = ValueNotifier([0]);
  ValueNotifier<bool?> isDisableNotifier = ValueNotifier(null);
  double newRate = 0;

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (Get.height / 1.9 - kToolbarHeight);
  }

  Color _textColor = MyColors.green_016938;

  final TextEditingController letterText = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _textColor =
              _isSliverAppBarExpanded ? Colors.black : MyColors.green_016938;
        });
      });

    super.initState();
    _rateController.getPartnerRate(
      widget.data.id,
      _userController.user.value!.id,
    );
    _rateController.getPartnerLetters(
      widget.data.id,
      _userController.user.value!.id,
    );
    ever(_rateController.voteList, (List<VoteData>? value) {
      if (value != null && value.isNotEmpty) {
        rateNotifier.value = value.map((e) => e.rate.toDouble()).toList();
      } else {
        rateNotifier.value = [0];
      }
    });
    _rateController.isDisable.listen((bool? p0) {
      if (p0 != null) {
        isDisableNotifier.value = p0;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.grey_E7EEE7,
      body: CustomScrollView(
        controller: _scrollController,
        // controller: _listController,
        slivers: [
          SliverAppBar(
            toolbarHeight: Get.width * 0.15,
            backgroundColor: MyColors.grey_E7EEE7,
            automaticallyImplyLeading: false,
            expandedHeight: Get.height / 1.85,
            pinned: true,
            snap: true,
            floating: true,
            elevation: 0,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        _userController.setPartnerLike(
                          partnerId: widget.data.id,
                        );
                      },
                      child: Obx(
                        () => SvgPicture.asset(
                          'images/favorite.svg',
                          color: _userController.user.value!.partnersLikes
                                  .contains(widget.data.id)
                              ? MyColors.green_016938
                              : Colors.white,
                          width: Get.width * 0.07,
                          height: Get.width * 0.07,
                        ),
                      )),
                  SizedBox(
                    width: Get.width * 0.05,
                  )
                ],
              )
            ],
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios_outlined,
                color: MyColors.green_016938,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1.3,
              collapseMode: CollapseMode.pin,
              titlePadding: EdgeInsets.only(
                bottom: Get.width * 0.025,
              ),
              centerTitle: true,
              title: null,
              background: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: buildLogo(),
                  ),
                  SizedBox(
                    height: Get.width * 0.05,
                  ),
                  //buildBody(),
                  SizedBox(
                    height: Get.width * 0.05,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              // controller: _listController,
              clipBehavior: Clip.none,
              padding: EdgeInsets.only(bottom: 0),
              child: Column(
                children: [
                  buildBody(),
                  SizedBox(height: Get.width * 0.05),
                  buildDescription(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDescription() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.05, vertical: Get.width * 0.05),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: 1,
                blurRadius: 5,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.data.description}',
                style: TextStyle(fontSize: 18),
              ),
              buildLinks(),
              const SizedBox(height: 32),
              Text(
                "Отзывы:",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Obx(
                () {
                  return _rateController.lettersList.value?.isEmpty ??
                          [].isEmpty &&
                              (_rateController.lettersList.value
                                          ?.where((l) => l.isVisible)
                                          .toList()
                                          .length ??
                                      0) < 1

                      ? RichText(
                          text: TextSpan(
                            text: "Пользователи еще не оставили отзывы\n",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'оставить отзыв?',
                                style: TextStyle(color: MyColors.grey_939393),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () => addLetter(),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._rateController.lettersList.value!
                                .where((l) => l.isVisible)
                                .map((e) => _singleLetter(e))
                                .toList(),
                            _rateController.isVisible.value!
                                ? const Text(
                                    "Если вы не видете свой отзыв, возможно он еще не прошел модерацию.",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 16),
                                      RichText(
                                        text: TextSpan(
                                          text: "Вы еще не оставили отзыв ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'оставить?',
                                              style: TextStyle(
                                                  color: MyColors.grey_939393),
                                              recognizer:
                                                  new TapGestureRecognizer()
                                                    ..onTap = () => addLetter(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Text(
          widget.data.name,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
        _rateWidget(),
      ],
    );
  }

  Widget buildLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          child: SvgPicture.asset(
            'images/partner_fon.svg',
            width: Get.width / 1.5,
            height: 400,
          ),
        ),
        Positioned(
          bottom: 30,
          child: Container(
            width: Get.width,
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: MyColors.grey_C6C6C6,
              radius: 110,
              foregroundImage: CachedNetworkImageProvider(widget.data.photo),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: SafeArea(
            child: Container(
              clipBehavior: Clip.hardEdge,
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.data.code ?? "",
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.qr_code),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHeader() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [],
          ),
        ),
      ],
    );
  }

  Widget buildLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            try {
              launchInVC(Uri.parse(widget.data.site));
            } catch (e) {
              Get.snackbar("Ошибка", "Ссылка недоступна");
            }
          },
          child: Visibility(
            visible: widget.data.site.isNotEmpty &&
                widget.data.site.contains('http'),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: 10, left: 1),
              height: 40,
              decoration: BoxDecoration(
                  color: MyColors.green_016938,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/site_icon.png',
                    width: 40,
                  ),
                  SizedBox(
                    width: Get.width * 0.025,
                  ),
                  Container(
                    width: 70,
                    child: Text(
                      '${widget.data.site}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            try {
              launchInVC(Uri.parse(widget.data.appUri));
              // Get.to(WebScreen(url: widget.data.appUri));
            } catch (e) {
              Get.snackbar("Ошибка", "Ссылка недоступна");
            }
          },
          child: Visibility(
            visible: widget.data.appUri.isNotEmpty &&
                widget.data.appUri.contains('http'),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: 10, left: 1),
              height: 40,
              decoration: BoxDecoration(
                  color: MyColors.green_016938,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/app_site_icon.png',
                    width: 40,
                  ),
                  SizedBox(
                    width: Get.width * 0.025,
                  ),
                  Container(
                    width: 70,
                    child: Text(
                      '${widget.data.appUri}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  double arithmeticMean(List<double> array) {
    double sum = array.reduce((double sum, double el) => sum + el);
    return sum / array.length;
  }

  Widget _rateWidget() => ValueListenableBuilder(
        valueListenable: rateNotifier,
        builder: (context, List<double> rates, child) {
          double _rate = arithmeticMean(rates);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _rate > 0 ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 32,
                    color: MyColors.green_4CAD79,
                  ),
                  Icon(
                    _rate > 1 ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 32,
                    color: MyColors.green_4CAD79,
                  ),
                  Icon(
                    _rate > 2 ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 32,
                    color: MyColors.green_4CAD79,
                  ),
                  Icon(
                    _rate > 3 ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 32,
                    color: MyColors.green_4CAD79,
                  ),
                  Icon(
                    _rate > 4 ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 32,
                    color: MyColors.green_4CAD79,
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      _rate.toString(),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Obx(() {
                return _rateController.voteList.value!
                        .where((v) => v.uid == _userController.user.value!.id)
                        .toList()
                        .isEmpty
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _showAlertDialog(context);
                        },
                        child: Text("Поставить оценку?"),
                      )
                    : const SizedBox();
              })
            ],
          );
        },
      );

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Оцените'),
        content: Center(
          child: Rate(
            iconSize: 40,
            color: MyColors.green_4CAD79,
            allowHalf: false,
            allowClear: true,
            initialValue: 5,
            readOnly: false,
            onChange: (value) => newRate = value,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              _rateController
                  .setPartnerRate(
                      widget.data.id, _userController.user.value!.id, newRate)
                  .then((value) => Navigator.of(context).pop());
            },
            child: Text('Отправить'),
          ),
        ],
      ),
    );
  }

  void addLetter() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Material(
        color: Colors.transparent,
        child: Container(
          height: 300,
          padding: const EdgeInsets.only(top: 6.0),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Text(
                "Хотите оставить отзыв о \"${widget.data.name}\"?",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  height: 24 / 18,
                  color: MyColors.green_016938,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _wrap(
                        TextFormField(
                          style: TextStyle(
                            fontSize: 16,
                            color: MyColors.green_016938,
                            fontWeight: FontWeight.w700,
                          ),
                          controller: letterText,
                          decoration: InputDecoration(
                            hintText: 'Введите текст',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: MyColors.green_4CAD79),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: MyColors.green_4CAD79),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: MyColors.green_4CAD79),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Укажите ваше имя';
                            }
                          },
                          maxLines: 3,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          DelayedAction.run(() {
                            if (_formKey.currentState!.validate()) {
                              _rateController
                                  .setLetterPartner(<String, String>{
                                "id": widget.data.id,
                                "uid": _userController.user.value!.id,
                                "text": letterText.text,
                              }).then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Отзыв отправлен!')),
                                );
                                Navigator.pop(context);
                              });
                            }
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              color: MyColors.green_4CAD79,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          child: Center(
                            child: Text(
                              "Отправить",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wrap(Widget textFormField) => Column(
        children: [
          textFormField,
          const SizedBox(height: 16),
        ],
      );

  Widget _singleLetter(LetterData letter) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            const SizedBox(height: 8),
            FutureBuilder<UserData?>(
                future: _userController.getUserById(letter.uid),
                builder: (_, AsyncSnapshot<UserData?> snapshot) {
                  return Text(
                    snapshot.hasData
                        ? "${snapshot.data?.name} ${snapshot.data?.soname.substring(0, 1)}"
                        : "Аноним",
                    style: TextStyle(
                      fontSize: 12,
                      color: MyColors.grey_939393,
                    ),
                  );
                }),
            const SizedBox(height: 8),
            Text(
              letter.text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
}
