package com.example.viajes

import android.annotation.SuppressLint
import android.app.Service
import android.content.Intent
import android.location.Location
import android.os.IBinder
import android.widget.Toast
import com.google.android.gms.location.FusedLocationProviderClient

class gpsServices() : Service() {
    private lateinit var fusedLocationClient: FusedLocationProviderClient
      var latitud:Double = 0.0;
    var longitud:Double = 0.0;
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        obtieneLocalizacion();

        Toast.makeText(applicationContext, "Inicio el servicio de posicionamiento", Toast.LENGTH_LONG).show();
        return START_NOT_STICKY
    }
    override fun onBind(intent: Intent): IBinder {
        TODO("Return the communication channel to the service.")
    }
    @SuppressLint("MissingPermission")
    private fun obtieneLocalizacion(){
        fusedLocationClient.lastLocation
                .addOnSuccessListener { location: Location? ->
                    latitud = location?.latitude!!
                    longitud = location?.longitude
                }
    }
}