import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> generateReport({
    required double income,
    required double expense,
    required double balance,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              pw.Text(
                "MoneyMate Report",
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 30),

              pw.Text("Total Income : ₹$income"),
              pw.SizedBox(height: 10),

              pw.Text("Total Expense : ₹$expense"),
              pw.SizedBox(height: 10),

              pw.Text("Current Balance : ₹$balance"),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}