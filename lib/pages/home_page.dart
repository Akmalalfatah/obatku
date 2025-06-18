import 'package:flutter/material.dart';
import 'package:obatku/components/stateless_widgets/profile_welcome.dart';
import 'package:obatku/components/stateless_widgets/search_chip.dart';
import 'package:obatku/components/stateful_widgets/carousel.dart';
import 'package:obatku/components/stateless_widgets/home_button.dart';
import 'package:obatku/pages/explore_page.dart';
import 'package:obatku/pages/maps_page.dart';
import 'package:obatku/pages/profile_page.dart';
import 'package:obatku/pages/reminder_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    // Home Tab
    SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFCFDAFF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 48.0, 24.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileWelcome(),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(Icons.nightlight_round, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.notifications_none,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search....',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    children: const [
                      SearchChip(
                        text: 'Citrizine',
                        color: Colors.yellow,
                        textColor: Colors.black,
                      ),
                      SearchChip(
                        text: 'Omeprazole',
                        color: Colors.blue,
                        textColor: Colors.white,
                      ),
                      SearchChip(
                        text: 'Ibuprofen',
                        color: Colors.greenAccent,
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Carousel(
              images: [
                'assets/images/slide-1.png',
                'assets/images/slide-2.png',
                'assets/images/slide-3.png',
                'assets/images/slide-4.png',
                'assets/images/slide-5.png',
              ],
              onTap: (index) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 1,
              children: [
                HomeButton(
                  icon: Icons.search,
                  iconColor: Colors.orange,
                  onTap: () {},
                ),
                HomeButton(
                  icon: Icons.explore_outlined,
                  iconColor: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExplorePage()),
                    );
                  },
                ),
                HomeButton(
                  icon: Icons.calendar_month_outlined,
                  iconColor: Colors.pinkAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReminderPage()),
                    );
                  },
                ),
                HomeButton(
                  icon: Icons.location_on,
                  iconColor: Colors.cyan,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapsPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),

    // Explore Tab
    ExplorePage(),

    // Reminder Tab
    ReminderPage(),

    // Maps Tab
    MapsPage(),

    // Profile Tab
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E5FA),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Reminder',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Maps'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
