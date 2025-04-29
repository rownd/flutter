# Keep specific classes for Conscrypt
-keep class com.android.org.conscrypt.SSLParametersImpl { *; }
-keep class org.apache.harmony.xnet.provider.jsse.SSLParametersImpl { *; }
-keep class org.conscrypt.KitKatPlatformOpenSSLSocketImplAdapter { *; }
-keep class org.conscrypt.PreKitKatPlatformOpenSSLSocketImplAdapter { *; }

# Keep specific BouncyCastle classes
-keep class org.bouncycastle.jsse.BCSSLParameters { *; }
-keep class org.bouncycastle.jsse.BCSSLSocket { *; }
-keep class org.bouncycastle.jsse.provider.BouncyCastleJsseProvider { *; }

# Keep specific OpenJSSE classes
-keep class org.openjsse.javax.net.ssl.SSLParameters { *; }
-keep class org.openjsse.javax.net.ssl.SSLSocket { *; }
-keep class org.openjsse.net.ssl.OpenJSSE { *; }

# Keep SLF4J LoggerFactory class
-keep class org.slf4j.impl.StaticLoggerBinder { *; }

-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**
