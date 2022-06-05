package com.example.final_project

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterActivity(), MethodChannel.MethodCallHandler {

    private val CHANNEL_NAME = "whatsappShare"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME).setMethodCallHandler {
            call, result ->
            /// Code function asd
            onMethodCall(call, result)
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "sharePdf") {
            sharePdf(call, result)
        }
    }

    private fun sharePdf(call: MethodCall, result: MethodChannel.Result) {
        val filePath: String? = call.argument("filePath")
        val numberPhone: String? = call.argument("phone")
        val outputFile: File? = File(filePath)
        val uri = Uri.fromFile(outputFile)
        val newUri = Uri.parse(uri.path?.replace("file", "content"))
        val intent = Intent()
        intent.action = Intent.ACTION_SEND
        intent.type = "application/pdf"
        intent.putExtra("id", "$numberPhone@s.whatsapp.net")
        intent.putExtra(Intent.EXTRA_STREAM, newUri)
        intent.setPackage("com.whatsapp")
        activity.startActivity(intent)
        return result.success("Result Oke")
    }
}
