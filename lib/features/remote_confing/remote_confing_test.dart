import 'package:dhikru_linda_flutter/helpers/ui_helpers.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RemoteConfingTest extends StatefulWidget {
  const RemoteConfingTest({super.key});

  @override
  State<RemoteConfingTest> createState() => _RemoteConfingTestState();
}

class _RemoteConfingTestState extends State<RemoteConfingTest> {
  @override
  bool isLoading = false;

  final _remoteConfig = FirebaseRemoteConfig.instance;

  void initState() {
    // TODO: implement initState
    _initREmotConfi();
    super.initState();
  }
  _initREmotConfi()async{
    setState(() {
      isLoading = true;
    });
    // default setup
    _remoteConfig.setDefaults({
      'name': 'ferdaus',
      'age':25,
      'job':'flutter developer'
    });
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10), minimumFetchInterval: Duration(seconds: 10)));
    await _remoteConfig.fetchAndActivate();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading? CircularProgressIndicator():Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Center(child: ElevatedButton(
                onPressed: (){}, child: Text('Name: ${_remoteConfig.getString('name')}'))),
            UIHelper.verticalSpace(10.h),
            Center(child: ElevatedButton(onPressed: (){}, child: Text('Age: ${_remoteConfig.getInt('age')}'))),
            UIHelper.verticalSpace(10.h),
            Center(child: ElevatedButton(onPressed: (){}, child: Text('Job: ${_remoteConfig.getString('job')} '))),

          ],
        ),
      ),
    );
  }
}
