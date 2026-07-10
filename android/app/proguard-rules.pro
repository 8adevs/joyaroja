# flutter_local_notifications uses Gson + RuntimeTypeAdapterFactory, which calls
# getSimpleName() on StyleInformation subclasses to build the JSON "type" field.
# R8 obfuscates those names in release builds, making the receiver crash at
# alarm-fire time when it can't match the stored type string to any registered
# subclass. Keep the entire plugin package to prevent this.
-keep class com.dexterous.** { *; }

# Gson internals required for reflection-based (de)serialisation
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
