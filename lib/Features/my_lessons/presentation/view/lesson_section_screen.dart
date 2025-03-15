import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as developer;

class LessonSectionScreen extends StatefulWidget {
  final Map<String, dynamic> args;

  const LessonSectionScreen({super.key, required this.args});

  @override
  State<LessonSectionScreen> createState() => _LessonSectionScreenState();
}

class _LessonSectionScreenState extends State<LessonSectionScreen> {
  late VideoPlayerController _videoController;
  bool _hasError = false;
  String? _errorMessage;
  bool _isFullScreen = false;
  bool _isVideoCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
        developer.log('LessonSectionScreen: videoId is empty for section ${section.id}');
        setState(() {
          _hasError = true;
          _errorMessage = 'video_id_empty'.tr();
        });
        return;
      }
      developer.log('Using temporary video for section ${section.id}');
      _videoController = VideoPlayerController.asset('assets/test.mp4')
        ..initialize().then((_) {
          developer.log('Video player initialized for section ${section.id}');
          if (mounted) {
            setState(() {});
            _videoController.play();
            _videoController.addListener(_checkVideoCompletion);
          }
        }).catchError((e) {
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
    _videoController.removeListener(_checkVideoCompletion);
    _videoController.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  void _checkVideoCompletion() {
    if (_videoController.value.position >= _videoController.value.duration) {
      setState(() {
        _isVideoCompleted = true;
      });
    }
  }

  void _seekForward() {
    final currentPosition = _videoController.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);
    _videoController.seekTo(newPosition);
  }

  void _seekBackward() {
    final currentPosition = _videoController.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _videoController.seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
      return const InvalidDataOverlay();
    }

    return Scaffold(
      appBar: _isFullScreen ? null : AppBarWidget(section: section),
      body: Stack(
        children: [
          const GradientBackground(),
          SafeArea(
            child: _isFullScreen
                ? FullScreenVideo(
                    controller: _videoController,
                    toggleFullScreen: _toggleFullScreen,
                    seekForward: _seekForward,
                    seekBackward: _seekBackward,
                  )
                : VideoContent(
                    controller: _videoController,
                    hasError: _hasError,
                    errorMessage: _errorMessage,
                    isVideoCompleted: _isVideoCompleted,
                    retry: () => setState(() {
                      _hasError = false;
                      _errorMessage = null;
                      _initializeVideo();
                    }),
                    toggleFullScreen: _toggleFullScreen,
                    seekForward: _seekForward,
                    seekBackward: _seekBackward,
                    navigateToQuiz: () => _navigateToQuiz(context, section),
                    subject: subject,
                    unit: unit,
                    lesson: lesson,
                    section: section,
                  ),
          ),
        ],
      ),
    );
  }

  void _navigateToQuiz(BuildContext context, Section section) {
    context.push('/quiz', extra: {
      'subject': widget.args['subject'],
      'unit': widget.args['unit'],
      'lesson': widget.args['lesson'],
      'section': section,
    }).then((result) {
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

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Section section;

  const AppBarWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        '${'section'.tr()} ${section.title}', // "القسم: Introduction" (ar) أو "Section: Introduction" (en)
        style: Constants.titleTextStyle.copyWith(color: Constants.backgroundColor),
      ),
      backgroundColor: Constants.primaryColor.withOpacity(0.9),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Constants.primaryColor.withOpacity(0.9),
            Constants.primaryColor.withOpacity(0.5),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.1, 1.0],
        ),
      ),
    );
  }
}

class InvalidDataOverlay extends StatelessWidget {
  const InvalidDataOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'missing_required_data'.tr(), // "البيانات المطلوبة مفقودة" (ar) أو "Missing required data" (en)
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

class FullScreenVideo extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback toggleFullScreen;
  final VoidCallback seekForward;
  final VoidCallback seekBackward;

