/// Boot markers: web builds write to document.title (visible in headless
/// CI/release), VM/test builds keep the marks in memory.
library;
export 'boot_mark_stub.dart' if (dart.library.js_interop) 'boot_mark_web.dart';
