import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:baideshikrojgar/controller/MainController.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/views/fragements/BannerAds.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class RadioPlayingImage extends StatelessWidget {
  final Stream<QueueState> queueStateStream;
  RadioPlayingImage({this.queueStateStream});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AudioService.runningStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return SizedBox(
              child: Text("A"),
            );
          }
          final running = snapshot.data ?? false;
          return running
              ? StreamBuilder<QueueState>(
                  stream: this.queueStateStream,
                  builder: (context, snapshot) {
                    final queueState = snapshot.data;
                    final queue = queueState?.queue ?? [];
                    final mediaItem = queueState?.mediaItem;
                    return (queue != null && queue.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: mediaItem?.artUri ??
                                "https://sajhajobs.com/img/icon.png",
                            imageBuilder: (context, imageProvider) => Container(
                              width: 200.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          )
                        : SizedBox(
                            height: 1,
                          );
                  },
                )
              : Text('Loading...');
        });
  }
}

class RadioPlayingTitle extends StatelessWidget {
  final Stream<QueueState> queueStateStream;
  RadioPlayingTitle({this.queueStateStream});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AudioService.runningStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return SizedBox(
              child: Text("A"),
            );
          }
          final running = snapshot.data ?? false;
          return running
              ? StreamBuilder<QueueState>(
                  stream: this.queueStateStream,
                  builder: (context, snapshot) {
                    final queueState = snapshot.data;
                    final queue = queueState?.queue ?? [];
                    final mediaItem = queueState?.mediaItem;
                    return (queue != null && queue.isNotEmpty)
                        ? TextFormatted(
                            text: mediaItem?.title,
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          )
                        : SizedBox(
                            height: 1,
                          );
                  },
                )
              : Text('Loading...');
        });
  }
}

class RadioNextButton extends StatelessWidget {
  final Stream<QueueState> queueStateStream;
  RadioNextButton({this.queueStateStream});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AudioService.runningStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return SizedBox(
              child: Text("A"),
            );
          }
          final running = snapshot.data ?? false;
          return running
              ? StreamBuilder<QueueState>(
                  stream: this.queueStateStream,
                  builder: (context, snapshot) {
                    final queueState = snapshot.data;
                    final queue = queueState?.queue ?? [];
                    final mediaItem = queueState?.mediaItem;
                    return (queue != null && queue.isNotEmpty)
                        ? IconButton(
                            icon: Icon(Icons.skip_next),
                            color: Colors.white,
                            onPressed: mediaItem == queue.last
                                ? null
                                : AudioService.skipToNext,
                          )
                        : SizedBox(
                            height: 1,
                          );
                  },
                )
              : Text('Loading...');
        });
  }
}

class RadioPreviousButton extends StatelessWidget {
  final Stream<QueueState> queueStateStream;
  RadioPreviousButton({this.queueStateStream});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AudioService.runningStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return SizedBox(
              child: Text("A"),
            );
          }
          final running = snapshot.data ?? false;
          return running
              ? StreamBuilder<QueueState>(
                  stream: this.queueStateStream,
                  builder: (context, snapshot) {
                    final queueState = snapshot.data;
                    final queue = queueState?.queue ?? [];
                    final mediaItem = queueState?.mediaItem;
                    return (queue != null && queue.isNotEmpty)
                        ? IconButton(
                            icon: Icon(Icons.skip_previous),
                            color: Colors.white,
                            onPressed: mediaItem == queue.first
                                ? null
                                : AudioService.skipToPrevious,
                          )
                        : SizedBox(
                            height: 1,
                          );
                  },
                )
              : Text('Loading...');
        });
  }
}

