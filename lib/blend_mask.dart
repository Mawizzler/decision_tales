import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class BlendMask extends SingleChildRenderObjectWidget {
  final BlendMode blendMode;
  final double opacity;

  BlendMask({
    required this.blendMode,
    this.opacity = 1.0,
    required Key key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(context) {
    return RenderBlendMask(blendMode, opacity);
  }

  @override
  void updateRenderObject(BuildContext context, RenderBlendMask renderObject) {
    renderObject.blendMode = blendMode;
    renderObject.opacity = opacity;
  }
}

class RenderBlendMask extends RenderProxyBox {
  BlendMode blendMode;
  double opacity;

  RenderBlendMask(this.blendMode, this.opacity);

  @override
  void paint(context, offset) {
    context.canvas.saveLayer(
        offset & size,
        Paint()
          ..blendMode = blendMode
          ..color = Color.fromARGB((opacity * 255).round(), 255, 255, 255));

    super.paint(context, offset);

    context.canvas.restore();
  }
}

class ImageMixer extends StatelessWidget {
  final String imageUrl;
  ImageMixer({required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          SizedBox.expand(
              child: Opacity(
            opacity: 0.92,
            child: Image(
              fit: BoxFit.cover,
              image: NetworkImage(imageUrl),
            ),
          )),
          BlendMask(
            opacity: 1.0,
            blendMode: BlendMode.multiply,
            key: const Key("Overlay"),
            child: const SizedBox.expand(
              child: Image(
                  image: NetworkImage(
                      "https://gvtezygxdrurgafavvxx.supabase.co/storage/v1/object/public/images/book-cover.webp")),
            ),
          ),
        ],
      ),
    );
  }
}
