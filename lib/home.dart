import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:bdk_flutter/bdk_flutter.dart';

final electrumConfig = BlockchainConfig.electrum(
  config: ElectrumConfig(
    url: 'ssl://electrum.blockstream.info:60002',
    retry: 5,
    stopGap: 10,
  ),
);

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String w1Descriptor;
  late String w2Descriptor;
  late String w3Descriptor;

  // single sig
  late BdkFlutter wallet0;

  //multi sig wallets
  late BdkFlutter wallet1;
  late BdkFlutter wallet2;
  late BdkFlutter wallet3;

  String? newTransaction;
  String? signedTransaction;

  BdkFlutter? activeWallet;

  bool loading = false;

  int? selectedWallet;

  @override
  void initState() {
    super.initState();

    generateWallet();
  }

  void generateWallet() async {
    setState(() {
      loading = true;
    });

    w1Descriptor =
        "wsh(thresh(2,pk(tprv8ZgxMBicQKsPdr35gCR6t8A3xXYCR1J5pTh4dRgNFuZBZam3gS23aQb7Fu6TXBNjfR3RDLwRyryfDMpxVrjXwyYyXCt6pN96woCijYpsQSA/84'/1'/0'/0/*),s:pk([1c4b5679/84'/1'/0'/0]tpubDF73Ty8r1wBnpYVVT6hycUV6nzBtwRg5j9HMXMawE5wU7keNmndG76nUvtWxkppeKFziFMA9yu92PvSNJ3mErFQ6Ljo462wrWT9RK7E9Ph3/*),s:pk([ac27cf86/84'/1'/0'/0]tpubDF7WQKDmr2ux6mjt93KYpe5YTU8rgtd5FipT9mMfPJziAa89FCAsySWPwiavvJ6a25YLKiSXGKkD374WpCHLFR1GDDUvesn4aJ2ZiLsQMuX/*)))";
    w2Descriptor =
        "wsh(thresh(2,pk([257ca1ad/84'/1'/0'/0]tpubDDwnUUipt5AJ7LC5UVyRgQC7Hpy5k3RrhzWaC9R1iQVcDX98GcUMGjosSutAfNE4vDZTqbwfE5G5DgE1ezNMuxs244XWGQk12KTdHXYjBnc/*),s:pk(tprv8ZgxMBicQKsPfR1mM5UX3kX5iFsNTJntbcdMLovDN6XqUjLDCARzynMvKbMe2Bv1wgNJATK6hEYWAUDwih6GzGXAgW98K7aWR51x6hzZUmh/84'/1'/0'/0/*),s:pk([ac27cf86/84'/1'/0'/0]tpubDF7WQKDmr2ux6mjt93KYpe5YTU8rgtd5FipT9mMfPJziAa89FCAsySWPwiavvJ6a25YLKiSXGKkD374WpCHLFR1GDDUvesn4aJ2ZiLsQMuX/*)))";
    w3Descriptor =
        "wsh(thresh(2,pk([257ca1ad/84'/1'/0'/0]tpubDDwnUUipt5AJ7LC5UVyRgQC7Hpy5k3RrhzWaC9R1iQVcDX98GcUMGjosSutAfNE4vDZTqbwfE5G5DgE1ezNMuxs244XWGQk12KTdHXYjBnc/*),s:pk([1c4b5679/84'/1'/0'/0]tpubDF73Ty8r1wBnpYVVT6hycUV6nzBtwRg5j9HMXMawE5wU7keNmndG76nUvtWxkppeKFziFMA9yu92PvSNJ3mErFQ6Ljo462wrWT9RK7E9Ph3/*),s:pk(tprv8ZgxMBicQKsPe9omLYsgf19pTESKgMsFe8o7h3p5xxqi5nWUTMNJqxu9dBpSTf4xcNoVxPQhdSc2Bn8fzUzTR5Bo8GMp2MD4AVA3YrfQB2t/84'/1'/0'/0/*)))";

    log(w1Descriptor);
    log('------------------------');
    log(w2Descriptor);
    log('------------------------');
    log(w3Descriptor);

    wallet0 = BdkFlutter();
    wallet1 = BdkFlutter();
    wallet2 = BdkFlutter();
    wallet3 = BdkFlutter();

    // SINGLE SIG WALLET
    await wallet0.createWallet(
      network: Network.TESTNET,
      mnemonic:
          'walk laundry nest toy deer roast wreck pipe solid orient around sword',
      blockchainConfig: electrumConfig,
    );
    log('------------------------wallet 0');

    // MULTI SIG WALLETS
    await wallet1.createWallet(
      network: Network.TESTNET,
      descriptor: w1Descriptor,
      blockchainConfig: electrumConfig,
    );
    log('------------------------wallet 1');

    await wallet2.createWallet(
      network: Network.TESTNET,
      descriptor: w2Descriptor,
      blockchainConfig: electrumConfig,
    );
    log('------------------------wallet 2');

    await wallet3.createWallet(
      network: Network.TESTNET,
      descriptor: w3Descriptor,
      blockchainConfig: electrumConfig,
    );
    log('------------------------wallet 3');

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<int>(
              hint: const Text(
                'Select Wallet',
              ),
              value: selectedWallet,
              items: const [
                DropdownMenuItem<int>(
                  value: 0,
                  child: Text('0'),
                ),
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('1'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('2'),
                ),
                DropdownMenuItem<int>(
                  value: 3,
                  child: Text('3'),
                ),
              ],
              onChanged: (val) => setState(() {
                log('selected wallet: $val');
                selectedWallet = val ?? 1;

                activeWallet = selectedWallet == 0
                    ? wallet0
                    : selectedWallet == 1
                        ? wallet1
                        : selectedWallet == 2
                            ? wallet2
                            : wallet3;
              }),
            ),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      if (activeWallet == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Select a wallet first'),
                          ),
                        );
                        return;
                      }
                      final address = await activeWallet!.getNewAddress();

                      log(address);
                    },
              child: const Text(
                'Get Address',
              ),
            ),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      if (activeWallet == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Select a wallet first'),
                          ),
                        );
                        return;
                      }

                      await wallet1.syncWallet();
                      log('syncing done');

                      final balance = await activeWallet!.getBalance();

                      log(balance.total.toString());
                    },
              child: const Text(
                'Get Balance',
              ),
            ),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      if (activeWallet == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Select a wallet first'),
                          ),
                        );
                        return;
                      }
                      await activeWallet!.syncWallet();

                      newTransaction = await activeWallet!.createTx(
                        recipient: 'tb1ql7w62elx9ucw4pj5lgw4l028hmuw80sndtntxt',
                        amount: 400,
                        feeRate: 1,
                      );

                      log(newTransaction!);
                    },
              child: const Text(
                'Create Transaction',
              ),
            ),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      if (activeWallet == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Select a transaction first'),
                          ),
                        );
                        return;
                      }

                      if (newTransaction == null) {}

                      await activeWallet!.syncWallet();

                      signedTransaction =
                          await activeWallet!.signTx(psbt: newTransaction!);

                      log(signedTransaction!);

                      log('signed');
                    },
              child: const Text(
                'Sign Transaction',
              ),
            ),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      if (signedTransaction == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Create a Signed Transaction first'),
                          ),
                        );
                        return;
                      }
                      await activeWallet!.syncWallet();

                      final t1 = await activeWallet!
                          .broadcastTx(sbt: signedTransaction!);

                      log(t1);
                    },
              child: const Text(
                'Broadcast Transaction',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
