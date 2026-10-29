import 'package:evently/core/resources/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../resources/assets_manager.dart';

class Time extends StatefulWidget {
  final void Function(TimeOfDay) onTimeSelected;
  final TimeOfDay? selectedTime;
  const Time({super.key, required this.onTimeSelected ,this.selectedTime});

  @override
  State<Time> createState() => _TimeState();
}

class _TimeState extends State<Time> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedTime = widget.selectedTime;
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          AssetsManager.date,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.primary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          StringsManager.eventTime,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: (){
            chooseTime();
          },
          child: Text(selectedTime == null
              ? StringsManager.chooseTime
              : selectedTime!.format(context),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  TimeOfDay? selectedTime;
  chooseTime()async{
    var temp= await showTimePicker(
        context: context,
        initialTime: selectedTime??TimeOfDay.now()
    );
    if(temp!=null){
      setState(() => selectedTime = temp);
      widget.onTimeSelected(temp);
    }

  }
}