  const FullScreenVideo({
    super.key,
    required this.controller,
    required this.toggleFullScreen,
    required this.seekForward,
    required this.seekBackward,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        controller.value.isInitialized
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.size.width,
                    height: controller.value.size.height,
                    child: VideoPlayer(controller),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
            onPressed: toggleFullScreen,
          ),
        ),
        ControlBar(
          controller: controller,
          seekForward: seekForward,
          seekBackward: seekBackward,
          toggleFullScreen: toggleFullScreen,
          isFullScreen: true,
        ),
      ],
    );
  }
}

class VideoContent extends StatelessWidget {
  final VideoPlayerController controller;
  final bool hasError;
  final String? errorMessage;
  final bool isVideoCompleted;
  final VoidCallback retry;
  final VoidCallback toggleFullScreen;
  final VoidCallback seekForward;
  final VoidCallback seekBackward;
  final VoidCallback navigateToQuiz;
  final Subject subject;
  final Unit unit;
  final Lesson lesson;
  final Section section;

  const VideoContent({
    super.key,
    required this.controller,
    required this.hasError,
    required this.errorMessage,
    required this.isVideoCompleted,
    required this.retry,
    required this.toggleFullScreen,
    required this.seekForward,
    required this.seekBackward,
    required this.navigateToQuiz,
    required this.subject,
    required this.unit,
    required this.lesson,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Card(
              elevation: Constants.cardElevation,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.cardBorderRadius)),
              color: Constants.cardBackgroundColor,
              child: Padding(
                padding: EdgeInsets.all(Constants.activationCardPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    hasError
                        ? ErrorDisplay(errorMessage: errorMessage, retry: retry)
                        : VideoPlayerWidget(controller: controller),
                    const SizedBox(height: Constants.smallSpacingForLessons),
                    ControlBar(
                      controller: controller,
                      seekForward: seekForward,
                      seekBackward: seekBackward,
                      toggleFullScreen: toggleFullScreen,
                      isFullScreen: false,
                    ),
                    EndViewingButton(
                      section: section,
                      isVideoCompleted: isVideoCompleted,
                      controller: controller,
                      onPressed: navigateToQuiz,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ErrorDisplay extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback retry;

  const ErrorDisplay({super.key, required this.errorMessage, required this.retry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'failed_to_load_video'.tr(args: [errorMessage ?? 'unknown_error'.tr()]), // "فشل في تحميل الفيديو" (ar) أو "Failed to load video" (en)
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: retry,
          style: ElevatedButton.styleFrom(backgroundColor: Constants.primaryColor),
          child: Text('retry'.tr()), // "إعادة المحاولة" (ar) أو "Retry" (en)
        ),
      ],
    );
  }
}

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoPlayerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

class ControlBar extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback seekForward;
  final VoidCallback seekBackward;
  final VoidCallback toggleFullScreen;
  final bool isFullScreen;

  const ControlBar({
    super.key,
    required this.controller,
    required this.seekForward,
    required this.seekBackward,
    required this.toggleFullScreen,
    required this.isFullScreen,
  });

  @override
  Widget build(BuildContext context) {
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
                onPressed: seekBackward,
              ),
              IconButton(
                icon: Icon(
                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () => controller.value.isPlaying ? controller.pause() : controller.play(),
              ),
              IconButton(
                icon: const Icon(Icons.forward_10, color: Colors.white),
                onPressed: seekForward,
              ),
              IconButton(
                icon: Icon(
                  isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                ),
                onPressed: toggleFullScreen,
              ),
            ],
          ),
          VideoProgressIndicator(
            controller,
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
}

class EndViewingButton extends StatelessWidget {
  final Section section;
  final bool isVideoCompleted;
  final VideoPlayerController controller;
  final VoidCallback onPressed;

  const EndViewingButton({
    super.key,
    required this.section,
    required this.isVideoCompleted,
    required this.controller,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (section.isActivated && !section.isCompleted && (isVideoCompleted || !controller.value.isPlaying))
          ? onPressed
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Constants.primaryColor,
        padding: Constants.buttonPadding,
        disabledBackgroundColor: Constants.inactiveColor,
      ),
      child: Text('end_viewing'.tr(), style: Constants.buttonTextStyle), // "إنهاء المشاهدة" (ar) أو "End Viewing" (en)
    );
  }
}