class RadioChannels extends StatelessWidget {
  final Stream<QueueState> queueStateStream;
  RadioChannels({this.queueStateStream});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AudioService.currentMediaItemStream,
      builder: (context, snapshot) {
        final running = snapshot.data == null ? false : true;
        return running
            ? StreamBuilder(
                stream: AudioService.queueStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.active) {
                    return SizedBox(
                      child: Text("A"),
                    );
                  }
                  final running = snapshot.data == null ? false : true;
                  return running
                      ? Column(
                          children: snapshot.data
                              .map<Widget>(
                                (MediaItem mediaItem) => JobTile(
                                  bgcolor: Colors.white54,
                                  picture: mediaItem.artUri,
                                  title: mediaItem.title,
                                  abstract:
                                      AudioService.currentMediaItem.hashCode ==
                                              mediaItem.hashCode
                                          ? "Playing..."
                                          : mediaItem.album,
                                  divider: true,
                                  jobId: mediaItem.id,
                                  type: "radio",
                                ),
                              )
                              .toList(),
                        )
                      : Text('Loading...');
                })
            : SizedBox(
                height: 1,
              );
      },
    );
  }
}

class RadioPlayPauseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AudioService.runningStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return SizedBox();
          }
          final running = snapshot.data ?? false;
          return running
              ? StreamBuilder<bool>(
                  stream: AudioService.playbackStateStream
                      .map((state) => state.playing)
                      .distinct(),
                  builder: (context, snapshot) {
                    final playing = snapshot.data ?? false;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (playing)
                          IconButton(
                            icon: Icon(Icons.pause),
                            color: Colors.white,
                            onPressed: AudioService.pause,
                          )
                        else
                          IconButton(
                            icon: Icon(Icons.play_arrow),
                            color: Colors.white,
                            onPressed: AudioService.play,
                          ),
                      ],
                    );
                  },
                )
              : Text('Loading...');
        });
  }
}

class RadioSeekBar extends StatelessWidget {
  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<MediaItem, Duration, MediaState>(
          AudioService.currentMediaItemStream,
          AudioService.positionStream,
          (mediaItem, position) => MediaState(mediaItem, position));
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AudioService.runningStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return SizedBox();
          }
          final running = snapshot.data ?? false;
          return running
              ? StreamBuilder<bool>(
                  stream: AudioService.playbackStateStream
                      .map((state) => state.playing)
                      .distinct(),
                  builder: (context, snapshot) {
                    final playing = snapshot.data ?? false;
                    return StreamBuilder<MediaState>(
                      stream: _mediaStateStream,
                      builder: (context, snapshot) {
                        final mediaState = snapshot.data;
                        return SeekBar(
                          duration: mediaState?.position ?? Duration.zero,
                          position: mediaState?.position ?? Duration.zero,
                          onChangeEnd: (newPosition) {
                            AudioService.seekTo(newPosition);
                          },
                        );
                      },
                    );
                  },
                )
              : Text('Loading...');
        });
  }
}

