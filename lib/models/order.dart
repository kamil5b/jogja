
import 'package:flutter/material.dart';
import 'package:jogja/models/tempat.dart';

class Order{
  int id;
  Tempat tempat;
  DateTime tanggal;
  DateTime? payed_on;
  String status;

  Order(this.id,
      this.tempat,
      this.tanggal,
      this.status,{
    this.payed_on
  });

}

class OrderListTileWidget extends StatelessWidget {
  final Order order;
  final bool isSelected;
  final ValueChanged<Order> onSelectedOrder;

  const OrderListTileWidget({
    Key? key,
    required this.order,
    required this.isSelected,
    required this.onSelectedOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).primaryColor;
    final style = isSelected
        ? TextStyle(
      fontSize: 18,
      color: selectedColor,
      fontWeight: FontWeight.bold,
    )
        : TextStyle(fontSize: 18);

    return ListTile(
      onTap: () => onSelectedOrder(order),
      leading: Padding(
        padding:
        EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
        child: Container(
          width: 100,
          height: 100,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.network(
            order.tempat.url_pic,
          ),
        ),
      ),
      title:  Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${order.tempat.place}',
            textAlign: TextAlign.start,
            style: style,
          ),
          Text(
            '${order.tempat.harga}',
            textAlign: TextAlign.start,
            style: style,
          ),
          Text(
            '${order.tanggal}',
            textAlign: TextAlign.start,
            style: style,
          ),
          Text(
            '${order.status}',
            textAlign: TextAlign.start,
            style: style,
          ),
        ],
      ),
      trailing:
      isSelected ? Icon(Icons.check, color: selectedColor, size: 26) : null,
    );
  }
}