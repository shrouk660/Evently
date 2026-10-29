import 'package:evently/core/resources/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../resources/assets_manager.dart';

class Date extends StatefulWidget {
  final void Function(DateTime) onDateSelected;
  final DateTime? selectedDate;
  const Date({super.key, required this.onDateSelected,this.selectedDate});

  @override
  State<Date> createState() => _DateState();


}

class _DateState extends State<Date> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = widget.selectedDate;
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
          StringsManager.eventDate,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: (){
            chooseDate();
          },
          child: Text(selectedDate == null
              ? StringsManager.chooseDate
              : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  DateTime? selectedDate;
  chooseDate()async{
    var temp = await showDatePicker(
        initialDate: selectedDate??DateTime.now(),
        context: context,
        firstDate: DateTime.now() ,
        lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if(temp!=null){
      setState(() => selectedDate = temp);
      widget.onDateSelected(temp);
    }
  }
}