class RadioWidget extends StatefulWidget {
  @override
  _RadioWidgetState createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!AudioService.connected) {
      AudioService.start(
        backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
        androidNotificationChannelName: 'Baideshik Rojgar Audio Service',
        // Enable this if you want the Android service to exit the foreground state on pause.
        //androidStopForegroundOnPause: true,
        androidNotificationColor: 0xFF2196f3,
        androidNotificationIcon: 'mipmap/launcher_icon',
        androidEnableQueue: true,
      );
      // MainController.to.setIsRadioPlaying(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppBannerAd(
            adSize: AdSize.fullBanner,
          ),
          RadioPlayingImage(queueStateStream: this._queueStateStream),
          SizedBox(
            height: 50,
          ),
          RadioPlayingTitle(
            queueStateStream: this._queueStateStream,
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RadioPreviousButton(queueStateStream: this._queueStateStream),
              RadioPlayPauseButton(),
              RadioNextButton(queueStateStream: this._queueStateStream),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          RadioSeekBar(),
          RadioChannels(),
          AppBannerAd(),
        ],
      ),
    );
  }

  /// A stream reporting the combined state of the current media item and its
  /// current position.
  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<MediaItem, Duration, MediaState>(
          AudioService.currentMediaItemStream,
          AudioService.positionStream,
          (mediaItem, position) => MediaState(mediaItem, position));

  /// A stream reporting the combined state of the current queue and the current
  /// media item within that queue.
  Stream<QueueState> get _queueStateStream =>
      Rx.combineLatest2<List<MediaItem>, MediaItem, QueueState>(
          AudioService.queueStream,
          AudioService.currentMediaItemStream,
          (queue, mediaItem) => QueueState(queue, mediaItem));

  RaisedButton audioPlayerButton() => startButton(
        'AudioPlayer',
        () {
          AudioService.start(
            backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
            androidNotificationChannelName: 'Audio Service Demo',
            // Enable this if you want the Android service to exit the foreground state on pause.
            //androidStopForegroundOnPause: true,
            androidNotificationColor: 0xFF2196f3,
            androidNotificationIcon: 'mipmap/ic_launcher',
            androidEnableQueue: true,
          );
        },
      );

  RaisedButton textToSpeechButton() => startButton(
        'TextToSpeech',
        () {
          AudioService.start(
            backgroundTaskEntrypoint: _textToSpeechTaskEntrypoint,
            androidNotificationChannelName: 'Audio Service Demo',
            androidNotificationColor: 0xFF2196f3,
            androidNotificationIcon: 'mipmap/ic_launcher',
          );
        },
      );

  RaisedButton startButton(String label, VoidCallback onPressed) =>
      RaisedButton(
        child: Text(label),
        onPressed: onPressed,
      );

  IconButton playButton() => IconButton(
        icon: Icon(Icons.play_arrow),
        color: Colors.white,
        onPressed: AudioService.play,
      );

  IconButton pauseButton() => IconButton(
        icon: Icon(Icons.pause),
        color: Colors.white,
        onPressed: AudioService.pause,
      );

  IconButton stopButton() => IconButton(
        icon: Icon(Icons.stop),
        color: Colors.white,
        onPressed: AudioService.stop,
      );
}

class QueueState {
  final List<MediaItem> queue;
  final MediaItem mediaItem;

  QueueState(this.queue, this.mediaItem);
}

