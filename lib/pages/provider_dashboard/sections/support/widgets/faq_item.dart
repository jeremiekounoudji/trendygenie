import 'package:flutter/material.dart';
import '../../../../../utils/globalVariable.dart';

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1)),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          title: CustomText(text: question, color: blackColor, fontSize: 15.0, fontWeight: FontWeight.bold),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: firstColor.withOpacity(0.05),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(color: firstColor, borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: CustomText(text: answer, color: Colors.grey[700]!, fontSize: 14.0, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
