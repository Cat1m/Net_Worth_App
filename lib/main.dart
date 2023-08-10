import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Net Worth Calculator',
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}

class AppTheme {
  // Định nghĩa chủ đề giao diện tối
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xff222747),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.grey.shade800,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 16),
      ),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    cardColor: const Color(0xff444968),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int assetAmount = 0;
  int liabilitiesAmount = 0;

  // Cập nhật số tiền tài sản
  void _setAssetAmount(int asset) {
    setState(() {
      assetAmount = asset;
    });
  }

  // Cập nhật số tiền nợ
  void _setLiabilitiesAmount(int liabilities) {
    setState(() {
      liabilitiesAmount = liabilities;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Add Your Assets and Liabilities',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 48),
                AmountCard(
                  title: 'Assets',
                  amount: assetAmount,
                  onTap: () => _showAmountDialog(
                      context, 'Assets', assetAmount, _setAssetAmount),
                ),
                AmountCard(
                  title: 'Liabilities',
                  amount: liabilitiesAmount,
                  onTap: () => _showAmountDialog(context, 'Liabilities',
                      liabilitiesAmount, _setLiabilitiesAmount),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          NetworthPage(amount: assetAmount - liabilitiesAmount),
                      fullscreenDialog: true,
                    ),
                  ),
                  child: Text(
                    'Calculate',
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Hiển thị hộp thoại số
  void _showAmountDialog(BuildContext context, String title, int currentAmount,
      Function(int) setAmount) {
    showDialog(
      context: context,
      builder: (context) {
        return NumberInputDialog(
          onTap: setAmount,
          title: title,
          amount: currentAmount,
        );
      },
    );
  }
}

class AmountCard extends StatelessWidget {
  const AmountCard({
    Key? key,
    required this.title,
    required this.amount,
    this.onTap,
  }) : super(key: key);

  final String title;
  final int amount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: 148,
      width: size.width * 0.8,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                amount.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumberInputDialog extends StatefulWidget {
  const NumberInputDialog({
    Key? key,
    required this.onTap,
    required this.title,
    required this.amount,
  }) : super(key: key);

  final Function(int) onTap;
  final String title;
  final int amount;

  @override
  // ignore: library_private_types_in_public_api
  _NumberInputDialogState createState() => _NumberInputDialogState();
}

class _NumberInputDialogState extends State<NumberInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.amount == 0 ? '' : widget.amount.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final outLineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
    );

    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: screenSize.width * 0.7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(color: Colors.grey.shade900),
              autofocus: true,
              onSubmitted: (_) {
                _handleDoneButtonPressed();
              },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                focusedBorder: outLineInputBorder,
                enabledBorder: outLineInputBorder,
                labelStyle: TextStyle(color: Colors.grey.shade600),
                labelText: 'Write amount',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleDoneButtonPressed,
              child: Text(
                'Done',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDoneButtonPressed() {
    if (_controller.text.isNotEmpty) {
      widget.onTap(int.parse(_controller.text));
    } else {
      widget.onTap(0);
    }
    Navigator.of(context).pop();
  }
}

class NetworthPage extends StatelessWidget {
  const NetworthPage({
    Key? key,
    required this.amount,
  }) : super(key: key);

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your total net worth is $amount',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
