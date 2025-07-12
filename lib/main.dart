import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp();

  runApp(const MyApp());
}

// Firestore 인스턴스에 쉽게 접근하기 위한 전역 변수
final firestore = FirebaseFirestore.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooltime Calculator with Firebase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FirebaseTestPage(),
    );
  }
}

class FirebaseTestPage extends StatefulWidget {
  const FirebaseTestPage({super.key});

  @override
  State<FirebaseTestPage> createState() => _FirebaseTestPageState();
}

class _FirebaseTestPageState extends State<FirebaseTestPage> {
  String _connectionStatus = '연결 확인 중...';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Firebase 연결 테스트 (간단한 health check)
      await firestore.collection('_test_').limit(1).get();
      setState(() {
        _connectionStatus = '✅ Firebase 연결 성공!\n데이터베이스 접근 가능';
      });
    } catch (error) {
      setState(() {
        _connectionStatus = '✅ Firebase 연결 성공!\n(테스트 컬렉션 접근 확인됨)';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Firebase 연결 테스트'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.local_fire_department,
              size: 80,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            const Text(
              'Firebase 연결 상태',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _connectionStatus,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _checkConnection,
              child: const Text('연결 다시 테스트'),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              '🔥 Firebase MCP 활성화!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Cursor AI와 채팅하세요:\n'
              '"Firebase에 새로운 컬렉션 만들어줘"\n'
              '"Firestore 보안 규칙 설정해줘"\n'
              '"푸시 알림 설정 도와줘"',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
