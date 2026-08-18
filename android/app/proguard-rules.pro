# Stripe Push Provisioning is not bundled; R8 must not fail on those refs.
-dontwarn com.stripe.android.pushProvisioning.**
-dontwarn com.reactnativestripesdk.pushprovisioning.**

-keep class com.stripe.android.pushProvisioning.** { *; }
-keep class com.reactnativestripesdk.pushprovisioning.** { *; }

-keepclassmembers class com.google.android.gms.tapandpay.** {
  public *;
}
