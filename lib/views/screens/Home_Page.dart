import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/changetheme_provider.dart';
import '../../models/currency_class.dart';
import '../../models/helper/api_helper.dart';

class MyCurrencyapp extends StatefulWidget {
  const MyCurrencyapp({Key? key}) : super(key: key);

  @override
  State<MyCurrencyapp> createState() => _MyCurrencyappState();
}

class _MyCurrencyappState extends State<MyCurrencyapp> {
  String from = 'Selected country';
  String To = 'Selected country';
  String amount = "amount";
  String hintf = "From";
  String hintt = "To";

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Converter"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          const SizedBox(
            width: 40,
          ),
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).changeTheme();
              print("change");
            },
            icon: const Icon(Icons.light_mode),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 20),
              height: 30,
              width: 300,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(spreadRadius: 1, blurRadius: 5, color: Colors.grey)
                ],
                borderRadius: BorderRadius.circular(10),
                color: Colors.teal,
              ),
              child: const Text(
                "Select Country",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButton(
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      elevation: 10,
                      menuMaxHeight: 350,
                      hint: Text(
                        hintf ?? "From",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal),
                      ),
                      items: Currency.Currencydata.map((e) => DropdownMenuItem(
                          onTap: () {
                            hintf = e['country'];
                          },
                          value: e['currency_code'],
                          child: Text(e['country']))).toList(),
                      onChanged: (val) {
                        setState(() {
                          from = val.toString();
                        });
                      }),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: DropdownButton(
                      // value: To,
                      elevation: 10,
                      isExpanded: true,
                      menuMaxHeight: 350,
                      hint: Text(
                        hintt ?? "From",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal),
                      ),
                      items: Currency.Currencydata.map((e) => DropdownMenuItem(
                          onTap: () {
                            hintt = e['country'];
                          },
                          value: e['currency_code'],
                          child: Text(e['country']))).toList(),
                      onChanged: (val) {
                        setState(() {
                          To = val.toString();
                        });
                      }),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              onChanged: (val) {
                setState(() {
                  amount = val;
                });
              },
              cursorColor: Colors.teal,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 1.5)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2)),
                  hintText: "₹ Amount",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${from}",
                  style: TextStyle(color: Colors.teal.shade400, fontSize: 15),
                ),
                const Icon(Icons.arrow_right_alt),
                Text(
                  " ${To}",
                  style: TextStyle(color: Colors.teal.shade400, fontSize: 15),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: Apihelper.apihelper
                    .getdata(from: '${from}', to: '${To}', amount: '${amount}'),
                builder: (context, snapShot) {
                  if (snapShot.hasError) {
                    return Text("${snapShot.error}");
                  } else if (snapShot.hasData) {
                    Map? p = snapShot.data;
                    return Column(children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Container(
                        height: 50,
                        width: 330,
                        alignment: Alignment.center,
                        child: Text.rich(TextSpan(children: [
                          const TextSpan(
                            text: "Result : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 2,
                                color: Colors.teal),
                          ),
                          TextSpan(
                            text: "${p!['new_amount']} ",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 3,
                                color: Colors.teal),
                          ),
                          TextSpan(
                            text: "${To}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 3,
                                color: Colors.grey),
                          )
                        ])),
                      ),
                    ]);
                  }
                  return Center(
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 30),
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(25)),
                      child: const Text(
                        "Convert",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: 3,
                            color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
