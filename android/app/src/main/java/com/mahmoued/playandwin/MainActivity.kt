package com.mahmoued.playandwin

import android.content.pm.PackageManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.security.MessageDigest

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pw/sig")
            .setMethodCallHandler { call, result ->
                if (call.method == "sha1") {
                    try {
                        val sigs = if (Build.VERSION.SDK_INT >= 28) {
                            val pi = packageManager.getPackageInfo(
                                packageName, PackageManager.GET_SIGNING_CERTIFICATES
                            )
                            pi.signingInfo.apkContentsSigners
                        } else {
                            @Suppress("DEPRECATION")
                            val pi = packageManager.getPackageInfo(
                                packageName, PackageManager.GET_SIGNATURES
                            )
                            @Suppress("DEPRECATION")
                            pi.signatures
                        }
                        val md = MessageDigest.getInstance("SHA-1")
                        val d = md.digest(sigs[0].toByteArray())
                        result.success(d.joinToString(":") { "%02X".format(it) })
                    } catch (e: Exception) {
                        result.success("err " + e.toString())
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
