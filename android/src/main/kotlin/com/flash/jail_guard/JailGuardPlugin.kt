package com.flash.jail_guard

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.BufferedReader
import java.io.File
import java.io.IOException
import java.io.InputStreamReader

/** JailGuardPlugin */
class JailGuardPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "jail_guard")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "checkJailbreak") {
      val isRoot = isRoot()
      println("your device is root $isRoot")
      result.success(isRoot)
    } else {
      result.notImplemented()
    }
  }

  /**
   * 判断手机是否root
   */
  fun isRoot(): Boolean {
    val binPath = "/system/bin/su"
    val xBinPath = "/system/xbin/su"
    return if (File(binPath).exists() && isCanExecute(binPath)) {
      true
    } else File(xBinPath).exists() && isCanExecute(xBinPath)
  }

  private fun isCanExecute(filePath: String): Boolean {
    var process: Process? = null
    try {
      process = Runtime.getRuntime().exec("ls -l $filePath")
      val `in` = BufferedReader(InputStreamReader(process.inputStream))
      val str: String = `in`.readLine()
      if (str != null && str.length >= 4) {
        val flag = str[3]
        if (flag == 's' || flag == 'x') return true
      }
    } catch (e: IOException) {
      e.printStackTrace()
    } finally {
      process?.destroy()
    }
    return false
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
