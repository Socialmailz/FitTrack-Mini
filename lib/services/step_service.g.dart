// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_service.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyStepsAdapterAdapter extends TypeAdapter<DailyStepsAdapter> {
  @override
  final int typeId = 4;

  @override
  DailyStepsAdapter read(BinaryReader reader) {
    return DailyStepsAdapter();
  }

  @override
  void write(BinaryWriter writer, DailyStepsAdapter obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyStepsAdapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
