import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/controllers/become_visible_controller.dart';
import 'package:health_app/controllers/partners_controller.dart';
import 'package:health_app/controllers/rate_controller.dart';
import 'package:health_app/core/my_colors.dart';
import 'package:get/get.dart';
import 'package:health_app/domain/data/partner_data.dart';
import 'package:health_app/domain/data/point_data.dart';
import 'package:health_app/ui/screens/partners/become_partner.dart';
import 'package:health_app/ui/screens/partners/partner_item.dart';
import 'package:health_app/ui/screens/partners/partner_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animation_list/animation_list.dart';

class PartnersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PartnersScreenState();
}

class PartnersScreenState extends State<PartnersScreen> {
  final RateController _rateController = Get.put(RateController());
  final PartnersController _partnersController = Get.find();
  final BecomeVisibleController _becomeController = Get.find();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _listController = ScrollController();
  final PopupController _popupController = PopupController();
  late MapController _mapController;
  List<Marker> _markers = <Marker>[];
  List<PointData> geoList = <PointData>[];

  late ScrollController _scrollController;

  bool get _isSliverAppBarExpanded {
    return (_listController.hasClients &&
        _listController.offset > (Get.width * 0.2 - kToolbarHeight));
  }

  bool _sliverEx = false;

  final Key you = Key("you");

  drawRoad() async {}

