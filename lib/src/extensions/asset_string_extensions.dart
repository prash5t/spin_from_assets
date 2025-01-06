part of '../../spin_from_assets.dart';

extension StringExtensions on String {
  toSVGOrImageOrLottie({double? h, double? w, Color? color}) {
    if (endsWith('.svg')) {
      return toSvg(h: h, w: w, color: color);
    } else if (endsWith('.png') || endsWith('.jpg') || endsWith('.jpeg')) {
      return toImage(h: h, w: w);
    } else if (endsWith('.json')) {
      return toLottie(h: h, w: w);
    }
  }

  toLottie({double? h, double? w}) {
    return Lottie.asset(
      this,
      height: h,
      width: w,
      fit: BoxFit.cover,
      repeat: true,
    );
  }

  toSvg({double? h, double? w, Color? color}) {
    return SvgPicture.asset(
      this,
      height: h,
      width: w,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  toImage({double? h, double? w}) {
    return Image.asset(this, height: h, width: w);
  }
}
