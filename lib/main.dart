import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase 초기화
  await Supabase.initialize(
    url: Config.supabaseUrl,
    anonKey: Config.supabaseAnonKey,
  );

  runApp(const MyApp());
}

// Supabase 클라이언트 인스턴스에 쉽게 접근하기 위한 전역 변수
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooltime Calculator with Supabase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SupabaseTestPage(),
    );
  }
}

class SupabaseTestPage extends StatefulWidget {
  const SupabaseTestPage({super.key});

  @override
  State<SupabaseTestPage> createState() => _SupabaseTestPageState();
}

class _SupabaseTestPageState extends State<SupabaseTestPage> {
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
      // Supabase 연결 테스트 (간단한 health check)
      final response = await supabase.from('_dummy_').select().limit(1);
      // 연결이 성공하면 (테이블이 없어도 에러 타입이 다름)
      setState(() {
        _connectionStatus = '✅ Supabase 연결 성공!\n데이터베이스 접근 가능';
      });
    } catch (error) {
      // 연결 관련 에러와 테이블 없음 에러를 구분
      String errorMessage = error.toString();
      if (errorMessage.contains('relation "_dummy_" does not exist') ||
          errorMessage.contains('does not exist')) {
        setState(() {
          _connectionStatus = '✅ Supabase 연결 성공!\n데이터베이스 접근 가능';
        });
      } else {
        setState(() {
          _connectionStatus = '❌ 연결 실패: $error\n\n설정을 확인해주세요:';
        });
      }
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
        title: const Text('Supabase 연결 테스트'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.cloud_sync,
              size: 80,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            const Text(
              'Supabase 연결 상태',
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
              '설정 방법:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Supabase 대시보드에서 프로젝트 생성\n'
              '2. Settings > API에서 URL과 Publishable Key 복사\n'
              '3. main.dart의 YOUR_SUPABASE_URL과\n'
              '   YOUR_SUPABASE_PUBLISHABLE_KEY를 실제 값으로 교체',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
