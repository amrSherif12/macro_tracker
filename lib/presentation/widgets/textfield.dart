import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/colors.dart';

class TextFieldBuilder extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData? iconData;
  final bool? isMultiLine;
  final bool? enabled;
  final bool? isColored;
  final bool? isFilled;
  final bool? isOnlyNumbers;
  final void Function(String)? onChanged;

  const TextFieldBuilder({
    Key? key,
    required this.hint,
    required this.label,
    required this.controller,
    this.isMultiLine,
    this.isFilled,
    this.isOnlyNumbers,
    this.onChanged,
    this.enabled,
    this.isColored,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: isOnlyNumbers != null
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow((RegExp('[.1234567890]'))),
            ]
          : null,
      onChanged: onChanged,

      controller: controller,
      enabled: enabled == false ? false : true,
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 0.5, color: Colors.grey[700]!),
        ),
        prefixIcon: iconData != null
            ? Icon(
                iconData,
                color: isColored == true ? ConstColors.secOff : Colors.white,
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: isColored == true ? ConstColors.secOff : Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: isColored == true ? ConstColors.secOff : Colors.white,
          ),
        ),
        label: Text(label),
        labelStyle: TextStyle(
          color: isColored == true ? ConstColors.secOff : Colors.white,
          fontFamily: 'f',
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: isColored == true ? ConstColors.secOff : Colors.white,
          fontFamily: 'f',
        ),
      ),
      style: const TextStyle(fontFamily: 'f', color: Colors.white),
      cursorColor: isColored == true ? ConstColors.secOff : Colors.white,
      keyboardType: isOnlyNumbers == true
          ? const TextInputType.numberWithOptions(decimal: true)
          : isMultiLine == true
          ? TextInputType.multiline
          : TextInputType.text,
      maxLines: isMultiLine == true ? 20 : 1,
      minLines: 1,
    );
  }
}

class FilledTextFieldBuilder extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData? iconData;
  final bool? isMultiLine;
  final bool? enabled;
  final bool? isColored;
  final bool? isFilled;
  final bool? isOnlyNumbers;
  final void Function(String)? onChanged;

  const FilledTextFieldBuilder({
    Key? key,
    required this.hint,
    required this.label,
    required this.controller,
    this.isMultiLine,
    this.isFilled,
    this.isOnlyNumbers,
    this.onChanged,
    this.enabled,
    this.isColored,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: isOnlyNumbers != null
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow((RegExp('[.1234567890]'))),
            ]
          : null,
      onChanged: onChanged,
      controller: controller,
      enabled: enabled == false ? false : true,
      decoration: InputDecoration(
        fillColor: Colors.grey[850],
        filled: true,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 0.5, color: Colors.grey[850]!),
        ),
        prefixIcon: iconData != null
            ? Icon(
                iconData,
                color: isColored == true ? ConstColors.secOff : Colors.white,
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 0.5, color: Colors.grey[850]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 0.5, color: Colors.grey[850]!),
        ),
        label: Text(label),
        labelStyle: TextStyle(
          color: isColored == true ? ConstColors.secOff : Colors.white,
          fontFamily: 'f',
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: isColored == true ? ConstColors.secOff : Colors.white,
          fontFamily: 'f',
        ),
      ),
      style: const TextStyle(fontFamily: 'f', color: Colors.white),
      cursorColor: isColored == true ? ConstColors.secOff : Colors.white,
      keyboardType: isOnlyNumbers == true
          ? const TextInputType.numberWithOptions(decimal: true)
          : isMultiLine == true
          ? TextInputType.multiline
          : TextInputType.text,
      maxLines: isMultiLine == true ? 20 : 1,
      minLines: 1,
    );
  }
}

class ObscureTextFieldBuilder extends StatefulWidget {
  bool obscureText;
  final TextEditingController controller;
  Widget icon;
  final String label;
  final String hint;
  final IconData iconData;

  ObscureTextFieldBuilder({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.icon,
    required this.label,
    required this.hint,
    required this.iconData,
  });

  @override
  State<ObscureTextFieldBuilder> createState() =>
      _ObscureTextFieldBuilderState();
}

class _ObscureTextFieldBuilderState extends State<ObscureTextFieldBuilder> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.iconData, color: Colors.white),
        suffixIcon: IconButton(
          color: Colors.white,
          onPressed: () {
            setState(() {});
            widget.obscureText = !widget.obscureText;
            if (widget.obscureText == true) {
              widget.icon = const Icon(Icons.visibility_off_outlined);
            } else {
              widget.icon = const Icon(Icons.visibility_outlined);
            }
          },
          icon: widget.icon,
        ),
        fillColor: Colors.grey[850],
        filled: true,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 0.5, color: Colors.grey[850]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 0.5, color: Colors.grey[850]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 0.5, color: Colors.grey[850]!),
        ),
        label: Text(widget.label),
        labelStyle: TextStyle(color: Colors.white, fontFamily: 'f'),
        hintText: widget.hint,
        hintStyle: TextStyle(color: Colors.white, fontFamily: 'f'),
      ),
      style: const TextStyle(fontFamily: 'f', color: Colors.white),
      cursorColor: Colors.white,
    );
  }
}

class UnderLineTextField extends StatelessWidget {
  final String label;
  final TextInputType keyboard;
  final TextEditingController controller;

  const UnderLineTextField({
    Key? key,
    required this.label,
    required this.keyboard,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: TextField(
        inputFormatters: <TextInputFormatter>[
          if (keyboard == TextInputType.number)
            FilteringTextInputFormatter.digitsOnly
          else if (keyboard ==
              const TextInputType.numberWithOptions(decimal: true))
            FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
        ],
        keyboardType: keyboard,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.greenAccent),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.greenAccent),
          ),
          label: Text(label),
          labelStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'F',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        style: const TextStyle(fontFamily: 'F', color: Colors.white),
        cursorColor: Colors.white,
      ),
    );
  }
}
