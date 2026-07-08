package com.example.mantra_de_la_riqueza

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.mantra_de_la_riqueza/migration"
        ).setMethodCallHandler { call, result ->
            if (call.method == "clearNotificationCache") {
                // Resets the flutter_local_notifications SharedPreferences to a
                // valid empty JSON array so that loadScheduledNotifications() no
                // longer throws "Missing type parameter" on stale v<18 data.
                applicationContext
                    .getSharedPreferences("scheduled_notifications", Context.MODE_PRIVATE)
                    .edit()
                    .putString("scheduled_notifications", "[]")
                    .apply()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}
