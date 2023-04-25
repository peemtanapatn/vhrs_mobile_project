// ignore_for_file: file_names

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vhrs_flutter_project/pages/register/register.dart';
import 'package:vhrs_flutter_project/utils/theme.dart';
import 'package:vhrs_flutter_project/utils/validationField.dart';
import 'package:vhrs_flutter_project/widgets/text_input.dart';

class ActivityForm extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RegisterPage registerPage;
  ActivityForm({Key? key, required this.registerPage}) : super(key: key);

  final DateFormat formatter = DateFormat('dd MMM yyyy | HH:mm น.', 'th');

  DateTime startDate = DateTime.now(), endDate = DateTime.now();
  String? emailUser;

  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController locationNameController = TextEditingController();
  TextEditingController locationLinkController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  int _widgetIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          TextInput(
              controller: widget.nameController,
              compose: Validators.compose([
                Validators.required("กรุณากรอกชื่อกิจกรรม"),
              ]),
              icon: Icons.arrow_right,
              hint: "ชื่อกิจกรรม",
              typeInput: TextInputType.name),
          SearchField(
              searchStyle: TextStyle(fontSize: 20.sp),
              controller: widget.typeController,
              validator: Validators.compose([
                Validators.required("กรุณาเลือกประเภทกิจกรรม"),
                Validators.checkList(widget.typeController.text,
                    ["Online", "Onsite"], "ไม่มีข้อมูลของประเภทกิจกรรมนี้")
              ]),
              // hint: "ประเภทกิจกรรม",
              searchInputDecoration: theme_InputDecoration(
                Icons.arrow_right,
                Icons.arrow_drop_down,
                "ประเภทกิจกรรม",
                Theme.of(context).canvasColor,
              ),
              suggestionState: SuggestionState.enabled,
              maxSuggestionsInViewPort: 3,
              // itemHeight: 50,
              suggestionsDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: (value) {
                setState(() {});

                print(value);
              },
              suggestions: const ["Online", "Onsite"]),
          TextInput(
            controller: widget.locationNameController,
            compose: Validators.compose([
              Validators.required("กรุณากรอกชื่อสถานที่จัดกิจกรรม"),
            ]),
            icon: Icons.arrow_right,
            hint: "ชื่อสถานที่จัดกิจกรรม",
            typeInput: TextInputType.name,
          ),
          Row(
            children: [
              Flexible(
                child: TextInput(
                  controller: widget.locationLinkController,
                  compose: Validators.compose([
                    Validators.required("กรุณากรอกลิ้งค์สถานที่จัดกิจกรรม"),
                  ]),
                  icon: Icons.arrow_right,
                  hint: "ลิ้งค์สถานที่จัดกิจกรรม",
                  typeInput: TextInputType.text,
                ),
              ),
              TextButton(
                onPressed: () {
                  showDataAlert();
                },
                child: Text(
                  "แนะนำ",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
              ),
            ],
          ),
          createDateTimePick(
              context, widget.startDate, "เริ่ม", widget.startController),
          createDateTimePick(
              context, widget.endDate, "สิ้นสุด", widget.endController),
          TextInput(
            controller: widget.amountController,
            compose: Validators.compose([
              Validators.required("กรุณากรอกจำนวนคนเข้าร่วมที่ต้องการ"),
            ]),
            icon: Icons.arrow_right,
            hint: "จำนวนคนเข้าร่วมที่ต้องการ",
            typeInput: TextInputType.number,
          ),
          TextInput(
            controller: widget.hourController,
            compose: Validators.compose([
              Validators.required("กรุณากรอกจำนวนชั่วโมงจิตอาสา"),
            ]),
            icon: Icons.arrow_right,
            hint: "จำนวนชั่วโมงจิตอาสา",
            typeInput: TextInputType.number,
          ),
          TextFormField(
            style: TextStyle(fontSize: 20.sp),
            minLines: 2,
            maxLines: 1000,
            controller: widget.detailController,
            decoration: theme_InputDecoration(
              Icons.arrow_right,
              Icons.my_library_books_rounded,
              "รายละเอียดกิจกรรม",
              Theme.of(context).canvasColor,
            ),

            //  const InputDecoration(
            //   prefixIcon: Icon(
            //     Icons.arrow_right,
            //   ),
            //   hintText: "รายละเอียดกิจกรรม",
            // ),
            // validator: Validators.compose([
            //   Validators.required("กรุณากรอกรายละเอียดกิจกรรม"),
            // ]),
          ),
        ],
      ),
    );
  }

  createDateTimePick(BuildContext context, DateTime currentValue, String check,
      TextEditingController controller) {
    return DateTimeField(
        style: TextStyle(fontSize: 20.sp),
        controller: controller,
        format: widget.formatter,
        onShowPicker: (context, currentValue) async {
          try {
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100),
                cancelText: "ยกเลิก",
                confirmText: "ตกลง",
                helpText: "เลือกวันที่",
                errorFormatText: 'mm/dd/yyyy',
                locale: const Locale('en'),
                builder: (context, child) =>
                    themeDateTimePicker(context, child));
            if (date != null) {
              final time = await showTimePicker(
                  cancelText: "ยกเลิก",
                  confirmText: "ตกลง",
                  helpText: "เลือกเวลา",
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  builder: (context, child) =>
                      themeDateTimePicker(context, child));
              // currentValue=DateTime(date.year,date.month,date.day,time!.hour,time.minute);
              if (check == "เริ่ม") {
                widget.startDate = DateTime(
                    date.year, date.month, date.day, time!.hour, time.minute);
              }
              if (check == "สิ้นสุด") {
                widget.endDate = DateTime(
                    date.year, date.month, date.day, time!.hour, time.minute);
              }
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          } catch (e) {
            print(e);
          }
          return null;
        },
        decoration: theme_InputDecoration(
          Icons.arrow_right,
          Icons.calendar_today,
          "วัน-เวลา $checkกิจกรรม",
          Theme.of(context).canvasColor,
        ),
        validator: (value) {
          // log(_startDate.toString());
          // log(_endDate.toString());
          if (value == null) {
            return 'กรุณากรอก วัน-เวลา $checkกิจกรรม';
          } else {
            if (widget.endDate.isBefore(widget.startDate)) {
              return "กรอกวันที่-เวลาให้ถูกต้องโดยที่ วันที่เริ่ม ต้องมาก่อน วันสิ้นสุด";
            }

            return null;
          }
        });
  }

  showDataAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return IndexedStack(
            index: _widgetIndex,
            children: [
              _dialogPage("1", "ไปที่เว็บหรือแอพพลิเคชั่น Google Map"),
              _dialogPage("2", "ค้นหาสถานที่ที่ต้องการ"),
              _dialogPage("3", "เลือกเมนูแชร์"),
              _dialogPage("4", "เลือกคัดลอกลิงก์"),
              _dialogPage("5", "นำลิงก์ที่ได้มาวาง")
            ],
          );
        });
  }

  _dialogPage(String i, String head) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            20.r,
          ),
        ),
      ),
      contentPadding: EdgeInsets.only(top: 10.w, bottom: 10.w),
      actionsPadding: EdgeInsets.only(bottom: 10.w),
      title: Text(
        "ขั้นตอนที่ " + i,
        style: TextStyle(fontSize: 24.sp),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NoPage("1"),
            _NoPage("2"),
            _NoPage("3"),
            _NoPage("4"),
            _NoPage("5")
          ],
        ),
      ],
      content: SizedBox(
        height: 400.h,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  head,
                ),
              ),
              i == "5"
                  ? Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () async {
                          try {
                            await launch("https://www.google.co.th/maps",
                                forceWebView: true,
                                enableJavaScript: true,
                                forceSafariVC: false);
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text(
                          "ไปยัง Google Map",
                          style: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 16.sp),
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/locationLink_dialog_' + i + '.jpg',
                    height: 300.h,
                    width: 200.w,
                    scale: 1,
                    fit: BoxFit.fill,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  _NoPage(String s) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          setState(() => _widgetIndex = int.parse(s) - 1);
          Navigator.pop(context, false);
          showDataAlert();
        },
        child: Text(
          s,
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
    );
  }
}
