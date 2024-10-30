import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilugan_passsenger/screens/userscreens/homescreen.dart';
// import 'package:ilugan_passenger_mobile_app/screens/userscreens/homescreen.dart';
// import 'package:ilugan_passenger_mobile_app/widgets/widgets.dart';
import 'package:ilugan_passsenger/widgets/widgets.dart';

class AcceptedAccountype extends StatelessWidget {
  const AcceptedAccountype({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Spacer(),
          TextContent(name: 'Account Set Up Finished!', fontsize: 30, fontweight: FontWeight.bold,),
          TextContent(name: 'You can now use Ilugan!', fontsize: 20, fontweight: FontWeight.bold,),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: EButtons(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const HomeScreen()));
            }, name: 'Finish', elevation: 10, bcolor: Colors.redAccent, tcolor: Colors.white,),
          ),
          const Gap(10)
        ],
      ),
    );
  }
}