import 'package:flutter/material.dart';

class MPMCButton extends StatelessWidget {
  final Function onPressedCallback;
  final String btnText;
  final Color btnColor;
  final bool isRounded;

  const MPMCButton(
      {Key key,
      @required this.onPressedCallback,
      @required this.btnText,
      @required this.btnColor,
      this.isRounded = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: isRounded ? Radius.circular(70) : Radius.circular(0),
          bottomRight: isRounded ? Radius.circular(70) : Radius.circular(0)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: MaterialButton(
          disabledColor: Theme.of(context).highlightColor,
          elevation: 5,
          minWidth: double.infinity,
          color: btnColor,
          onPressed: onPressedCallback,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                btnText.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(color: Colors.white),
              )),
        ),
      ),
    );
  }
}
