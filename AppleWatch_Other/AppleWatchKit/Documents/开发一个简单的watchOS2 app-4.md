## 开发一个简单的 watchOS2 app-4

## Watch Connectivity

WatchConnectivity 框架所扮演的角色就是 iOS app 和 watch extension 之间的桥梁，利用这个框架你可以在两者之间互相传递数据。

在 watchOS 1 时代，watch 的 extension 是和 iOS app 一样，存在于手机里的。所以在 watch extension 和 iOS app 之间共享数据是比较简单的，和其他 extension 类似，使用 app group 将 app 本体和 extension 设为同一组 app，就可以在一个共享容器中共享数据了。

但是这在 watchOS 2 中发生了改变。因为 watchOS 2 的手表 extension 是直接存在于手表中的，所以之前的 app group 的方法对于 watch app 来说已经失效。Watch extension 现在会使用自己的一套数据存储 (如果你之前注意到了的话，我们在请求数据后将它存到了 UserDefaults 中，但是手机和手表的 UserDefaults 是不同的，所以我们不用担心数据被不小心覆盖)。如果我们想要在 iOS 设备和手表之间共享数据的话，我们需要使用新的 Watch Connectivity 框架。

在这个例子中，我们会用 WatchConnectivity 来改善我们的天气 app 的表现 -- 我们打算实现无论在手表还是 iOS app 中，每天最多只进行一次请求。在一个设备上请求后，我们会把数据传递到配对的另一个设备上，这样在另一个设备上打开 app 时，就可以直接显示天气状况，而不再需要请求一次了。

我们在 iOS app 和 watchOS app 中都可以使用 WatchConnectivity。首先我们需要检查设备上是否能使用 session，因为在一部分设备 (比如 iPad) 上，这个框架是不能使用的。这可以通过 WCSession.isSupported() 来判断。在确认平台上可以使用后，我们可以设定 delegate 来监听事件，然后开始这个 session。当我们有一个已经启动的 session 后，就可以通过框架的方法来向配对的另一个设备发送数据了。

大致来说数据发送分为后台发送和即时消息两类。当 iOS app 和 watch app 都在前台的时候，我们可以通过 -sendMessage:replyHandler:errorHandler: 来在两者之间发送消息，这在 iOS app 和 watch app 之间需要互动的时候是非常有用的。

另一种是后台发送，在 iOS 或 watch app 中有一者不在前台时，我们就需要考虑使用这种方式。后台通讯有三种方式：通过 Application Context，通过 User Info，以及传送文件。

文件传送简单明了就是传递一个文件，另外两个都是传递一个字典，不同之处在于 Application Context 将会使用新的数据覆盖原来的内容，而 User Info 则可以使多次内容形成队列进行传送。

每种方式都会在另外一方的 session 开始运行后调用相应的 delegate 方法，于是我们就能知道有数据发送过来了。

结合天气 app 的特点，我们应该选择使用 Application Context 来收发数据。我们这里只做从 iOS 到 watchOS 的发送了，因为反过来的代码其实完全一样。

首先是在 iOS app 中启动 session。在 MainViewController.swift 中添加一个属性：var session: WCSession?，然后在 viewDidLoad: 中添加：

```
if WCSession.isSupported() {  
    session = WCSession.defaultSession()
    session!.delegate = self
    session!.activateSession()
}
```

为了让 self 成为 session 的 delegate，需要实现 WCSessionDelegate。这里我们先在文件最后添加一个 extension 即可：

```
extension MainViewController: WCSessionDelegate {
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        guard let dictionary = applicationContext[kWeatherResultsKey] as? [String : AnyObject] else {
            return
        }
        guard let date = applicationContext[kWeatherRequestDateKey] as? NSDate else {
            return
        }
        Weather.storeWeathersResult(dictionary, requestDate: date)
    }
}
```

注意我们一定需要设定 session 的 delegate，即使它什么都没有做。一个没有 delegate 的 session 是不能被启动或正确使用的。

然后就是发送数据了。在 requestWeathers 的回调中，数据请求一切正常的分支最后，添加一段

```
if error == nil && weather != nil {  
    //...
    if let dic = Weather.storedWeathersDictionary() {
        do {
            try self.session?.updateApplicationContext(dic)
        } catch _ {

        }
    }
} else {
    ...
}
```

这里的 storedWeathersDictionary 是个新加入的方法，它返回存储在 User Defaults 中的内容的字典表现形式 (我们在请求返回的时候就已经将结果内容存储在 User Defaults 里了，希望你还记得)。

```
static func storedWeathersDictionary() -> [String: AnyObject]? {
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        if let date = userDefault.objectForKey(kWeatherRequestDateKey) as? NSDate,
            dic = userDefault.objectForKey(kWeatherResultsKey) as? [String: AnyObject] {
                return [kWeatherResultsKey: dic, kWeatherRequestDateKey: date]
        } else {
            return nil
        }
    }
```

在 watchOS app 一侧，我们类似地启动一个 session。在 InterfaceController.swift 的 awakeWithContext 中的 dispatch_once 里，添加

```
if WCSession.isSupported() {  
    InterfaceController.session = WCSession.defaultSession()
    InterfaceController.session!.delegate = self
    InterfaceController.session!.activateSession()
}
```

然后添加一个 extension 来接收传输过来的数据：

```
extension InterfaceController: WCSessionDelegate {  
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        guard let dictionary = applicationContext[kWeatherResultsKey] as? [String: AnyObject] else {
            return
        }
        guard let date = applicationContext[kWeatherRequestDateKey] as? NSDate else {
            return
        }
        Weather.storeWeathersResult(dictionary, requestDate: date)
    }
}
```

最后，在请求数据之前我们可以判断一下已经存储在 User Defaults 中的内容是否是今天请求的。如果是的话，就不再需要进行请求，而是直接使用存储的内容来刷新界面，否则的话进行请求并存储。将原来的 self.request() 改为：

```
dispatch_async(dispatch_get_main_queue()) { () -> Void in  
    if self.shouldRequest() {
        self.request()
    } else {
        let (_, weathers) = Weather.storedWeathers()
        if let weathers = weathers {
            self.updateWeathers(weathers)
        }
    }
}
```

如果你只是单纯地 copy 这些代码的话，在之前项目的基础上应该是不能编译的。这是因为在这里我并没有列举出所有的改动，而只是写出了关于 WatchConnectivity 的相关内容。

这里涉及到了每次启动或者从后台切换到 app 时都需要检测并刷新界面，所以我们还需要一些额外的重构来达到这个目的。

同理，在 watchOS app 需要请求，并且请求结束的时候，我们也可以如前所述，通过几乎一样的代码和方式将请求得到的内容发回给 iOS app。这样，当我们打开 iOS app 时，也就不需要再次进行网络请求了。

这部分的完整的代码在demo中

### 总结

本文从零开始完成了一个 iOS 和 Apple Watch 上的天气情况的 app。虽然说数据源上用的是一个 stub，但是在其他方面还算是比较完整的。本来主要的目的是探索下 watchOS 2 中的几个新 API 的用法，主要是 complication 和 WatchConnectivity。