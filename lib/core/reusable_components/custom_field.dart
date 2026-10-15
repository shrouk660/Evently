
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources/assets_manager.dart';

class CustomField extends StatefulWidget {
  final String hint;
  final String? prefixPath;
  final TextEditingController controller;
  final TextInputType keyboard;
  final String? Function(String?) validation;
  final bool isPassword;
  final int maxLines;
  const CustomField(
      {super.key,
        required this.validation,
        this.isPassword = false,
        required this.keyboard,
        required this.hint,
        this.prefixPath,
        required this.controller,
        this.maxLines = 1,
      });

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  bool visibleOff = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboard,
      controller:widget.controller,
      validator: widget.validation,
      obscureText: widget.isPassword?visibleOff:false,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary
              )
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary
              )
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary
              )
          ),
          filled: true,
          fillColor: Theme
              .of(context)
              .colorScheme
              .onPrimaryContainer,
          hintStyle: Theme
              .of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
              fontSize: 14
          ),
          prefixIcon: widget.prefixPath == null
              ? null
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(widget.prefixPath!),
          ),
          prefixIconConstraints: widget.prefixPath == null
              ? null
              : BoxConstraints.tight(const Size(40, 40)),
          suffixIcon: widget.isPassword?IconButton(
              onPressed: () {
                setState(() {
                  visibleOff = !visibleOff;
                });
              },
              icon: SvgPicture.asset(
                  height: 24,
                  width: 24,
                  visibleOff?AssetsManager.visibleOff:AssetsManager.visibleOn))
              :null,
          hintText: widget.hint
      ),
    );
  }
}
