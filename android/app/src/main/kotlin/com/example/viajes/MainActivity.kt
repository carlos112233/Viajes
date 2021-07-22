package com.example.viajes

import android.content.Intent
import android.os.Handler
import android.os.Looper
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel;
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.TimeUnit

public class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "BackgroundServices").setMethodCallHandler { call, result ->
            if (call.method == "startServices") {
                val intent =  Intent(this, gpsServices::class.java)
                startService(intent);
                result.success("inicio servicio")
            }
        };
    }

}

