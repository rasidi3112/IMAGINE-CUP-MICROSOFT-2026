# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep models to prevent JSON parsing issues
-keep class com.agrivision.agrivision_ntb.models.** { *; }
-keepnames class * extends java.lang.Enum

# Keep specific plugins
-keep class com.baseflow.permissionhandler.** { *; }
-keep class com.baseflow.geolocator.** { *; }
-keep class io.flutter.plugins.camera.** { *; }
-keep class io.flutter.plugins.imagepicker.** { *; }
-keep class com.tekartik.sqflite.** { *; }
-keep class io.flutter.plugins.share.** { *; }
-keep class io.flutter.plugins.urllauncher.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }

# Prevent obfuscation of generic types
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod

# Don't warn about missing classes (standard fix)
-dontwarn io.flutter.**
-dontwarn flutter.indexing.**
-dontwarn javax.annotation.**
-dontwarn sun.misc.**
