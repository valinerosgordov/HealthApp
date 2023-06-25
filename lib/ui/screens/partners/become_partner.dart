import 'package:flutter/material.dart';
import 'package:health_app/controllers/partners_controller.dart';
import 'package:health_app/core/my_colors.dart';
import 'package:get/get.dart';

class BecomePartner extends StatefulWidget {
  const BecomePartner({Key? key}) : super(key: key);

  @override
  _BecomePartnerState createState() => _BecomePartnerState();
}

class _BecomePartnerState extends State<BecomePartner> {
  final _formKey = GlobalKey<FormState>();
  final PartnersController _partnersController = Get.find();

  final TextEditingController name = TextEditingController();
  final TextEditingController link = TextEditingController();
  final TextEditingController whom = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              const SizedBox(height: 32),
              Text(
                "Хотите стать партнером?",
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
                          controller: name,
                          decoration: InputDecoration(
                            hintText: 'Как к вам обращаться?',
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
                        ),
                      ),
                      _wrap(
                        TextFormField(
                          style: TextStyle(
                            fontSize: 16,
                            color: MyColors.green_016938,
                            fontWeight: FontWeight.w700,
                          ),
                          controller: whom,
                          decoration: InputDecoration(
                            hintText: 'Кого представляете?',
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
                              return 'Укажите название';
                            }
                          },
                        ),
                      ),
                      _wrap(
                        TextFormField(
                          style: TextStyle(
                            fontSize: 16,
                            color: MyColors.green_016938,
                            fontWeight: FontWeight.w700,
                          ),
                          controller: link,
                          decoration: InputDecoration(
                            hintText: 'Ссылка',
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
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await _partnersController
                                .setBecomePartner(<String, String>{
                              "link": link.text,
                              "name": name.text,
                              "whom": whom.text,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Заявка отправлена!')),
                            );
                          }
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
}
