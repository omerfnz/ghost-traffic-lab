import 'package:freezed_annotation/freezed_annotation.dart';

part 'payload_action.freezed.dart';
part 'payload_action.g.dart';

@freezed
sealed class PayloadAction with _$PayloadAction {
  const factory PayloadAction.wait({required int duration}) = WaitAction;
  const factory PayloadAction.swipe({required String direction}) = SwipeAction;
  const factory PayloadAction.click({required String nodeText}) = ClickAction;
  const factory PayloadAction.launch({required String packageName}) =
      LaunchAction;
  const factory PayloadAction.typeText({required String text}) =
      TypeTextAction;

  factory PayloadAction.fromJson(Map<String, dynamic> json) =>
      _$PayloadActionFromJson(json);
}
