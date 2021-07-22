package com.example.viajes

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log
import android.widget.Toast
import java.text.SimpleDateFormat
import java.time.LocalDateTime
import java.util.*
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.TimeUnit


class gpsServices() : Service() {

    private val TAG = "BackgroundSoundService"

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_NOT_STICKY
    }
    override fun onBind(intent: Intent): IBinder {
        TODO("Return the communication channel to the service.")
    }
    override fun onCreate() {
        super.onCreate()
        val backgroundExecutor: ScheduledExecutorService = Executors.newScheduledThreadPool( 2 )

            backgroundExecutor.scheduleAtFixedRate({
                val date = Calendar.getInstance().time
                val formatter = SimpleDateFormat("dd-MM-yyyy hh:mm:ss a") //or use getDateInstance()
                val formatedDate = formatter.format(date)
                println("Hello, world!!! ${formatedDate}")

            }, 0,10, TimeUnit.SECONDS)



        Log.i(TAG, "onCreate() , service started...")
    }
    fun onStop() {
        Log.i(TAG, "onStop()")
    }

    fun onPause() {
        Log.i(TAG, "onPause()")
    }

    override fun onDestroy() {

        Toast.makeText(applicationContext,"service stopped",Toast.LENGTH_SHORT).show()
        Log.i(TAG, "onCreate() , service stopped...")
    }

    override fun onLowMemory() {
        Log.i(TAG, "onLowMemory()")
    }
}