class MediaState {
  final MediaItem mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final value = min(_dragValue ?? widget.position?.inMilliseconds?.toDouble(),
        widget.duration.inMilliseconds.toDouble());
    if (_dragValue != null && !_dragging) {
      _dragValue = null;
    }
    return Stack(
      children: [
        Slider(
          min: 0.0,
          max: widget.duration.inMilliseconds.toDouble(),
          value: value,
          onChanged: (value) {
            if (!_dragging) {
              _dragging = true;
            }
            setState(() {
              _dragValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged(Duration(milliseconds: value.round()));
            }
          },
          onChangeEnd: (value) {
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd(Duration(milliseconds: value.round()));
            }
            _dragging = false;
          },
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("$_remaining")
                      ?.group(1) ??
                  '$_remaining',
              style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

// NOTE: Your entrypoint MUST be a top-level function.
void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

/// This task defines logic for playing a list of podcast episodes.
class AudioPlayerTask extends BackgroundAudioTask {
  final _mediaLibrary = MediaLibrary();
  AudioPlayer _player = new AudioPlayer();
  AudioProcessingState _skipState;
  Seeker _seeker;
  StreamSubscription<PlaybackEvent> _eventSubscription;

  List<MediaItem> get queue => _mediaLibrary.items;
  int get index => _player.currentIndex;
  MediaItem get mediaItem => index == null ? null : queue[index];

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    // We configure the audio session for speech since we're playing a podcast.
    // You can also put this in your app's initialisation if your app doesn't
    // switch between two types of audio as this example does.
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Broadcast media item changes.
    _player.currentIndexStream.listen((index) {
      if (index != null) AudioServiceBackground.setMediaItem(queue[index]);
    });
    // Propagate all events from the audio player to AudioService clients.
    _eventSubscription = _player.playbackEventStream.listen((event) {
      _broadcastState();
    });
    // Special processing for state transitions.
    _player.processingStateStream.listen((state) {
      switch (state) {
        case ProcessingState.completed:
          // In this example, the service stops when reaching the end.
          onStop();
          break;
        case ProcessingState.ready:
          // If we just came from skipping between tracks, clear the skip
          // state now that we're ready to play.
          _skipState = null;
          break;
        default:
          break;
      }
    });

    // Load and broadcast the queue
    AudioServiceBackground.setQueue(queue);
    try {
      await _player.setAudioSource(ConcatenatingAudioSource(
        children:
            queue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
      ));
      // In this example, we automatically start playing on start.
      onPlay();
    } catch (e) {
      print("Error: $e");
      onStop();
    }
  }

  @override
  Future<void> onSkipToQueueItem(String mediaId) async {
    // Then default implementations of onSkipToNext and onSkipToPrevious will
    // delegate to this method.
    final newIndex = queue.indexWhere((item) => item.id == mediaId);
    if (newIndex == -1) return;
    // During a skip, the player may enter the buffering state. We could just
    // propagate that state directly to AudioService clients but AudioService
    // has some more specific states we could use for skipping to next and
    // previous. This variable holds the preferred state to send instead of
    // buffering during a skip, and it is cleared as soon as the player exits
    // buffering (see the listener in onStart).
    _skipState = newIndex > index
        ? AudioProcessingState.skippingToNext
        : AudioProcessingState.skippingToPrevious;
    // This jumps to the beginning of the queue item at newIndex.
    _player.seek(Duration.zero, index: newIndex);
    // Demonstrate custom events.
    AudioServiceBackground.sendCustomEvent('skip to $newIndex');
  }

  @override
  Future<void> onPlay() => _player.play();

  @override
  Future<void> onPause() => _player.pause();

  @override
  Future<void> onSeekTo(Duration position) => _player.seek(position);

  @override
  Future<void> onFastForward() => _seekRelative(fastForwardInterval);

  @override
  Future<void> onRewind() => _seekRelative(-rewindInterval);

  @override
  Future<void> onSeekForward(bool begin) async => _seekContinuously(begin, 1);

  @override
  Future<void> onSeekBackward(bool begin) async => _seekContinuously(begin, -1);

  @override
  Future<void> onStop() async {
    await _player.dispose();
    _eventSubscription.cancel();
    // It is important to wait for this state to be broadcast before we shut
    // down the task. If we don't, the background task will be destroyed before
    // the message gets sent to the UI.
    await _broadcastState();
    // Shut down this task
    await super.onStop();
  }

  /// Jumps away from the current position by [offset].
  Future<void> _seekRelative(Duration offset) async {
    var newPosition = _player.position + offset;
    // Make sure we don't jump out of bounds.
    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > mediaItem.duration) newPosition = mediaItem.duration;
    // Perform the jump via a seek.
    await _player.seek(newPosition);
  }

  /// Begins or stops a continuous seek in [direction]. After it begins it will
  /// continue seeking forward or backward by 10 seconds within the audio, at
  /// intervals of 1 second in app time.
  void _seekContinuously(bool begin, int direction) {
    _seeker?.stop();
    if (begin) {
      _seeker = Seeker(_player, Duration(seconds: 10 * direction),
          Duration(seconds: 1), mediaItem)
        ..start();
    }
  }

  /// Broadcasts the current state to all clients.
  Future<void> _broadcastState() async {
    await AudioServiceBackground.setState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: [
        MediaAction.seekTo,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      ],
      androidCompactActions: [0, 1, 3],
      processingState: _getProcessingState(),
      playing: _player.playing,
      position: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }

  /// Maps just_audio's processing state into into audio_service's playing
  /// state. If we are in the middle of a skip, we use [_skipState] instead.
  AudioProcessingState _getProcessingState() {
    if (_skipState != null) return _skipState;
    switch (_player.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.stopped;
      case ProcessingState.loading:
        return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_player.processingState}");
    }
  }
}

/// Provides access to a library of media items. In your app, this could come
/// from a database or web service.
class MediaLibrary {
  final _items = <MediaItem>[
    MediaItem(
      id: "https://stream.zenolive.com/8svn4n3v4yzuv.aac",
      album: "नेपाल र नेपालीको रेडियो",
      title: "Baideshik Rojgar",
      genre: "नेपाल र नेपालीको रेडियो",
      // duration: Duration(milliseconds: 5739820),
      artUri:
          "https://sajhajobs.com/storage/jobs/images/m1wTYKeDK0NrAfWp3oTSGMC07u4VJwsmLH7mKjxp.jpg",
    ),
    MediaItem(
      id: "https://radio-broadcast.ekantipur.com/stream",
      album: "रेडियो राष्ट्रको",
      title: "Radio Kantipur",
      genre: "रेडियो राष्ट्रको",
      // duration: Duration(milliseconds: 5739820),
      artUri:
          "https://sajhajobs.com/storage/jobs/images/pr4h2GLSAPwyOdMrHliYT7z2alhHSNVCUYtEJhQH.jpg",
    ),
    MediaItem(
      id: "http://103.69.126.230:8000/stream",
      album: "आधुनिक नेपालको समावेशी आवाज",
      title: "Radio Nepal",
      genre: "आधुनिक नेपालको समावेशी आवाज",
      // duration: Duration(milliseconds: 5739820),
      artUri:
          "https://sajhajobs.com/storage/jobs/images/JCvNTXVy1AI40zo2sCZpn9MyoDseRtq22gmL8FBH.jpg",
    ),
    MediaItem(
      id: "http://kalika-stream.softnep.com:7740/stream?type=http&nocache=7136",
      album: "मध्ये नेपालको सर्वोत्कृष्ट रेडियो",
      title: "Kalika FM",
      genre: "मध्ये नेपालको सर्वोत्कृष्ट रेडियो",
      // duration: Duration(milliseconds: 5739820),
      artUri:
          "https://sajhajobs.com/storage/jobs/images/bLZuygU42aHt2I6kV9okhwUalYx3QjWlgp3uXNoK.jpg",
    ),
    MediaItem(
      id: "http://node-10.zeno.fm/h527zwd11uquv",
      album: "90.0 MHz",
      title: "Ujyaalo 90 Network",
      genre: "90.0 MHz",
      // duration: Duration(milliseconds: 5739820),
      artUri:
          "https://sajhajobs.com/storage/jobs/images/PP1hzUENU5jfDR8bQYu6rzclBmxSJzn7CVjV3RrS.jpg",
    ),
    MediaItem(
      id: "https://usa15.fastcast4u.com/proxy/hitsfm912?mp=/1",
      album: "91.2 MHz",
      title: "Hits FM",
      genre: "91.2 MHz",
      // duration: Duration(milliseconds: 5739820),
      artUri:
          "https://sajhajobs.com/storage/jobs/images/kbwoVqx25LrtFGF5Fc85ppt0rDkedgwqrOSGIsIO.jpg",
    ),
    MediaItem(
      id: "http://streaming.hamropatro.com:8631/;",
      album: "97.9 MHz",
      title: "Image FM",
      genre: "97.9 MHz",
      // duration: Duration(milliseconds: 5739820),
      artUri:
          "https://sajhajobs.com/storage/jobs/images/kbwoVqx25LrtFGF5Fc85ppt0rDkedgwqrOSGIsIO.jpg",
    ),
    MediaItem(
      id: "https://stream.zeno.fm/fvrx47wpg0quv",
      album: "FM 106.3 MHz",
      title: "Radio Audio",
      genre: "FM 106.3 MHz",
      // duration: Duration(milliseconds: 5739820),
      artUri:
          "https://sajhajobs.com/storage/jobs/images/u74tErdVv7D1g1b7i4xS0ZdtKl8CtMdeXg5bvz1u.jpg",
    ),
    MediaItem(
      id: "http://streaming.softnep.net:8025/;stream.nsv&type=mp3",
      album: "निष्पक्ष सक्रियताको अभ्यास",
      title: "Radio Thaha Sanchar",
      genre: "निष्पक्ष सक्रियताको अभ्यास",
      // duration: Duration(milliseconds: 5739820),
      artUri:
          "https://sajhajobs.com/storage/jobs/images/yBkwIvM3cluQPPoJgrguBIcvfQm6iXjesXUF5vMM.jpg",
    ),
    MediaItem(
      id: "http://streaming.softnep.net:8003/;",
      album: "94.4 MHz",
      title: "Butwal FM",
      genre: "94.4 MHz",
      // duration: Duration(milliseconds: 5739820),
      artUri:
          "https://sajhajobs.com/storage/jobs/images/Lz58WSqNnjxGg63G0dqCQRLo2hs4f5zc1eN76obS.jpg",
    ),
    MediaItem(
      id: "http://streaming.hamropatro.com:8230/;",
      album: "91.8 MHz",
      title: "Nepal FM",
      genre: "91.8 MHz",
      // duration: Duration(milliseconds: 5739820),
      artUri:
          "https://sajhajobs.com/storage/jobs/images/yDex1eEshdWrLmwIs5GLEsmhwV32MET53E8Dciuz.jpg",
    ),
    MediaItem(
      id: "http://streaming.softnep.net:8091/;stream.nsv&type=mp3&volume=50",
      album: "93.4 Mhz",
      title: "Annapurna FM",
      genre: "93.4 Mhz",
      // duration: Duration(milliseconds: 5739820),
      artUri:
          "https://sajhajobs.com/storage/jobs/images/PiYgJ6fJNIyHfRi6w4msLQkadqlQwES2NYfwJ9LM.jpg",
    ),
  ];

