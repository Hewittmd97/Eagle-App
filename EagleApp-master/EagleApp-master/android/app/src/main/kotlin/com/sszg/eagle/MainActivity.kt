package com.sszg.eagle

import android.Manifest
import android.os.Bundle
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.os.BatteryManager
import android.os.Build
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.widget.Toast
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/battery"
    private val CHANNEL2 = "samples.flutter.dev/phoneCall"
    var PERMISSION_ALL = 1
    var PERMISSIONS =
            arrayOf(Manifest.permission.READ_CONTACTS, Manifest.permission.CALL_PHONE)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        if (!hasPermissions(this, PERMISSIONS)) {
//            Activ.requestPermissions(this, PERMISSIONS, PERMISSION_ALL)
//        }
        GeneratedPluginRegistrant.registerWith(this)
        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            // Note: this method is invoked on the main thread.
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
        MethodChannel(flutterView, CHANNEL2).setMethodCallHandler { call, result ->
            // Note: this method is invoked on the main thread.
            if (call.method == "makePhoneCall") {
                callDirect(this, "2142188976", result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun callDirect(mContext: Context, number: String, result: MethodChannel.Result) {
        try {
            val callIntent = Intent(Intent.ACTION_CALL)
            callIntent.data = Uri.parse("tel:$number")
            mContext.startActivity(callIntent)
            result.success("Made phone call")
        } catch (e: SecurityException) {
            Toast.makeText(mContext, "Need call permission", Toast.LENGTH_LONG).show()
            result.error("UNAVAILABLE", "Need call permission", null)
        } catch (e: Exception) {
            e.printStackTrace()
            Toast.makeText(mContext, "No SIM Found", Toast.LENGTH_LONG).show()
            result.error("UNAVAILABLE", "No SIM Found", null)
        }
    }

//    private fun hasPermissions(context: Context?, permissions: Array<String>?): Boolean {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && context != null && permissions != null) {
//            for (permission in permissions) {
//                if (ActivityCompat.checkSelfPermission(
//                                context,
//                                permission
//                        ) != PackageManager.PERMISSION_GRANTED
//                ) {
//                    return false
//                }
//            }
//        }
//        return true
//    }

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        batteryLevel = if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

        return batteryLevel
    }
}
