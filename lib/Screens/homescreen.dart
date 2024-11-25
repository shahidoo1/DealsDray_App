import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  // Define a list of ExclusiveItemData
  final List<ExclusiveItemData> exclusiveItems = [
    ExclusiveItemData(
      imageUrl: 'Assets/smartphone-iphone-11-pro-max-silver-san.png',
      title: 'Nokia 8.1 (iron, 64 GB)',
      discount: '32% Off',
    ),
    ExclusiveItemData(
      imageUrl: 'Assets/smartphone-iphone-11-pro-max-silver-san.png',
      title: 'Redmi Sapphire',
      discount: '14% Off',
    ),
    ExclusiveItemData(
      imageUrl: 'Assets/smartphone-iphone-11-pro-max-silver-san.png',
      title: 'Samsung Galaxy S21',
      discount: '20% Off',
    ),
    ExclusiveItemData(
      imageUrl: 'Assets/smartphone-iphone-11-pro-max-silver-san.png',
      title: 'OnePlus 9 Pro',
      discount: '25% Off',
    ),
    ExclusiveItemData(
      imageUrl: 'Assets/smartphone-iphone-11-pro-max-silver-san.png',
      title: 'Google Pixel 6',
      discount: '15% Off',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const TextField(
          decoration: InputDecoration(
            hintText: 'Search here',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
        ),
        actions: const [
          Icon(Icons.notifications, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 150,
              color: Colors.grey[200],
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    'Assets/smart-mobile-promotional-banner-design-template_987701-2646.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            // KYC Pending Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 38, 120, 187),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'KYC Pending',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'You need to provide the required documents for your account activation.',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Click Here',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Categories Section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CategoryIcon(label: 'Mobile', icon: Icons.phone_android),
                  CategoryIcon(label: 'Laptop', icon: Icons.laptop),
                  CategoryIcon(label: 'Camera', icon: Icons.camera_alt),
                  CategoryIcon(label: 'LED', icon: Icons.lightbulb),
                ],
              ),
            ),

            // Exclusive Section with ListView.builder
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'EXCLUSIVE FOR YOU',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: exclusiveItems.length,
                itemBuilder: (context, index) {
                  var item = exclusiveItems[index];
                  return ExclusiveItem(
                    imageUrl: item.imageUrl,
                    title: item.title,
                    discount: item.discount,
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: 'Categories'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer), label: 'Deals'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),

      floatingActionButton: Container(
        width: 100, // Set the width to your desired size
        child: FloatingActionButton(
          onPressed: () {
            // Add your chat button action here
            // For example, navigate to a chat screen or show a message
            print('Chat Button Pressed');
          },
          backgroundColor: Colors.red,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.message,
                color: Colors.white,
              ),
              SizedBox(width: 8), // Space between icon and text
              Text("Chat", style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

class ExclusiveItemData {
  final String imageUrl;
  final String title;
  final String discount;

  ExclusiveItemData({
    required this.imageUrl,
    required this.title,
    required this.discount,
  });
}

class CategoryIcon extends StatelessWidget {
  final String label;
  final IconData icon;

  const CategoryIcon({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          child: Icon(icon, color: Colors.white),
          backgroundColor: Colors.grey,
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}

class ExclusiveItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String discount;

  const ExclusiveItem({
    required this.imageUrl,
    required this.title,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(imageUrl, height: 120, width: 150, fit: BoxFit.cover),
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  color: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Text(
                    discount,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
