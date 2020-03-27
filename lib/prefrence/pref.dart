import 'package:flutter/material.dart';
import 'package:mpmc/global/themes/bloc/bloc.dart';
import 'package:mpmc/global/themes/custom_themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Preference extends StatefulWidget {
  @override
  _PreferenceState createState() => _PreferenceState();
}

class _PreferenceState extends State<Preference> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MPMC',
          style: Theme.of(context).textTheme.display1,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: AppTheme.values.length,
        itemBuilder: (context, index) {
          final item = AppTheme.values[index];

          return Card(
            color: appThemes[item].primaryColor,
            child: ListTile(
              title:
                  Text(item.toString(), style: appThemes[item].textTheme.body1),
              onTap: () => BlocProvider.of<ThemeBloc>(context)
                  .dispatch(ThemeChaned(theme: item)),
            ),
          );
        },
      ),
    );
  }
}
