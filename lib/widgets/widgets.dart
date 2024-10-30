// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:ilugan_passenger_mobile_app/screens/userscreens/busschedules.dart';
// import 'package:ilugan_passenger_mobile_app/screens/userscreens/history.dart';
// import 'package:ilugan_passenger_mobile_app/screens/userscreens/profile.dart';
import 'package:ilugan_passsenger/screens/userscreens/busschedules.dart';
import 'package:ilugan_passsenger/screens/userscreens/history.dart';
import 'package:ilugan_passsenger/screens/userscreens/profile.dart';

class Buttons extends StatelessWidget {
  Buttons({super.key, required this.onPressed, required this.name});

  final VoidCallback onPressed;
  String name = "";

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.sizeOf(context).width - 100, 60),
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.black,
          elevation: 9),
      child: TextContent(
          name: name,
          fontsize: 20,
          fontweight: FontWeight.bold,
          fcolor: const Color.fromARGB(255, 65, 26, 23)),
    );
  }
}

class EButtons extends StatelessWidget {
  EButtons(
      {super.key,
      required this.onPressed,
      required this.name,
      this.bcolor,
      this.tcolor,
      this.elevation,
      });

  final VoidCallback onPressed;
  String name = "";
  Color? bcolor;
  Color? tcolor;
  double? elevation;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.sizeOf(context).width - 150, 60),
          backgroundColor: bcolor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.black,
          elevation: elevation),
      child: TextContent(
          name: name,
          fontsize: 20,
          fontweight: FontWeight.bold,
          fcolor: tcolor),
    );
  }
}

class TextContent extends StatelessWidget {
  TextContent(
      {super.key,
      required this.name,
      this.fontsize,
      this.fontweight,
      this.fcolor});

  final String name;
  double? fontsize = 0;
  FontWeight? fontweight;
  Color? fcolor;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: GoogleFonts.firaSans(
        fontSize: fontsize,
        fontWeight: fontweight,
        color: fcolor,
      ),
    );
  }
}

class Tfields extends StatelessWidget {
  Tfields(
      {super.key,
      required this.field_controller,
      this.suffixicon,
      this.label,
      this.prefix});

  var field_controller = TextEditingController();
  IconData? suffixicon;
  String? label = "";
  Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: field_controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill up this field';
        }
        return null;
      },
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefix: prefix,
        fillColor: Colors.transparent,
        filled: true,
        suffixIcon: Icon(
          suffixicon,
          color: Colors.black,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}

class LoginTfields extends StatelessWidget {
  LoginTfields(
      {super.key,
      required this.field_controller,
      this.suffixicon,
      this.label,
      this.prefix,});

  var field_controller = TextEditingController();
  IconData? suffixicon;
  String? label = "";
  Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: field_controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill up this field';
        }
        return null;
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefix: prefix,
        fillColor: Colors.transparent,
        filled: true,
        suffixIcon: Icon(
          suffixicon,
          color: Colors.white,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.yellow,
            width: 1.0,
          ),
        ),
        errorStyle: const TextStyle(
          color: Colors.yellow
        )
      ),
    );
  }
}

class PTfields extends StatelessWidget {
  PTfields(
      {super.key,
      required this.field_controller,
      this.suffixicon,
      this.label,
      this.prefix});

  var field_controller = TextEditingController();
  IconData? suffixicon;
  String? label = "";
  Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // maxLines: 10,
      // minLines: 10,
      maxLength: 10,
      // maxLines: 10,
      keyboardType: TextInputType.number,
      controller: field_controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill up this field';
        }
        return null;
      },
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefix: prefix,
        fillColor: Colors.transparent,
        filled: true,
        suffixIcon: Icon(
          suffixicon,
          color: Colors.black,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}

class Password_Tfields extends StatefulWidget {
  Password_Tfields({
    super.key,
    required this.field_controller,
    required this.showpassIcon,
    required this.hidepassIcon,
    required this.showpass,
    // required this.togglepass
  });

  var field_controller = TextEditingController();
  IconData? showpassIcon;
  IconData? hidepassIcon;
  bool showpass;

  @override
  State<Password_Tfields> createState() => _Password_TfieldsState();
}

class _Password_TfieldsState extends State<Password_Tfields> {
  // final VoidCallback togglepass;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.field_controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill up this field';
        }
        return null;
      },
      obscureText: widget.showpass,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        filled: true,
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                widget.showpass = !widget.showpass;
              });
            },
            icon: Icon(
              widget.showpass ? widget.hidepassIcon : widget.showpassIcon,
              color: Colors.black,
            )),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}

