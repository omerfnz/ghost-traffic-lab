import 'package:flutter/services.dart';
import 'package:ghost_traffic_lab/core/constants/channel_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'log_stream_service.g.dart';

@riverpod
Stream<String> logStream(LogStreamRef ref) {
  const channel = EventChannel(ChannelConstants.logChannel);
  return channel
      .receiveBroadcastStream()
      .map((event) => event.toString());
}
