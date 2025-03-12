import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // للتحكم في اتجاه الشاشة
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;

// تعليق: شاشة عرض قسم الدرس مع فيديو مؤقت وتحكم كامل
class LessonSectionScreen extends StatefulWidget {
  final Map<String, dynamic> args;

  const LessonSectionScreen({super.key, required this.args});

  @override
  _LessonSectionScreenState createState() => _LessonSectionScreenState();
}

class _LessonSectionScreenState extends State<LessonSectionScreen> {
  late VideoPlayerController _videoController; // تعليق: تحكم في تشغيل الفيديو
  bool _hasError = false;
  String? _errorMessage;
  bool _isFullScreen = false; // تعليق: للتحكم في وضع الشاشة الكاملة
  bool _isVideoCompleted = false; // تعليق: لتتبع انتهاء الفيديو

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    // تعليق: ضبط الشاشة على الوضع العمودي عند بدء التشغيل
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _initializeVideo() {
    try {
      final section = widget.args['section'] as Section?;
      if (section == null) {
        developer.log('LessonSectionScreen: Section is null in args');
        setState(() {
          _hasError = true;
          _errorMessage = 'section_data_missing'.tr();
        });
        return;
      }

      if (section.videoId.isEmpty) {
        developer.log(
          'LessonSectionScreen: videoId is empty for section ${section.id}',
        );
        setState(() {
          _hasError = true;
          _errorMessage = 'video_id_empty'.tr();
        });
        return;
      }

      developer.log('Using temporary video for section ${section.id}');

      // تعليق: استخدام فيديو محلي مؤقت (تأكد من وجوده في assets وعنوانه معرف في pubspec.yaml)
      _videoController = VideoPlayerController.asset('assets/test.mp4')
        ..initialize()
            .then((_) {
              developer.log(
                'Video player initialized for section ${section.id}',
              );
              if (mounted) {
                setState(() {});
                _videoController.play(); // تعليق: تشغيل الفيديو تلقائيًا
                _videoController.addListener(
                  _checkVideoCompletion,
                ); // تعليق: إضافة مستمع لمراقبة انتهاء الفيديو
              }
            })
            .catchError((e) {
              developer.log('Error initializing video player: $e');
              setState(() {
                _hasError = true;
                _errorMessage = 'error_loading_video'.tr(args: [e.toString()]);
              });
            });
    } catch (e, stackTrace) {
      developer.log('LessonSectionScreen: Error initializing video player: $e');
      developer.log('Stack trace: $stackTrace');
      setState(() {
        _hasError = true;
        _errorMessage = 'initialization_error'.tr(args: [e.toString()]);
      });
    }
  }

  @override
  void dispose() {
    _videoController.removeListener(
      _checkVideoCompletion,
    ); // تعليق: إزالة المستمع عند التخلص
    _videoController.dispose(); // تعليق: تحرير الموارد عند إغلاق الشاشة
    // تعليق: إعادة ضبط اتجاه الشاشة إلى العمودي عند الخروج
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // تعليق: التحقق من انتهاء الفيديو
  void _checkVideoCompletion() {
    if (_videoController.value.position >= _videoController.value.duration) {
      setState(() {
        _isVideoCompleted = true;
      });
    }
  }

  // تعليق: التحكم في تقديم الفيديو
  void _seekForward() {
    final currentPosition = _videoController.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);
    _videoController.seekTo(newPosition);
  }

  // تعليق: التحكم في إرجاع الفيديو
  void _seekBackward() {
    final currentPosition = _videoController.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _videoController.seekTo(
      newPosition > Duration.zero ? newPosition : Duration.zero,
    );
  }

  // تعليق: تبديل وضع الشاشة الكاملة
  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        // تعليق: تغيير الاتجاه إلى أفقي
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        // تعليق: إخفاء شريط الحالة وشريط التنقل
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        // تعليق: إعادة الاتجاه إلى عمودي
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        // تعليق: إظهار شريط الحالة وشريط التنقل
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.args['subject'] as Subject?;
    final unit = widget.args['unit'] as Unit?;
    final lesson = widget.args['lesson'] as Lesson?;
    final section = widget.args['section'] as Section?;

