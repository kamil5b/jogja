import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:jogja/details.dart';
import 'package:jogja/models/tempat.dart';
import 'package:jogja/models/order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jogja/network/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget(this.ListOrder,{Key? key}) : super(key: key);
  final List<Order> ListOrder;
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  List<Order> selectedOrder = [];
  List<bool> OrderSelected = [];
  late TextEditingController textController;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int totalHarga = 0;
  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    selectedOrder = [];
    OrderSelected = [];
    for(int i=0;i<widget.ListOrder.length;i++){
      OrderSelected.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,

      backgroundColor: Color(0xFFF1F4F8),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 44),
                  child:
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.ListOrder.length,
                    itemBuilder: (context, index) {
                      return OrderItem(widget.ListOrder[index], OrderSelected[index], index);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Give us feedback!',
                        style:
                        TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                        ),
                      ),
                      Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: Text("Total : ${totalHarga}",
                                style:TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                )
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  _ordering();
                                },
                                child: Text('Send now!'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(130,40),
                                  textStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                  ),
                                  side: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }

  Widget OrderItem(Order order, bool isSelected, int index){
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green[700],
        child: Image.network(
          order.tempat.url_pic,
        ),
      ),
      title: Text(
        order.tempat.place,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color:Colors.black
        ),
      ),
      subtitle: Column(children: [
        Text(order.tanggal.toString(),
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color:Colors.black
            )),
        Text(order.status,style: TextStyle(
            fontWeight: FontWeight.w500,
            color:Colors.black
        ))
      ],) ,
      trailing: isSelected
          ? Icon(
        Icons.check_circle,
        color: Colors.green[700],
      )
          : Icon(
        Icons.check_circle_outline,
        color: Colors.grey,
      ),
      onTap: () {
        setState(() {
          OrderSelected[index] = !OrderSelected[index];
          if (OrderSelected[index] == true) {
            selectedOrder.add(widget.ListOrder[index]);
          } else if (OrderSelected[index] == false) {
            print(selectedOrder);
            selectedOrder.removeWhere((element) => element == widget.ListOrder[index]);
          }
          totalHarga = 0;
          for(int i=0;i<selectedOrder.length;i++){
            totalHarga += selectedOrder[i].tempat.harga;
          }
        });
      },
    );
  }

  void _ordering() async{
    setState(() {
      _isLoading = true;
    });
    List<int> orders = [];
    for(int i=0;i<selectedOrder.length;i++){
      orders.add(selectedOrder[i].id);
    }
    var data = {
      'orders' : orders,
      'total' : totalHarga
    };

    var res = await Network().auth(data, '/checkout');
    var body = json.decode(res.body);
    print(body['message']);

    setState(() {
      _isLoading = false;
    });
  }

}
