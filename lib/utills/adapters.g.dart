// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class SessionAdapter extends TypeAdapter<Session> {
  @override
  final typeId = 0;

  @override
  Session read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Session(
      did: fields[0] as String,
      handle: fields[1] as String,
      email: fields[2] as String?,
      emailConfirmed: fields[3] == null ? false : fields[3] as bool,
      emailAuthFactor: fields[4] == null ? false : fields[4] as bool,
      accessJwt: fields[5] as String,
      refreshJwt: fields[6] as String,
      didDoc: (fields[7] as Map?)?.cast<String, dynamic>(),
      active: fields[8] == null ? true : fields[8] as bool,
      status: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.did)
      ..writeByte(1)
      ..write(obj.handle)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.emailConfirmed)
      ..writeByte(4)
      ..write(obj.emailAuthFactor)
      ..writeByte(5)
      ..write(obj.accessJwt)
      ..writeByte(6)
      ..write(obj.refreshJwt)
      ..writeByte(7)
      ..write(obj.didDoc)
      ..writeByte(8)
      ..write(obj.active)
      ..writeByte(9)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