  @override
  void initState() {
    _becomeController.initCountStream();
    _partnersController.updatePartnersList();
    _partnersController.getUserPosition();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listController.addListener(() {
        setState(() {
          _sliverEx = _isSliverAppBarExpanded;
        });
      });
      //  _mapController = MapController();
    });

    _partnersController.onMap.listen((p0) {
      if (p0) {
        _partnersController.getMapList();
      } else {
        _partnersController.updatePartnersList();
        _listController.addListener(() async {
          print('LISTEN');
          if (_listController.offset >=
                  _listController.position.maxScrollExtent &&
              !_listController.position.outOfRange) {
            print('in end');
            if (_partnersController.partnersList.value != null &&
                _partnersController.documentList.length % 10 == 0) {
              print(
                  'in listener ${_partnersController.partnersList.value!.length}');
              _partnersController.getNextPage();
            } else {
              // _commentController.showLoader.value = false;
            }
          }
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.grey_E7EEE7,
      body: Stack(
        children: [
          SvgPicture.asset(
            'images/health_fon.svg',
            fit: BoxFit.fill,
          ),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return CustomScrollView(controller: _listController, slivers: [
      SliverAppBar(
        shadowColor: Colors.transparent,
        titleSpacing: 0,
        //title: const SizedBox()
        // ,
        leading: Visibility(
          visible: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _partnersController.onMap.value =
                      !_partnersController.onMap.value;
                },
                child: Obx(
                  () => Container(
                    margin: EdgeInsets.only(left: 24),
                    width: 42,
                    height: 42,
                    child: Center(
                      child: _partnersController.onMap.value
                          ? Padding(
                              padding: EdgeInsets.all(5),
                              child: SvgPicture.asset(
                                'images/list_item.svg',
                                width: 14,
                              ),
                            )
                          : Icon(
                              Icons.location_pin,
                              color: Colors.white,
                            ),
                    ),
                    decoration: BoxDecoration(
                      color: MyColors.green_016938,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 100,
        toolbarHeight: Get.width * 0.2,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        expandedHeight: Get.width * 0.4,
        pinned: true,
        actions: [
          Obx(
            () => Visibility(
              visible: _becomeController.userCount.value != null && _becomeController.userCount.value! == 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(BecomePartner());
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 24),
                      width: 42,
                      height: 42,
                      child: Center(
                        child: Text(
                          "+",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 28,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.green_016938,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        title: Visibility(
          visible: !_sliverEx,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 24),
                //width:300,
                // margin: EdgeInsets.only(left: 25),

                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                child: Text(
                  "Партнёры",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                decoration: BoxDecoration(
                    color: MyColors.green_016938,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ],
          ),
        ),

        //centerTitle: true,
        snap: false,
        floating: true,
        elevation: 1,
        flexibleSpace: FlexibleSpaceBar(
          // centerTitle: true,
          collapseMode: CollapseMode.parallax,
          titlePadding: EdgeInsets.only(
              left: Get.width * 0.05,
              right: Get.width * 0.05,
              top: Get.width * 0.05),
          title: buildSearch(),
          expandedTitleScale: 1.3,

          background: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //  buildSearch()
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Obx(() => SingleChildScrollView(
              // controller: _listController,
              clipBehavior: Clip.none,
              padding: EdgeInsets.only(bottom: 0),
              child: _partnersController.partnersList.value == null
                  ? Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        CircularProgressIndicator()
                      ],
                    )
                  : !_partnersController.onMap.value
                      ? buildPartners()
                      : Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          margin: EdgeInsets.only(top: Get.width * 0.05),
                          width: Get.width,
                          height: 440,
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              child: buildMap()),
                        ),
            )),
      )
    ]);
  }

  Widget buildPartners() {
    return Container(
      margin: EdgeInsets.only(top: Get.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.0),
      child: AnimationList(
        duration: 1000,
        reBounceDepth: 20.0,
        //scrollDirection: Axis.vertical,
        // controller: _listController,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: Get.width * 0.025, bottom: 120),
        shrinkWrap: true,
        // gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        //crossAxisCount: 2,),
        children: [
          ..._partnersController.partnersList.value!.map((data) {
            return PartnerItem(data: data);
          }).toList(),
        ],
      ),
    );
  }

  Widget buildSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: Get.width * 0.045,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          padding: EdgeInsets.zero,
          alignment: Alignment.bottomCenter,
          height: Get.width * 0.1,
          width: Get.width / 1.5,
          child: TextFormField(
            scrollPadding: EdgeInsets.symmetric(horizontal: Get.width * 0.025),
            controller: _searchController,
            onChanged: (txt) {
              _partnersController.queryValue = txt;
              _partnersController.searchPartners(
                  query: txt.replaceAll(' ', ''));
            },
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: Get.width * 0.025),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(
                Icons.search,
                color: MyColors.green_016938,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: MyColors.green_016938),
                  borderRadius: BorderRadius.circular(20)),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyColors.green_016938),
                  borderRadius: BorderRadius.circular(20)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyColors.green_016938),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
        SizedBox(
          height: Get.width * 0.05,
        )
      ],
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.04, vertical: Get.width * 0.02),
                child: Text(
                  'Партнёры',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: MyColors.green_016938,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _partnersController.onMap.value =
                      !_partnersController.onMap.value;
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.04, vertical: Get.width * 0.02),
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                      color: MyColors.green_016938, shape: BoxShape.circle),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildMap() {
    _markers = [];
    _mapController = MapController();
    if (geoList.isEmpty || _markers.isEmpty) {
      geoList = <PointData>[];
      for (PartnerData i in _partnersController.partnersList.value!) {
        for (Shop j in i.shops) {
          geoList.add(PointData(partnerData: i, lat: j.lat, lon: j.lon));
        }
      }

      _markers = geoList.map((e) {
        return Marker(
            rotate: false,
            width: Get.width * 0.1,
            height: Get.width * 0.1,
            point: LatLng(e.lat, e.lon),
            builder: (BuildContext context) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset('images/shop_logo.svg'),
                  Positioned(
                      top: Get.width * 0.02,
                      child: CircleAvatar(
                        radius: 10,
                        foregroundImage:
                            CachedNetworkImageProvider(e.partnerData.photo),
                      ))
                ],
              );
            });
      }).toList();
    }
    return Obx(() {
      if (_partnersController.userPosition.value != null) {
        _markers.add(
          Marker(
            key: you,
            point: LatLng(
              _partnersController.userPosition.value!.latitude,
              _partnersController.userPosition.value!.longitude,
            ),
            builder: (c) {
              return Icon(
                Icons.navigation,
                color: Colors.blue,
              );
            },
          ),
        );
      }

      return Stack(
        children: [
          Obx(() => FlutterMap(
                key: ValueKey("map"),
                mapController: _mapController,
                layers: [
                  TileLayerOptions(
                    minZoom: 1,
                    maxZoom: 28,
                    backgroundColor: Colors.grey.shade300,
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayerOptions(markers: _markers),
                  MarkerClusterLayerOptions(
                    popupOptions: PopupOptions(
                      popupSnap: PopupSnap.markerTop,
                      popupController: _popupController,
                      popupBuilder: (_, marker) {
                        // marker = Marker(point: point,
                        //   builder: builder);
                        return geoList
                                .where((element) =>
                                    element.lat == marker.point.latitude &&
                                    element.lon == marker.point.longitude)
                                .toList()
                                .isNotEmpty
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Get.width * 0.02,
                                          vertical: Get.width * 0.015),
                                      alignment: Alignment.center,
                                      // height: Get.width*0.25,
                                      width: Get.width * 0.5,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          shape: BoxShape.rectangle),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    _popupController
                                                        .hideAllPopups();
                                                  },
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.black,
                                                    size: 20,
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.005,
                                          ),
                                          Container(
                                            child: Text(
                                                geoList
                                                        .where((element) =>
                                                            element.lat ==
                                                                marker.point
                                                                    .latitude &&
                                                            element.lon ==
                                                                marker.point
                                                                    .longitude)
                                                        .toList()
                                                        .isNotEmpty
                                                    ? geoList
                                                        .where((element) =>
                                                            element.lat ==
                                                                marker.point
                                                                    .latitude &&
                                                            element.lon ==
                                                                marker.point
                                                                    .longitude)
                                                        .toList()
                                                        .first
                                                        .partnerData
                                                        .name
                                                    : "Вы тут",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.005,
                                          ),
                                          Container(
                                            child: Text(
                                              geoList
                                                      .where((element) =>
                                                          element.lat ==
                                                              marker.point
                                                                  .latitude &&
                                                          element.lon ==
                                                              marker.point
                                                                  .longitude)
                                                      .toList()
                                                      .isNotEmpty
                                                  ? geoList
                                                      .where((element) =>
                                                          element.lat ==
                                                              marker.point
                                                                  .latitude &&
                                                          element.lon ==
                                                              marker.point
                                                                  .longitude)
                                                      .toList()
                                                      .first
                                                      .partnerData
                                                      .description
                                                  : "",
                                              style: TextStyle(fontSize: 16),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 5,
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.005,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(PartnerScreen(
                                                  data: geoList
                                                      .where((element) =>
                                                          element.lat ==
                                                              marker.point
                                                                  .latitude &&
                                                          element.lon ==
                                                              marker.point
                                                                  .longitude)
                                                      .first
                                                      .partnerData));
                                            },
                                            child: Container(
                                              child: Text(
                                                'Подробнее',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.005,
                                          ),
                                        ],
                                      ))
                                ],
                              )
                            : const SizedBox();
                      },
                    ),
                    maxClusterRadius: 80,
                    disableClusteringAtZoom: 16,
                    size: Size(50, 50),
                    fitBoundsOptions: FitBoundsOptions(
                      padding: EdgeInsets.all(50),
                    ),
                    markers: _markers,
                    polygonOptions: PolygonOptions(
                        borderColor: Colors.blueAccent,
                        color: Colors.black12,
                        borderStrokeWidth: 3),
                    builder: (context, markers) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: MyColors.green_016938,
                            shape: BoxShape.circle),
                        child: Text(
                          '${markers.where((e) => e.key != you).toList().length}',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ],
                options: MapOptions(
                  onMapCreated: (c) {
                    _mapController = c;
                  },
                  zoom: 12,
                  maxZoom: 18,
                  minZoom: 4,
                  center: _partnersController.userPosition.value == null
                      ? LatLng(40.730610, -73.935242)
                      : LatLng(_partnersController.userPosition.value!.latitude,
                          _partnersController.userPosition.value!.longitude),
                  allowPanningOnScrollingParent: false,
                  interactiveFlags:
                      InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                  rotationThreshold: 0,
                  plugins: [
                    MarkerClusterPlugin(),
                  ],
                ),
              )),
          // Container(
          //   color: Colors.white,
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       GestureDetector(
          //           onTap: () {
          //             _mapController.moveAndRotate(
          //                 _mapController.center, _mapController.zoom + 1, 0);
          //           },
          //           child: Container(
          //               padding: EdgeInsets.all(Get.width * 0.01),
          //               child: Icon(Icons.add))),
          //       Container(
          //         color: Colors.black,
          //         height: 1,
          //         width: Get.width * 0.09,
          //       ),
          //       GestureDetector(
          //           onTap: () {
          //             //  if(_mapController.zoom>4)return;
          //             _mapController.moveAndRotate(
          //                 _mapController.center, _mapController.zoom - 1, 0);
          //           },
          //           child: Container(
          //               padding: EdgeInsets.only(
          //                   top: Get.width * 0.0,
          //                   right: Get.width * 0.01,
          //                   left: Get.width * 0.01,
          //                   bottom: Get.width * 0.03),
          //               child: Icon(Icons.minimize))),
          //     ],
          //   ),
          // )
        ],
      );
    });
  }
}
