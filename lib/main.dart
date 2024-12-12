import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CountDownScreen(),
    );
  }
}

// class CountDownScreen2 extends StatefulWidget {
//   const CountDownScreen2({super.key});
//
//   @override
//   State<CountDownScreen2> createState() => _CountDownScreen2State();
// }
//
// class _CountDownScreen2State extends State<CountDownScreen2>
//     with TickerProviderStateMixin {
//   static const timeoutInSeconds = 10;
//   late Ticker ticker;
//   Duration _elapsed = Duration.zero;
//   double get _countdownProgress =>
//       _elapsed.inMilliseconds / (1000 * timeoutInSeconds.toDouble());
//   @override
//   void initState() {
//     super.initState();
//     ticker = createTicker((elapsed) {
//       setState(() => _elapsed = elapsed);
//       if (_elapsed.inSeconds >= timeoutInSeconds) {
//         ticker.stop();
//       }
//     });
//     ticker.start();
//   }
//
//   @override
//   void dispose() {
//     ticker.dispose();
//     super.dispose();
//   }
//
//   void _restart() {
//     ticker.stop();
//     ticker.start();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: 150,
//               width: 150,
//               child: CircularProgressIndicator(
//                 value: _countdownProgress,
//                 valueColor: AlwaysStoppedAnimation(Colors.deepPurple.shade300),
//                 backgroundColor: Colors.deepPurple,
//                 strokeCap: StrokeCap.round,
//                 strokeWidth: 8,
//               ),
//             ),
//             SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _restart,
//               child: Text('Restart'),
//             ),
//           ]),
//     ));
//   }
// }

class CountDownScreen extends StatefulWidget {
  const CountDownScreen({super.key});

  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen>
    with TickerProviderStateMixin {
  static const timeoutInSeconds = 10;
  late Ticker ticker;
  Duration _elapsed = Duration.zero;
  double get _countdownProgress =>
      _elapsed.inMilliseconds / (1000 * timeoutInSeconds.toDouble());
  int get _remainingTime => max(0, timeoutInSeconds - _elapsed.inSeconds);

  @override
  void initState() {
    super.initState();
    ticker = createTicker((elapsed) {
      setState(() => _elapsed = elapsed);
      if (_elapsed.inSeconds >= timeoutInSeconds) {
        ticker.stop();
      }
    });
    ticker.start();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  void _restart() {
    ticker.stop();
    ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CountdownRenderer(
                remainingTime: _remainingTime,
                progress: _countdownProgress,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _restart,
                child: Text('Restart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountdownRenderer extends StatelessWidget {
  const CountdownRenderer({
    super.key,
    required this.remainingTime,
    required this.progress,
  });

  final double progress;
  final int remainingTime;
  final color = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TimerRing(
            progress: progress,
            foregroundColor: color.shade700,
            backgroundColor: color.shade400,
          ),
          Align(
            alignment: Alignment.center,
            child: RemainingTimeText(
              remainingTime: remainingTime,
              color: color.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class TimerRing extends StatelessWidget {
  const TimerRing({
    super.key,
    required this.progress,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  final double progress;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final strokeWidth = constraints.maxWidth / 15;
        return AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: EdgeInsets.all(strokeWidth / 2.0),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: CircularProgressIndicator(
                value: progress,
                valueColor: AlwaysStoppedAnimation(backgroundColor),
                backgroundColor: foregroundColor,
                strokeCap: StrokeCap.round,
                strokeWidth: strokeWidth,
              ),
            ),
          ),
        );
      },
    );
  }
}

class RemainingTimeText extends StatelessWidget {
  const RemainingTimeText({
    super.key,
    required this.remainingTime,
    required this.color,
  });

  final int remainingTime;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxHeight;
        return Text(remainingTime.toString(),
            style: TextStyle(fontSize: width / 3, color: color));
      },
    );
  }
}
