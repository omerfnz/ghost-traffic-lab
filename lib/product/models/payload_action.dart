import 'package:freezed_annotation/freezed_annotation.dart';

part 'payload_action.freezed.dart';
part 'payload_action.g.dart';

@Freezed(unionKey: 'action')
sealed class PayloadAction with _$PayloadAction {
  const factory PayloadAction.wait({required int duration}) = WaitAction;
  const factory PayloadAction.swipe({required String direction}) = SwipeAction;
  const factory PayloadAction.click({
    @JsonKey(name: 'node_text') required String nodeText,
  }) = ClickAction;
  const factory PayloadAction.launch({
    @JsonKey(name: 'package_name') required String packageName,
  }) = LaunchAction;
  @FreezedUnionValue('type')
  const factory PayloadAction.typeText({required String text}) = TypeTextAction;
  @FreezedUnionValue('click_xy')
  const factory PayloadAction.clickXy({required double x, required double y}) =
      ClickXyAction;
  @FreezedUnionValue('long_press')
  const factory PayloadAction.longPress({
    required double x,
    required double y,
    required int duration,
  }) = LongPressAction;
  @FreezedUnionValue('open_url')
  const factory PayloadAction.openUrl({required String url}) = OpenUrlAction;
  const factory PayloadAction.back() = BackAction;
  const factory PayloadAction.home() = HomeAction;
  @FreezedUnionValue('scroll_until')
  const factory PayloadAction.scrollUntil({
    required String text,
    @Default(10) @JsonKey(name: 'max_scrolls') int maxScrolls,
  }) = ScrollUntilAction;
  @FreezedUnionValue('random_wait')
  const factory PayloadAction.randomWait({
    @JsonKey(name: 'min_ms') required int minMs,
    @JsonKey(name: 'max_ms') required int maxMs,
  }) = RandomWaitAction;

  factory PayloadAction.fromJson(Map<String, dynamic> json) =>
      _$PayloadActionFromJson(json);
}
