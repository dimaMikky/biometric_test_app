// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocalAuthentication auth = LocalAuthentication();
  String _biometricAuthorized = 'Not Authorized';
  String _secretBoimetricKey = '';
  bool _isAuthenticating = false;

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _biometricAuthorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      setState(() {
        _isAuthenticating = false;
        _biometricAuthorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _biometricAuthorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    final String secretKey = authenticated
        ? 'QWE677VBN345TT'
        : 'You don\t have permission to see secret key';
    setState(() {
      _biometricAuthorized = message;
      _secretBoimetricKey = secretKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Biometric test App'),
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 30),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 200),
                Column(
                  children: [
                    Text('Current biometrics State: $_biometricAuthorized\n'),
                    ElevatedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_isAuthenticating
                              ? 'Cancel'
                              : 'Authenticate by biometrics '),
                          Icon(Icons.fingerprint),
                        ],
                      ),
                      onPressed: _authenticateWithBiometrics,
                    ),
                    SizedBox(height: 7),
                    Text('Yor secret Key is: $_secretBoimetricKey'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
