import 'package:flutter/material.dart';

class SettingScreenWidget extends StatelessWidget {
  const SettingScreenWidget({Key? key, required this.inputIcon, required this.inputText, required this.inputScreen}) : super(key: key);
  final Icon inputIcon;
  final String inputText;
  final Widget inputScreen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => inputScreen));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            decoration: BoxDecoration(
                color: const Color(0xFF292929),
                borderRadius: BorderRadius.circular(15.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: inputIcon,
                    ),
                    const SizedBox(width: 20.0),
                    Text(inputText),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ],
            )),
      ),
    );
  }
}
