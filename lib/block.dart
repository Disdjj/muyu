import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'bubble.dart';
import 'state.dart';

const String _svgAsset = "assets/image/muyu.svg"; // 传入SVG资源路径
const String _audioAsset = "audio/muyu.mp3"; // 传入音频资源路径

class BlockWidget extends StatefulWidget {
  @override
  _BlockState createState() => _BlockState();
}

class _BlockState extends State<BlockWidget> with TickerProviderStateMixin {
  Timer? _timer;
  bool _autoTap = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  final AudioPlayer _audioPlayer = AudioPlayer(); // 添加AudioPlayer的实例
  final Set<BubbleWidget> _bubbles = {};
  var assetSource = AssetSource(_audioAsset);

  @override
  void initState() {
    super.initState();
    // 初始化AudioPlayer
    // 初始化动画控制器
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // 创建非线性的放大缩小动画
    _animation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    // 监听动画，当开始时播放音频
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _playAudio();
      }
    });
  }

  void _playAudio() async {
    await _audioPlayer.play(assetSource);
  }

  void _addBubble() {
    // 添加一个新的气泡
    AnimationController bubbleController = AnimationController(
      duration: const Duration(milliseconds: 1000), // 可以根据需要设置气泡动画的时长
      vsync: this,
    );
    var bubbleWidget = BubbleWidget(controller: bubbleController);
    setState(() {
      _bubbles.add(bubbleWidget);
    });

    // 气泡动画结束后清理控制器并移除气泡
    bubbleController.forward().whenComplete(() {
      setState(() {
        _bubbles.remove(bubbleWidget);
      });
      bubbleController.dispose();
    });
  }

  void _onTap() {
    _autoTap = false;

    _realTap();
  }

  void _realTap() {
    // 判断动画是否正在播放
    if (_controller.isAnimating) {
      // 判断动画是否已经到达放大极限
      if (_controller.value < 1.0) {
        // 如果动画在放大但尚未完成，则不进行任何操作让其继续放大
        return;
      }
    }

    // 如果动画没在播放或已完成，则重新开始放大动画
    _controller.forward(from: 0.0);

    // 添加气泡
    _addBubble();
    // 如果动画没在播放或已完成，则重新开始放大动画
    _controller.forward(from: 0.0);

    // 在这里添加计数
    Storage.incrementCounter('counterKey');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: _onTap,
          onLongPress: () {
            if (_autoTap) {
              return;
            } else {
              _autoTap = true;
              _timer?.cancel();
              _timer = Timer.periodic(Duration(milliseconds: 1500), (timer) {
                if (!_autoTap) {
                  _timer?.cancel();
                  return;
                } else {
                  _realTap();
                }
              });
            }
          },
          child: Column(
            children: [
              Expanded(
                // 气泡将填充上半部分空间，并被放置于底部中心位置
                child: Stack(
                  alignment: Alignment.bottomCenter, // 设置对齐方式为底部中心
                  children: _bubbles.toList(),
                ),
              ),
              Center(
                // 使用 Center 来居中放大缩小的 SVG 图形
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
                      child: child,
                    );
                  },
                  child: SvgPicture.asset(_svgAsset),
                ),
              ),
              Expanded(
                // SVG下方的空间也会被填满
                child: Container(),
              ),
            ],
          ),
        ),
        Positioned(
            right: 10,
            top: 10,
            child: FutureBuilder<int?>(
              future: Storage.getInt('counterKey'),
              builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return Text('${snapshot.data ?? 0}', style: TextStyle(color: Colors.white, fontSize: 50));
                }
              },
            )),
      ],
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    for (var bubble in _bubbles) {
      bubble.controller.dispose(); // 释放每个气泡的控制器
    }
    super.dispose();
  }
}
