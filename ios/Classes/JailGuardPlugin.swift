import Flutter
import UIKit

public class JailGuardPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "jail_guard", binaryMessenger: registrar.messenger())
    let instance = JailGuardPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
    case "checkJailbreak":
        result(isJailbreak())
    default:
        result(FlutterMethodNotImplemented)
    }
  }
    
    private func isJailbreak() -> Bool {
        guard TARGET_OS_SIMULATOR == 0 else { return false }
        guard !canWritePrivate() else { return true }
        print("canWritePrivate --- false")
        guard !jailFileExist() else { return true }
        print("jailFileExist --- false")
        guard !isSeconIPA() else { return true }
        print("isSeconIPA --- false")
        /// 插入动态库 越狱插件是通过DYLD_INSERT_LIBRARIES插入的
        if getenv("DYLD_INSERT_LIBRARIES") != nil {
            return true
        }
        print("DYLD_INSERT_LIBRARIES --- nil")
        return false
    }
    
    /// 检测是否安装越狱系统的 App Store
    /// 不建议用，因为准确度可能不高，一方面 cydia 可能把这个 URL Scheme 改掉防止检测。另一方面正常手机也可能会有一个 app 的 URL Scheme 叫这个名字，造成误判。
//    private func canOpenCydia() -> Bool {
//        guard let url = URL(string: "cydia://") else { return false }
//        return UIApplication.shared.canOpenURL(url)
//    }
    
    /// 检测是否授予 root 权限，并且可以修改沙箱之外的文件
    private func canWritePrivate() -> Bool {
        let text = "hello jail!"
        do {
            try text.write(toFile: "/private/jailbreak_test.txt", atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
    
    /**
     Cydia  iOS系统上的第三方软件仓库，它包含了大量的越狱应用、插件和主题
     Sileo  iOS系统上的一个越狱应用商店，类似于App Store，只面向越狱设备
     Zebra 轻量级的软件包管理器，具有有用的功能，包括暗模式支持和批量添加存储库的功能
     AppSync 是iPhone、iPad、iPod touch越狱后最常安装的补丁，安装后可以绕过系统验证，随意安装、运行破解的ipa软件
     LibertyLite 屏蔽越狱状态，支付宝和微信壳开启面容和指纹识别
     OTADisabler 插件用来屏蔽iOS更新
     ...
     */
    private func jailFileExist() -> Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        let files = [
                "/private/var/lib/apt",
                "/Applications/Cydia.app",
                "/Applications/Sileo.app",
                "/Applications/RockApp.app",
                "/Applications/Icy.app",
                "/Applications/WinterBoard.app",
                "/Applications/SBSetttings.app",
                "/Applications/blackra1n.app",
                "/Applications/IntelliScreen.app",
                "/Applications/Snoop-itConfig.app",
                "/bin/sh",
                "/usr/libexec/sftp-server",
                "/usr/libexec/ssh-keysign /Library/MobileSubstrate/MobileSubstrate.dylib",
                "/bin/bash",
                "/usr/sbin/sshd",
                "/etc/apt /System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                "/Library/MobileSubstrate/DynamicLibraries/AppSync.plist"
            ]
        return files.contains(where: { FileManager.default.fileExists(atPath: $0) })
        #endif
    }
    
    /// 尝试调用系统 API  fork 方法
    /// 执行过fork的进程会分叉（复制）出一个新的进程 ，
    /// 三种返回值
    /// 子进程返回 0
    /// 父进程返回子进程pid
    /// 创建失败 -1
    ///
    /// error:  The process has forked and you cannot use this CoreFoundation functionality safely. You MUST exec().
//    private func canCallAPI() -> Bool {
//        let RTLD_DEFAILT = UnsafeMutableRawPointer(bitPattern: -2)
//        let forkPtr = dlsym(RTLD_DEFAILT, "fork")
//        typealias ForkType = @convention(c) () -> Int32
//        let fork = unsafeBitCast(forkPtr, to: ForkType.self)
//        return fork() != 1
//    }
    
    /// 是否是二次签名
    /// SignerIdentity值只有ipa包被反编译后篡改二进制文件再次打包，才会有此值
    private func isSeconIPA() -> Bool {
        guard let info = Bundle.main.infoDictionary, info["SignerIdentity"] != nil else { return false }
        return true
    }
}