class LoginPassTfields extends StatefulWidget {
  LoginPassTfields({
    super.key,
    required this.field_controller,
    required this.showpassIcon,
    required this.hidepassIcon,
    required this.showpass,
  });

  var field_controller = TextEditingController();
  IconData? showpassIcon;
  IconData? hidepassIcon;
  bool showpass;

  @override
  State<LoginPassTfields> createState() => _LoginPassTfieldsState();
}

class _LoginPassTfieldsState extends State<LoginPassTfields> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.field_controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill up this field';
        }
        return null;
      },
      obscureText: widget.showpass,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        filled: true,
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                widget.showpass = !widget.showpass;
              });
            },
            icon: Icon(
              widget.showpass ? widget.hidepassIcon : widget.showpassIcon,
              color: Colors.white,
            )),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.yellow,
            width: 1.0,
          ),
        ),
        errorStyle: const TextStyle(
          color: Colors.yellow
        )
      ),
      
    );
  }
}

class AppDrawer extends StatefulWidget {
  AppDrawer(
      {super.key,
      required this.username,
      required this.email,
      required this.logoutfunc});

  String username;
  String email;
  VoidCallback logoutfunc;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage('assets/icons/pfp.png'),
                        ),
                        const Gap(10),
                        Column(
                          children: [
                            const Gap(43),
                            TextContent(
                              name: widget.username.toString(),
                              fontweight: FontWeight.bold,
                            ),
                            TextContent(
                              name: widget.email.toString(),
                              fontsize: 12,
                            )
                          ],
                        )
                      ],
                    )),
                ListTile(
                  title: TextContent(
                    name: 'Bus Schedules',
                    fcolor: const Color.fromARGB(255, 104, 103, 103),
                  ),
                  leading: const Icon(
                    Icons.bus_alert,
                    color: Colors.red,
                  ),
                  hoverColor: Colors.red,
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> BusSchedulesScreen()));
                  },
                ),
                const Divider(),
                ListTile(
                  title: TextContent(
                    name: 'Passenger Profile',
                    fcolor: const Color.fromARGB(255, 104, 103, 103),
                  ),
                  leading: const Icon(
                    Icons.person,
                    color: Colors.red,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const ProfileScreen()));
                  },
                  hoverColor: Colors.green,
                ),
                const Divider(),
                ListTile(
                  title: TextContent(
                    name: 'Transaction History',
                    fcolor: const Color.fromARGB(255, 104, 103, 103),
                  ),
                  leading: const Icon(
                    Icons.history,
                    color: Colors.red,
                  ),
                  hoverColor: Colors.green,
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const TransactionHistoryScreen()));
                  },
                ),
                const Divider(),
                ListTile(
                  title: TextContent(
                    name: 'About Us',
                    fcolor: const Color.fromARGB(255, 104, 103, 103),
                  ),
                  leading: const Icon(
                    Icons.error_sharp,
                    color: Colors.red,
                  ),
                  hoverColor: Colors.red,
                ),
              ],
            ),
          ),
          ListTile(
            onTap: widget.logoutfunc,
            title: TextContent(
              name: 'Log Out',
              fcolor: const Color.fromARGB(255, 104, 103, 103),
            ),
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            hoverColor: Colors.red,
          ),
        ],
      ),
    );
  }
}

class ProfileTfields extends StatefulWidget {
  ProfileTfields(
      {super.key,
      // required this.field_controller,
      this.suffixicon,
      this.label,
      this.prefix,
      this.data,
      this.isreadable});

  // var field_controller = TextEditingController();
  IconData? suffixicon;
  String? label = "";
  Widget? prefix;
  String? data;
  bool? isreadable;

  @override
  State<ProfileTfields> createState() => _ProfileTfieldsState();
}

class _ProfileTfieldsState extends State<ProfileTfields> {
  bool togglereadonly = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.center,
      readOnly: togglereadonly,
      style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill up this field';
        }
        return null;
      },
      initialValue: widget.data,
      decoration: InputDecoration(
          prefix: widget.prefix,
          fillColor: Colors.transparent,
          filled: true,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                togglereadonly = !togglereadonly;
              });
            },
            icon: Icon(
              widget.suffixicon,
              color: Colors.black,
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          label: TextContent(
            name: '${widget.label}',
            fcolor: Colors.black,
          )),
    );
  }
}

class BusDetails extends StatelessWidget {
  const BusDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // return ScaffoldMessenger();
  }
}
