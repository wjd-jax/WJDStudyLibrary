platform:ios, ‘8.0’
inhibit_all_warnings!

target “WJDStudyLibrary” do
    
    # 专门用于转换 Array/Dictionary -> 对象模型 主要用于JSON解析，基本都用这个框架（必会）
    pod 'MJExtension'
    
    pod 'AFNetworking'
    
    # 网络状态检测库,苹果官方承认的
    pod 'Reachability'
    
    # 加密解密,证书相关,SSL是安全套接字层的缩写
    pod 'OpenSSL'
    
    pod 'SDWebImage'
    
    # 图像处理,摄像头处理,C++代码,需要有C++基础,如果pod失败,那就指定3.0.0版本亲测可用
    pod 'OpenCV', '~> 3.0.0' #inhibit_warnings => true
    
    #pod 'MLeaksFinder' #内存泄漏检测,无代码入侵,实际不太好用
    
    # 友盟分享
    pod 'UMengUShare/Social/ReducedWeChat'
    pod 'UMengUShare/Social/ReducedQQ'
    pod 'UMengUShare/Social/ReducedSina'
    
    #pod 'OpenCV-Dynamic'
    
    # Aspect库是对面向切面编程(Aspect Oriented Programming)的实现，里面封装了Runtime的方法，也封装了上文的Method Swizzling方法。因此我们也可以看到，Method Swizzling也是AOP编程的一种。Aspect的用途很广泛，这里不具体展开，想了解更多的可以看一下官方github的介绍，已经够详细了。
    # pod "Aspects"
    
    # 友盟统计
    #pod 'UMengAnalytics-NO-IDFA'
    
    # 一个支持多选、选原图和视频的图片选择器，同时有预览功能，适配了iOS6789系统。
    #    pod 'TZImagePickerController'
    
    # wifi文件传输,推荐GCDWebServer一直更新中
    pod 'CocoaHTTPServer', '~> 2.3'
    pod 'GCDWebServer'
    
    # iOS自定义Badge组件, 支持UIView, UITabBarItem, UIBarButtonItem
    pod 'PPBadgeView'
    
    #FMDB对象化封装
    pod 'LKDBHelper'
end

