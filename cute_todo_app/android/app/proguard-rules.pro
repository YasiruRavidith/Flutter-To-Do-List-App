# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Flutter Local Notifications
-keep class com.dexterous.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class androidx.core.app.NotificationCompat** { *; }
-keep class androidx.core.app.NotificationManagerCompat** { *; }

# Notification models and classes
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# AndroidX
-keep class androidx.** { *; }
-keep interface androidx.** { *; }
-dontwarn androidx.**

# Timezone
-keep class net.time4j.** { *; }
-dontwarn net.time4j.**

# Keep notification receivers and services
-keep class * extends android.content.BroadcastReceiver
-keep class * extends android.app.Service
-keep class * extends android.content.ContentProvider

# Keep alarm manager related classes
-keep class * extends android.app.AlarmManager { *; }
-keepclassmembers class * {
    public void onReceive(android.content.Context, android.content.Intent);
}

# Kotlin
-dontwarn kotlin.**
-dontwarn kotlinx.**
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }

# Keep notification data classes
-keepclassmembers class ** {
    @android.os.Parcelable$Creator *;
}
