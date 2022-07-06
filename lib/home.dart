
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jogja/models/order.dart';
import 'package:jogja/network/api.dart';
import 'package:jogja/places.dart';
import 'package:jogja/orders.dart';
import 'package:jogja/models/tempat.dart';
import 'package:jogja/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<Tempat> ListTempat = [
    Tempat(1,
        'Tugu Jogja',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Yogyakarta_Indonesia_Tugu-Yogyakarta-01.jpg/1200px-Yogyakarta_Indonesia_Tugu-Yogyakarta-01.jpg',
        'Tugu Jogja adalah sebuah tugu atau monumen yang sering dipakai sebagai simbol atau lambang dari Kota Yogyakarta.Mempunyai nilai simbolis yang merupakan garis yang bersifat magis yang menghubungkan Pantai Parangtritis dan Panggung Krapyak di Kabupaten Bantul, Keraton Yogyakarta di Kota Yogyakarta dan Gunung Merapi di Kabupaten Sleman. ',
        'Jalan Jenderal Sudirman dan Jalan Margo Utomo',5000
    ),
    Tempat(2,
        'Tamansari',
        'https://centertravel.id/wp-content/uploads/2020/11/Lokasi-Taman-Sari-Jogja.jpg',
        'memiliki luas lebih dari 10 hektare dengan sekitar 57 bangunan baik berupa gedung, kolam pemandian, jembatan gantung, kanal air, maupun danau buatan beserta pulau buatan dan lorong bawah air. Kebun yang digunakan secara efektif antara 1765-1812 ini pada mulanya membentang dari barat daya kompleks Kedhaton sampai tenggara kompleks Magangan. Namun saat ini, sisa-sisa bagian Taman Sari yang dapat dilihat hanyalah yang berada di barat daya kompleks Kedhaton saja.',
        'Kebun Istana Keraton Ngayogyakarta Hadiningrat',7000
    ),
    Tempat(3,
        'Malioboro',
        'https://assets.promediateknologi.com/crop/0x0:0x0/750x500/photo/ayojogjakarta/images/post/articles/2021/01/25/42312/malioboro.jpg',
        'Salah satu kawasan jalan dari tiga jalan di Kota Yogyakarta yang membentang dari Tugu Yogyakarta hingga ke perempatan Kantor Pos Yogyakarta. Jalan ini menghubungkan Tugu Yogyakarta hingga menjelang kompleks Keraton Yogyakarta. Jalan ini berakhir di Pasar Beringharjo (di sisi timur). Dari titik ini nama jalan berubah menjadi Jalan Achmad Yani. Di sini terdapat bekas kediaman gubernur Hindia-Belanda di sisi barat dan Benteng Vredeburg di sisi timur.',
        'Jalan Malioboro (bahasa Jawa: ꦢꦭꦤ꧀​ꦩꦭꦶꦪꦧꦫ, translit. Dalan Maliabara) ',4500
    ),
  ];
  static List<Order> ListOrder = [
    Order(1,
        ListTempat[0],new DateTime.now(),'Unpaid'
    ),
    Order(2,
        ListTempat[1],new DateTime.now(),'Unpaid'
    ),
  ];
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    PlacesWidget(ListTempat),
    OrdersWidget(ListOrder),
    ProfileWidget(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ListTempat = await getData(apiURL);
  }

  void _loadTempat() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    late int id = user['id'];
    var res = await Network().getData("/get/");
    var body = json.decode(res.body);
    print(body['message']);

  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC2C2C2),
        automaticallyImplyLeading: false,
        title: Align(
          alignment: AlignmentDirectional(0, 0),
          child: Text(
            'Welcome to Jogja',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFFFF5959),
              fontSize: 26,
            ),
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore,
                color:Colors.grey),
            label: 'Destination',
            activeIcon:Icon(Icons.travel_explore,
                color:Color(0xFFFF5959)
            ),
            //backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book,
                color:Colors.grey),
            label: 'Orders',
            activeIcon:Icon(Icons.book,
                color:Color(0xFFFF5959)
            ),
            //backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people,
                color:Colors.grey),
            label: 'Profile',
            activeIcon:Icon(Icons.people,
                color:Color(0xFFFF5959)
            ),
            //backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFFF5959),
        onTap: _onItemTapped,
      ),
    );
  }
}

