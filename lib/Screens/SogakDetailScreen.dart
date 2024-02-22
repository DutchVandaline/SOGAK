import 'package:flutter/material.dart';
import 'package:sogak/Screens/SplashScreen.dart';
import 'package:sogak/Screens/SubSogakDetailScreen.dart';
import 'package:sogak/Services/Api_services.dart';

class SogakDetailScreen extends StatefulWidget {
  const SogakDetailScreen({Key? key, required this.inputId}) : super(key: key);
  final int inputId;

  @override
  State<SogakDetailScreen> createState() => _SogakDetailScreenState();
}

class _SogakDetailScreenState extends State<SogakDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text("소각된 감정 🕯️"),
        actions: [
          IconButton(
              onPressed: () {
                deleteDialog(context);
              },
              icon: const Icon(Icons.delete_forever)),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: ApiService.getDatabyId(widget.inputId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("이미 삭제되었거나\n불러오는데 오류가 발생했습니다."),
              );
            } else {
              var SogakData = snapshot.data;
              print(SogakData);
              if (SogakData != null) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SubSogakDetailScreen(inputData: SogakData),
                );
              } else {
                return const Text('No data available');
              }
            }
          },
        ),
      ),
    );
  }

  void deleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제 확인'),
          content: const Text(
            '이미 소각된 감정입니다.\n해당 감정을 삭제하시겠습니까?',
            style: TextStyle(fontSize: 13.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                '취소',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                ApiService.deleteMood(widget.inputId);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SplashScreen()),
                        (route) => false);
              },
              child: const Text(
                '삭제',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
