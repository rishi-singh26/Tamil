enum SizeUnit { TB, GB, MB, KB, B }

class ByteConverterService {
  double _bytes = 0.0;
  int _bits = 0;

  ByteConverterService(this._bytes) {
    _bits = (_bytes * 8.0).ceil();
  }

  ByteConverterService.withBits(this._bits) {
    _bytes = _bits / 8;
  }

  double _withPrecision(double value, {int precision = 2}) {
    var valString = '$value';
    var endingIndex = valString.indexOf('.') + (precision++);

    if (valString.length < endingIndex) {
      return value;
    }

    return double.tryParse(valString.substring(0, endingIndex)) ?? value;
  }

  double get kiloBytes => _bytes / 1000;

  double get megaBytes => _bytes / 1000000;

  double get gigaBytes => _bytes / 1000000000;

  double get teraBytes => _bytes / 1000000000000;

  double get petaBytes => _bytes / 1E+15;

  double asBytes({int precision = 2}) => _withPrecision(_bytes, precision: precision);

  static ByteConverterService fromBytes(double value) => ByteConverterService(value);

  static ByteConverterService fromBits(int value) => ByteConverterService.withBits(value);

  static ByteConverterService fromKibiBytes(double value) => ByteConverterService(value * 1024.0);

  static ByteConverterService fromMebiBytes(double value) => ByteConverterService(value * 1048576.0);

  static ByteConverterService fromGibiBytes(double value) => ByteConverterService(value * 1073741824.0);

  static ByteConverterService fromTebiBytes(double value) => ByteConverterService(value * 1099511627776.0);

  static ByteConverterService fromPebiBytes(double value) => ByteConverterService(value * 1125899906842624.0);

  static ByteConverterService fromKiloBytes(double value) => ByteConverterService(value * 1000.0);

  static ByteConverterService fromMegaBytes(double value) => ByteConverterService(value * 1000000.0);

  static ByteConverterService fromGigaBytes(double value) => ByteConverterService(value * 1000000000.0);

  static ByteConverterService fromTeraBytes(double value) => ByteConverterService(value * 1000000000000.0);

  static ByteConverterService fromPetaBytes(double value) => ByteConverterService(value * 1E+15);

  ByteConverterService add(ByteConverterService value) => this + value;

  ByteConverterService subtract(ByteConverterService value) => this - value;

  ByteConverterService addBytes(double value) => this + fromBytes(value);

  ByteConverterService addKiloBytes(double value) => this + fromKiloBytes(value);

  ByteConverterService addMegaBytes(double value) => this + fromMegaBytes(value);

  ByteConverterService addGigaBytes(double value) => this + fromGigaBytes(value);

  ByteConverterService addTeraBytes(double value) => this + fromTeraBytes(value);

  ByteConverterService addPetaBytes(double value) => this + fromPetaBytes(value);

  ByteConverterService addKibiBytes(double value) => this + fromKibiBytes(value);

  ByteConverterService addMebiBytes(double value) => this + fromMebiBytes(value);

  ByteConverterService addGibiBytes(double value) => this + fromGibiBytes(value);

  ByteConverterService addTebiBytes(double value) => this + fromTebiBytes(value);

  ByteConverterService addPebiBytes(double value) => this + fromPebiBytes(value);

  ByteConverterService operator +(ByteConverterService instance) => ByteConverterService(instance._bytes + _bytes);

  ByteConverterService operator -(ByteConverterService instance) => ByteConverterService(_bytes - instance._bytes);

  bool operator >(ByteConverterService instance) => _bits > instance._bits;

  bool operator <(ByteConverterService instance) => _bits < instance._bits;

  bool operator <=(ByteConverterService instance) => _bits <= instance._bits;

  bool operator >=(ByteConverterService instance) => _bits >= instance._bits;

  static int compare(ByteConverterService a, ByteConverterService b) => a._bits.compareTo(b._bits);

  static bool isEqual(ByteConverterService a, ByteConverterService b) => a.isEqualTo(b);

  int compareTo(ByteConverterService instance) => compare(this, instance);

  bool isEqualTo(ByteConverterService instance) => _bits == instance._bits;

  String toHumanReadable(SizeUnit unit, {int precision = 2}) {
    switch (unit) {
      case SizeUnit.TB:
        return '${_withPrecision(teraBytes, precision: precision)} TB';
      case SizeUnit.GB:
        return '${_withPrecision(gigaBytes, precision: precision)} GB';
      case SizeUnit.MB:
        return '${_withPrecision(megaBytes, precision: precision)} MB';
      case SizeUnit.KB:
        return '${_withPrecision(kiloBytes, precision: precision)} KB';
      case SizeUnit.B:
        return '${asBytes(precision: precision)} B';
    }
  }
}