    if (section == null || unit == null || lesson == null || subject == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'missing_required_data'.tr(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar:
          _isFullScreen
              ? null
              : AppBar(
                title: Text(
                  '${'section'.tr()} ${section.title}',
                  style: Constants.titleTextStyle.copyWith(
                    color: Constants.backgroundColor,
                  ),
                ),
                backgroundColor: Constants.primaryColor,
              ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Constants.primaryColor, Constants.backgroundColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child:
                _isFullScreen
                    ? _buildFullScreenVideo()
                    : Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Card(
                              elevation: Constants.cardElevation,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Constants.cardBorderRadius,
                                ),
                              ),
                              color: Constants.cardBackgroundColor,
                              child: Padding(
                                padding: EdgeInsets.all(
                                  Constants.activationCardPadding,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _hasError
                                        ? Column(
                                          children: [
                                            Text(
                                              'failed_to_load_video'.tr(
                                                args: [
                                                  _errorMessage ??
                                                      'unknown_error'.tr(),
                                                ],
                                              ),
                                              style: const TextStyle(
                                                color: Colors.red,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 10),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _hasError = false;
                                                  _errorMessage = null;
                                                });
                                                _initializeVideo();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Constants.primaryColor,
                                              ),
                                              child: Text('retry'.tr()),
                                            ),
                                          ],
                                        )
                                        : _buildVideoPlayer(),
                                    const SizedBox(
                                      height: Constants.smallSpacingForLessons,
                                    ),
                                    _buildControlBar(),
                                    Builder(
                                      builder:
                                          (context) => ElevatedButton(
                                            onPressed:
                                                (section.isActivated &&
                                                        !section.isCompleted &&
                                                        (_isVideoCompleted ||
                                                            !_videoController
                                                                .value
                                                                .isPlaying))
                                                    ? () => _navigateToQuiz(
                                                      context,
                                                      section,
                                                    )
                                                    : null,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Constants.primaryColor,
                                              padding: Constants.buttonPadding,
                                              disabledBackgroundColor:
                                                  Constants.inactiveColor,
                                            ),
                                            child: Text(
                                              'end_viewing'.tr(),
                                              style: Constants.buttonTextStyle,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  // تعليق: بناء واجهة الفيديو في وضع الشاشة الكاملة
  Widget _buildFullScreenVideo() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _videoController.value.isInitialized
            ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            )
            : const Center(child: CircularProgressIndicator()),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
            onPressed: _toggleFullScreen,
          ),
        ),
        _buildControlBar(),
      ],
    );
  }

  // تعليق: بناء واجهة الفيديو في وضع عادي
  Widget _buildVideoPlayer() {
    return _videoController.value.isInitialized
        ? AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: VideoPlayer(_videoController),
        )
        : const Center(child: CircularProgressIndicator());
  }

  // تعليق: بناء شريط التحكم بالفيديو
  Widget _buildControlBar() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.black.withOpacity(0.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10, color: Colors.white),
                onPressed: _seekBackward,
              ),
              IconButton(
                icon: Icon(
                  _videoController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _videoController.value.isPlaying
                        ? _videoController.pause()
                        : _videoController.play();
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10, color: Colors.white),
                onPressed: _seekForward,
              ),
              IconButton(
                icon: Icon(
                  _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                ),
                onPressed: _toggleFullScreen,
              ),
            ],
          ),
          VideoProgressIndicator(
            _videoController,
            allowScrubbing: true,
            colors: VideoProgressColors(
              playedColor: Constants.activeColor,
              backgroundColor: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  // تعليق: الانتقال إلى شاشة الأسئلة
  void _navigateToQuiz(BuildContext context, Section section) {
    context
        .push(
          '/quiz',
          extra: {
            'subject': widget.args['subject'],
            'unit': widget.args['unit'],
            'lesson': widget.args['lesson'],
            'section': section,
          },
        )
        .then((result) {
          if (result == true && mounted) {
            context.pushReplacement(
              '/activated-lesson/${widget.args['lesson'].id}',
              extra: {
                'subject': widget.args['subject'],
                'unit': widget.args['unit'],
                'lesson': widget.args['lesson'],
              },
            );
          }
        });
  }
}
