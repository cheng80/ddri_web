import 'package:flutter/material.dart';

/// 관리자 페이지: 재배치 판단 목록
class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('재배치 관리')),
      body: const Center(child: Text('관리자 페이지 (구현 예정)')),
    );
  }
}