  List<MediaItem> get items => _items;
}

// NOTE: Your entrypoint MUST be a top-level function.
void _textToSpeechTaskEntrypoint() async {
  AudioServiceBackground.run(() => TextPlayerTask());
}

/// This task defines logic for speaking a sequence of numbers using
/// text-to-speech.
class TextPlayerTask extends BackgroundAudioTask {
  Tts _tts = Tts();
  bool _finished = false;
  Sleeper _sleeper = Sleeper();
  Completer _completer = Completer();
  bool _interrupted = false;

  bool get _playing => AudioServiceBackground.state.playing;

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    // flutter_tts resets the AVAudioSession category to playAndRecord and the
    // options to defaultToSpeaker whenever this background isolate is loaded,
    // so we need to set our preferred audio session configuration here after
    // that has happened.
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Handle audio interruptions.
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        if (_playing) {
          onPause();
          _interrupted = true;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.pause:
          case AudioInterruptionType.duck:
            if (!_playing && _interrupted) {
              onPlay();
            }
            break;
          case AudioInterruptionType.unknown:
            break;
        }
        _interrupted = false;
      }
    });
    // Handle unplugged headphones.
    session.becomingNoisyEventStream.listen((_) {
      if (_playing) onPause();
    });

    // Start playing.
    await _playPause();
    for (var i = 1; i <= 10 && !_finished;) {
      AudioServiceBackground.setMediaItem(mediaItem(i));
      AudioServiceBackground.androidForceEnableMediaButtons();
      try {
        await _tts.speak('$i');
        i++;
        await _sleeper.sleep(Duration(milliseconds: 300));
      } catch (e) {
        // Speech was interrupted
      }
      // If we were just paused
      if (!_finished && !_playing) {
        try {
          // Wait to be unpaused
          await _sleeper.sleep();
        } catch (e) {
          // unpaused
        }
      }
    }
    await AudioServiceBackground.setState(
      controls: [],
      processingState: AudioProcessingState.stopped,
      playing: false,
    );
    if (!_finished) {
      onStop();
    }
    _completer.complete();
  }

  @override
  Future<void> onPlay() => _playPause();

  @override
  Future<void> onPause() => _playPause();

  @override
  Future<void> onStop() async {
    // Signal the speech to stop
    _finished = true;
    _sleeper.interrupt();
    _tts.interrupt();
    // Wait for the speech to stop
    await _completer.future;
    // Shut down this task
    await super.onStop();
  }

  MediaItem mediaItem(int number) => MediaItem(
      id: 'tts_$number',
      album: 'Numbers',
      title: 'Number $number',
      artist: 'Sample Artist');

  Future<void> _playPause() async {
    if (_playing) {
      _interrupted = false;
      await AudioServiceBackground.setState(
        controls: [MediaControl.play, MediaControl.stop],
        processingState: AudioProcessingState.ready,
        playing: false,
      );
      _sleeper.interrupt();
      _tts.interrupt();

      MainController.to.setIsRadioPlaying(false);
    } else {
      final session = await AudioSession.instance;
      // flutter_tts doesn't activate the session, so we do it here. This
      // allows the app to stop other apps from playing audio while we are
      // playing audio.
      if (await session.setActive(true)) {
        // If we successfully activated the session, set the state to playing
        // and resume playback.
        await AudioServiceBackground.setState(
          controls: [MediaControl.pause, MediaControl.stop],
          processingState: AudioProcessingState.ready,
          playing: true,
        );
        _sleeper.interrupt();
      }

      MainController.to.setIsRadioPlaying(true);
    }
  }
}

