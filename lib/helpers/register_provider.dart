
import 'package:dhikru_linda_flutter/provider/address.dart';
import 'package:dhikru_linda_flutter/provider/auth_provider.dart';
import 'package:dhikru_linda_flutter/provider/email.dart';
import 'package:provider/provider.dart';

var providers = [
  //New
  ChangeNotifierProvider<AuthProvider>(create: ((context) => AuthProvider())),
  // Old
  ChangeNotifierProvider<EmailProvider>(create: ((context) => EmailProvider())),
  ChangeNotifierProvider<AddressProvider>(
    create: ((context) => AddressProvider()),
  ),
  
];
