import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/models/join_activity_model.dart';
import 'package:vhrs_flutter_project/models/uj_model.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;

Future<void> createPDF(
  String emailUser,
  List<JoinAndActivityModel> listSelect,
) async {
  final font = await PdfGoogleFonts.trirongLight();
  final pdf = pw.Document();
  final headers1 = [
    'ชื่อกิจกรรม',
    'สถานที่',
    'เวลา-วัน/เดือน/ปี',
    'จำนวนชั่วโมง',
    'ลักษณะของกิจกรรม'
  ];
  final data = listSelect
      .map((e) => [
            e.acName,
            e.acLocationName,
            getDate(e.acDstart, e.acDend),
            e.acHour,
            e.jaDetail,
          ])
      .toList();

  UjModel profile = await getDateUser(emailUser);

  final netImage = await networkImage(
      'https://www.matichon.co.th/wp-content/uploads/2021/02/%E0%B8%81%E0%B8%A2%E0%B8%A8..jpg');
  //MainPAge
  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Column(
                    children: [
                      pw.Image(netImage, height: 120, width: 150),
                      pw.Text('มหาวิทยาลัยมหาสารคาม',
                          style: pw.TextStyle(font: font, fontSize: 24)),
                    ],
                  )),
              pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Column(
                    children: [
                      pw.Text(
                          'บันทึกการเข้าร่วมกิจกรรมที่ทำประโยชน์ต่อสังคมหรือสาธารณะ',
                          style: pw.TextStyle(font: font, fontSize: 18)),
                      pw.Text(
                          'ภาคเรียนที่ ................ ปีการศึกษา ................',
                          style: pw.TextStyle(font: font, fontSize: 18)),
                    ],
                  )),
              pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Column(
                    children: [
                      pw.Text('ชื่อ ' + profile.ujName!,
                          style: pw.TextStyle(font: font, fontSize: 18)),
                      pw.Text(
                          'คณะ ' +
                              profile.ujFaculty! +
                              "  ชั้นปีที่ ................",
                          style: pw.TextStyle(font: font, fontSize: 18)),
                    ],
                  )),
            ]); // Center
      }));

  pdf.addPage(
    pw.MultiPage(
        build: (context) => [
              Container(
                alignment: Alignment.center,
                child: pw.Text(
                    'บันทึกการเข้าร่วมกิจกรรม ที่ทำประโยชน์ต่อสังคมหรือสาธารณะ  \nภาคเรียนที่...... ปีการศึกษา......',
                    style: TextStyle(font: font, fontSize: 16)),
              ),
              pw.SizedBox(height: 12),
              Table.fromTextArray(
                  headerAlignment: Alignment.center,
                  headerStyle: TextStyle(
                      font: font, fontWeight: FontWeight.bold, fontSize: 14),
                  cellStyle: TextStyle(
                    font: font,
                  ),
                  context: context,
                  headers: headers1,
                  data: data)
            ]),
  );
  // String imgDefult = "Activity.png";
  // for (int i = 0; i < listSelect.length; i = i + 2) {
  //   // if (listSelect[i].jaImg != "") {

  //   //   pdf.addPage(pw.Page(build: (pw.Context context) {
  //   //     return Center(
  //   //         child: pw.Column(
  //   //       children: [

  //   //       ],
  //   //     )); // Center
  //   //   }));
  //   // }
  //   try {
  //     if (i + 1 < listSelect.length) {
  //       String img1 = imgDefult;
  //       String img2 = imgDefult;
  //       if (listSelect[i].jaImg != null && listSelect[i].jaImg != "") {
  //         img1 = listSelect[i].jaImg!;
  //       }
  //       if (listSelect[i + 1].jaImg != null && listSelect[i + 1].jaImg != "") {
  //         img2 = listSelect[i + 1].jaImg!;
  //       }

  //       var netImage1 = await networkImage(
  //           '${service.serverPath}/VHRSservice/uploads/' + img1);
  //       var netImage2 = await networkImage(
  //           '${service.serverPath}/VHRSservice/uploads/' + img2);
  //       pdf.addPage(pw.Page(build: (pw.Context context) {
  //         String acName1 = listSelect[i].acName ?? "";
  //         String acName2 = listSelect[i + 1].acName ?? "";
  //         return Center(
  //             child: pw.Column(
  //           children: [
  //             Text("ชื่อกิจกรรม : " + acName1,
  //                 style: pw.TextStyle(
  //                     font: font, fontSize: 20, fontWeight: FontWeight.bold)),
  //             pw.SizedBox(height: 20),
  //             pw.Image(netImage1),
  //             pw.SizedBox(height: 20),
  //             Text("ชื่อกิจกรรม : " + acName2,
  //                 style: pw.TextStyle(
  //                     font: font, fontSize: 20, fontWeight: FontWeight.bold)),
  //             pw.SizedBox(height: 20),
  //             pw.Image(netImage2),
  //             pw.SizedBox(height: 20),
  //           ],
  //         )); // Center
  //       }));
  //     } else if (i + 1 >= listSelect.length) {
  //       String img1 = imgDefult;

  //       if (listSelect[i].jaImg != null && listSelect[i].jaImg != "") {
  //         img1 = listSelect[i].jaImg!;
  //       }
  //       var netImage1 = await networkImage(
  //           '${service.serverPath}/VHRSservice/uploads/' + img1);
  //       pdf.addPage(pw.Page(build: (pw.Context context) {
  //         String nameAc = listSelect[i].acName ?? "";
  //         return Center(
  //             child: pw.Column(
  //           children: [
  //             Text("ชื่อกิจกรรม : " + nameAc,
  //                 style: pw.TextStyle(
  //                     font: font, fontSize: 20, fontWeight: FontWeight.bold)),
  //             pw.SizedBox(height: 20),
  //             pw.Image(netImage1),
  //           ],
  //         ));
  //       }));
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Uint8List bytes = await pdf.save();

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/mypdf.pdf');

  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

imgDataShow(String name, String img) async {
  final font = await PdfGoogleFonts.trirongLight();
  var netImage =
      await networkImage('${service.serverPath}/VHRSservice/uploads/' + img);
  return Column(children: [
    Text("ชื่อกิจกรรม : " + name,
        style: pw.TextStyle(
            font: font, fontSize: 20, fontWeight: FontWeight.bold)),
    pw.SizedBox(height: 20),
    pw.Image(netImage),
    pw.SizedBox(height: 20),
  ]);
}

Future<pw.Widget> getDataImg(String txtImg) async {
  final netImage = await networkImage('https://www.nfet.net/nfet.jpg');
  return pw.Center(
    child: pw.Image(netImage),
  );
}

getDate(DateTime? acDstart, DateTime? acDend) {
  final DateFormat formatter = DateFormat('hh:mm - dd MMM yyyy', 'th');
  String date = formatter.format(acDstart ?? DateTime.now()) +
      "\n ถึง \n" +
      formatter.format(acDend ?? DateTime.now());
  return date;
}

Future<UjModel> getDateUser(String emailUser) async {
  final response =
      await http.post(Uri.parse(service.url + "/get_ujProfile"), body: {
    "email": emailUser,
  });
  List<UjModel> model = ujModelFromJson(response.body);
  return model[0];
}
