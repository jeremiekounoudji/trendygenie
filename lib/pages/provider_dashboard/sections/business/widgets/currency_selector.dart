import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import '../../../../../utils/globalVariable.dart';
import '../../../../../utils/currency_helper.dart';

class CurrencySelector extends StatelessWidget {
  final String? selectedCurrency;
  final ValueChanged<String> onCurrencyChanged;

  const CurrencySelector({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currencies = CurrencyHelper.currencies.values.toList();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.currency_exchange, color: firstColor),
              const SizedBox(width: 10),
              CustomText(
                text: "Business Currency",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomText(
            text: "This currency will be used for all services in this business",
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.grey[600]!,
          ),
          const SizedBox(height: 15),
          CustomPopup(
            barrierColor: Colors.black12,
            backgroundColor: whiteColor,
            arrowColor: whiteColor,
            showArrow: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            contentDecoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            content: Container(
              constraints: const BoxConstraints(maxHeight: 250),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: currencies.map((currency) => 
                    InkWell(
                      onTap: () {
                        onCurrencyChanged(currency.code);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: firstColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      currency.symbol,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: firstColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currency.code,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: selectedCurrency == currency.code 
                                          ? firstColor 
                                          : blackColor,
                                      ),
                                    ),
                                    Text(
                                      currency.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (selectedCurrency == currency.code)
                              Icon(Icons.check, color: firstColor, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (selectedCurrency != null) ...[
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: firstColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              CurrencyHelper.getSymbol(selectedCurrency!),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: firstColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        selectedCurrency != null 
                          ? '${CurrencyHelper.getCurrencyInfo(selectedCurrency!)?.name} ($selectedCurrency)'
                          : "Select Currency",
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedCurrency != null ? blackColor : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_drop_down, color: firstColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
