import 'package:flutter/material.dart';
import 'package:social_test/Constants/color.dart';
import 'package:social_test/Shared%20Prefrence/SharedPref.dart';

Widget DefaultForm(
    {required String label,
    bool enabled = true,
    bool isDark = false,
    onChanged,
  IconData?  dtaPrefIcon,
    suff_func,
  Icon?  dtaSufIcon,
     controller,
String? Function(String?)?  validateor,
    onFieldSubmitted,
  bool  Obscure = false,
    type}) {
  return SizedBox(
    // width: 400,
    height: 70,

    child: TextFormField(
      
      
      // focusNode: FocusNode(),

      enabled: enabled,
      onChanged: onChanged,
      keyboardType: type,
      // readOnly: readOnly,

      ///عدل كسم الانواع دي
      obscureText: Obscure,
      onFieldSubmitted: onFieldSubmitted,
      validator: validateor,
      controller: controller,
      style: isDark
          ? const TextStyle(color: Colors.white, fontFamily: '')
          : const TextStyle(fontFamily: 'no'),
      decoration: InputDecoration(
        
        label:
            Text(label, style: TextStyle(color: isDark ? Colors.white : null)),
        border: const OutlineInputBorder(),
        suffixIcon: dtaSufIcon == null
            ? null
            : IconButton(
                icon: dtaSufIcon,
                onPressed: suff_func,
              ),
        prefixIcon: dtaPrefIcon == null
            ? null
            : Icon(
                dtaPrefIcon,
                color: isDark ? Colors.white : null,
              ), // Use prefixIcon instead of prefix
      ),
    ),
  );
}

Widget DefaultButton(
    {required ButtonFunc,
    required isText,
String ? Title,
    ButtonIcon,
    required double ButtonWidth}) {
  return ButtonWidth == 0
      ? MaterialButton(
          minWidth: 0,
          onPressed: ButtonFunc,
          child: isText == null
              ? null
              : isText
                  ? Title == null
                      ? null
                      : Text(
                          Title,
                          style: const TextStyle(color: Colors.white),
                        )
                  : ButtonIcon,
        )
      : Container(
          decoration: BoxDecoration(
              color: Additional2, borderRadius: BorderRadius.circular(20)),
          height: 50,
          width: ButtonWidth,
          child: MaterialButton(
            onPressed: ButtonFunc,
            child: isText == null
                ? null
                : isText
                    ? Title == null
                        ? null
                        : Text(
                            Title,
                            style: const TextStyle(color: Colors.white),
                          )
                    : ButtonIcon,
          ),
        );
}

NavigatReplace(context, TargetPage) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => TargetPage,
  ));
}

Navigat(context, TargetPage) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => TargetPage,
  ));
}

Widget DefaultTextButton({required onPressed, required String text,Color color=Colors.black}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(color: color),
    ),
  );
}

Snake({required titleWidget, required context, required EnumColor}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: SnakeColor(EnumColor),
    duration: const Duration(seconds: 2),
    content: titleWidget,
  ));
}

enum Messages { Success, Warning, Error }

Color SnakeColor(Messages EnumColor) {
  switch (EnumColor) {
    case Messages.Success:
      return Colors.green;

    case Messages.Warning:
      return Colors.yellow;

    case Messages.Error:
      return Colors.red;

    default:
      return Colors.grey;
  }
}

void SignOut({required String key}) {
  Cache.RemoveValue(key: key);
}
