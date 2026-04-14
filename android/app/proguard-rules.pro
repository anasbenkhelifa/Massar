## Flutter-specific ProGuard rules

# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }

# Keep annotations
-keepattributes *Annotation*

# Keep Dart entry point
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }

# Shared Preferences
-keep class androidx.datastore.** { *; }

# Remove debug logging
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
}

# Suppress warnings for Play Core deferred components (referenced by Flutter engine but not used)
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
