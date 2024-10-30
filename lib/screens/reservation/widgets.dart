// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';

class Fields extends StatelessWidget {
  Fields({super.key, required this.fcon, required this.label, this.leading, this.type});
  var fcon = TextEditingController();
  String label;
  IconData? leading;
  TextInputType? type;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: fcon,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            style: BorderStyle.solid
          )
        ),
        label: TextContent(name: label, fcolor: Colors.white,),
        prefixIcon: Icon(leading, color: Colors.white,),
      ),
      keyboardType: type,
      style: GoogleFonts.inter(
        color: Colors.white,
      ),
    );
  }
}

// class Fielddecor extends StatelessWidget {
//   const Fielddecor({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const InputDecoration(
      
//     );
//   }
// }

class ContentContainer extends StatelessWidget {
  ContentContainer({super.key, this.height, this.content});

  double? height;
  Widget? content;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: content,
    );
  }
}

class DataDisplayer extends StatelessWidget {
  DataDisplayer({super.key, this.title, this.icon});

  Widget? title;
  Widget? icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      leading: icon,
    );
  }
}

class DataContainer extends StatelessWidget {
  DataContainer({super.key, this.leadingwidget, this.datawidget});

  Widget? leadingwidget;
  Widget? datawidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            leadingwidget as Widget,
            const VerticalDivider(),
            datawidget as Widget
          ],
        ),
      ),
    );
  }
}


class TicketDataDisplayer extends StatelessWidget {
  TicketDataDisplayer({super.key, this.leading, this.title, this.subtitle});

  Widget? leading;
  Widget? title;
  Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      leading: leading,
      title: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: title,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: subtitle,
      ),
    );
  }
}