/// An object that performs interruptable sleep.
class Sleeper {
  Completer _blockingCompleter;

  /// Sleep for a duration. If sleep is interrupted, a
  /// [SleeperInterruptedException] will be thrown.
  Future<void> sleep([Duration duration]) async {
    _blockingCompleter = Completer();
    if (duration != null) {
      await Future.any([Future.delayed(duration), _blockingCompleter.future]);
    } else {
      await _blockingCompleter.future;
    }
    final interrupted = _blockingCompleter.isCompleted;
    _blockingCompleter = null;
    if (interrupted) {
      throw SleeperInterruptedException();
    }
  }

  /// Interrupt any sleep that's underway.
  void interrupt() {
    if (_blockingCompleter?.isCompleted == false) {
      _blockingCompleter.complete();
    }
  }
}

class SleeperInterruptedException {}

/// A wrapper around FlutterTts that makes it easier to wait for speech to
/// complete.
class Tts {
  final FlutterTts _flutterTts = new FlutterTts();
  Completer _speechCompleter;
  bool _interruptRequested = false;
  bool _playing = false;

  Tts() {
    _flutterTts.setCompletionHandler(() {
      _speechCompleter?.complete();
    });
  }

  bool get playing => _playing;

  Future<void> speak(String text) async {
    _playing = true;
    if (!_interruptRequested) {
      _speechCompleter = Completer();
      await _flutterTts.speak(text);
      await _speechCompleter.future;
      _speechCompleter = null;
    }
    _playing = false;
    if (_interruptRequested) {
      _interruptRequested = false;
      throw TtsInterruptedException();
    }
  }

  Future<void> stop() async {
    if (_playing) {
      await _flutterTts.stop();
      _speechCompleter?.complete();
    }
  }

  void interrupt() {
    if (_playing) {
      _interruptRequested = true;
      stop();
    }
  }
}

class TtsInterruptedException {}

class Seeker {
  final AudioPlayer player;
  final Duration positionInterval;
  final Duration stepInterval;
  final MediaItem mediaItem;
  bool _running = false;

  Seeker(
    this.player,
    this.positionInterval,
    this.stepInterval,
    this.mediaItem,
  );

  start() async {
    _running = true;
    while (_running) {
      Duration newPosition = player.position + positionInterval;
      if (newPosition < Duration.zero) newPosition = Duration.zero;
      if (newPosition > mediaItem.duration) newPosition = mediaItem.duration;
      player.seek(newPosition);
      await Future.delayed(stepInterval);
    }
  }

  stop() {
    _running = false;
  }
}
