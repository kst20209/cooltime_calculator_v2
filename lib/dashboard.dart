import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchController = TextEditingController();

  // 가상의 데이터
  final List<Map<String, dynamic>> _activities = [
    {
      'name': '치킨',
      'emoji': '🍗',
      'lastDate': '1일 전',
      'cooldownDays': 7,
      'isAvailable': false,
      'daysLeft': 6,
    },
    {
      'name': '피자',
      'emoji': '🍕',
      'lastDate': '3일 전',
      'cooldownDays': 5,
      'isAvailable': true,
      'daysLeft': 0,
    },
    {
      'name': '돈가스',
      'emoji': '🍖',
      'lastDate': '8일 전',
      'cooldownDays': 7,
      'isAvailable': true,
      'daysLeft': 0,
    },
    {
      'name': '스시',
      'emoji': '🍣',
      'lastDate': '2일 전',
      'cooldownDays': 10,
      'isAvailable': false,
      'daysLeft': 8,
    },
    {
      'name': '버거',
      'emoji': '🍔',
      'lastDate': '5일 전',
      'cooldownDays': 4,
      'isAvailable': true,
      'daysLeft': 0,
    },
    {
      'name': '파스타',
      'emoji': '🍝',
      'lastDate': '1일 전',
      'cooldownDays': 3,
      'isAvailable': false,
      'daysLeft': 2,
    },
    {
      'name': '라면',
      'emoji': '🍜',
      'lastDate': '4일 전',
      'cooldownDays': 2,
      'isAvailable': true,
      'daysLeft': 0,
    },
    {
      'name': '타코',
      'emoji': '🌮',
      'lastDate': '6일 전',
      'cooldownDays': 5,
      'isAvailable': true,
      'daysLeft': 0,
    },
  ];

  List<Map<String, dynamic>> _filteredActivities = [];

  @override
  void initState() {
    super.initState();
    _filteredActivities = _activities;
  }

  void _filterActivities(String query) {
    setState(() {
      _filteredActivities = _activities
          .where((activity) =>
              activity['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          '🔥 쿨타임 계산기',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF6B7280)),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 검색바
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterActivities,
                decoration: InputDecoration(
                  hintText: '음식을 검색하세요...',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF6B7280)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 통계 섹션
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                      '총 활동', '${_activities.length}개', Icons.restaurant),
                  _buildStatItem(
                      '쿨타임 중',
                      '${_activities.where((a) => !a['isAvailable']).length}개',
                      Icons.timer),
                  _buildStatItem(
                      '가능한 것',
                      '${_activities.where((a) => a['isAvailable']).length}개',
                      Icons.check_circle),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 활동 리스트
            Expanded(
              child: ListView.builder(
                itemCount: _filteredActivities.length,
                itemBuilder: (context, index) {
                  final activity = _filteredActivities[index];
                  return _buildActivityCard(activity);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF667EEA),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    final bool isAvailable = activity['isAvailable'];
    final Color statusColor =
        isAvailable ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // 활동 상세 화면으로 이동
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // 이모지 아이콘
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      activity['emoji'],
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // 활동 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            activity['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isAvailable ? '가능' : '쿨타임',
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${activity['lastDate']} • ${activity['cooldownDays']}일 주기',
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 14,
                        ),
                      ),
                      if (!isAvailable) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${activity['daysLeft']}일 후 가능',
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // 빠른 액션 버튼
                if (isAvailable)
                  Container(
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.restaurant,
                        color: statusColor,
                      ),
                      onPressed: () {
                        // 먹었음 기록
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${activity['name']} 먹었음으로 기록됨!'),
                            backgroundColor: statusColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.timer,
                        color: Color(0xFF9CA3AF),
                      ),
                      onPressed: null,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
