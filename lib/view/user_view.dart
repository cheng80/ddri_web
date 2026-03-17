import 'package:flutter/material.dart';

/// 사용자 페이지: 근처 대여소 조회
class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('대여소 조회')),
      body: const Center(child: Text('사용자 페이지 (구현 예정)')),
    );
  }
}
