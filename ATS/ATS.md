#NSAppTransportSecurity

从iOS9、OSX10.11开始Apple提供了一种叫ATS(App Transport Security)的新的安全特性，而且是默认可用的。它通过强制对Http基础网络请求使用额外的安全需求来提高app和web之间的连接的隐私性和数据的完整性。特定的，使用ATS的时候，Http连接必须使用Https。


###ATS使用TSL1.2

NSURLSession和它使用的所有API都会强制使用ATS。当你将你的应用链接到iOS9.0或OSX10.11或更高版本的时候，ATS会自动的开启。

如果你需要禁用ATS,不管是全局或者特定域,系统都会提供标准HTTPS安全措施。If your app makes an HTTPS request the system performs server trust evaluation per RFC 2818.

如果你的app只使用安全的网络连接，同时，这些连接使用最佳的网络参数，你就不需要使用NSAppTransportSecurity。

如果你的应用是链接到比iOS9.0或OSX10.11更老的系统版本，你的网络连接会继续工作，但是ATS将不可用，无论你的应用运行在哪个版本的系统上。ATS在比iOS9.0和OSX10.11更老的版本的系统上不可用，这些老的系统会忽略NSAppTransportSecurity。

下面是所有NSAppTransportSecurity中可能用到的key，所有的key都是可选的。

```

NSAppTransportSecurity : Dictionary {
    NSExceptionDomains : Dictionary {
        <domain-name-string> : Dictionary {
            NSIncludesSubdomains : Boolean
            // Keys to describe your app’s intended network behavior for
            //    domains whose security attributes you control
            NSExceptionAllowsInsecureHTTPLoads : Boolean
            NSExceptionRequiresForwardSecrecy : Boolean
            NSExceptionMinimumTLSVersion : String
            // Keys to describe your app’s intended network behavior for
            //    domains whose security attributes you don't control
            NSThirdPartyExceptionAllowsInsecureHTTPLoads : Boolean
            NSThirdPartyExceptionRequiresForwardSecrecy : Boolean
            NSThirdPartyExceptionMinimumTLSVersion : String
        }
    }
    NSAllowsArbitraryLoads : Boolean
}
```

####下表提供了NSAppTransportSecurity字典中中主要的key:

| Key | Xcode name| Type| Description
| --- |--- | ---  |---
| NSExceptionDomains     | Exception Domains | Dictionary | 一个可选的字典，指定ATS例外的域。每一个值是一个字典，详细的描述了一个例外的网络连接域.<br><br>一个例外的域的顶级key是你想指定的域的名字,例如,www.aoole.com。一个域的名字需要遵循下面的规则:<br><br> 1.必须为小写字母<br>2.不能包含端口号<br>3.不能是数字的IP地址，而应该是一个字符串<br>4.不能以点结尾，除非你想匹配一个以点结尾的域。(例如example.com. 它匹配的是“https://example.com.”而不是“https://example.com”) |
| NSAllowsArbitraryLoads | Allow Arbitrary Loads | Boolean | 一个可选的布尔值，设置为YES时,禁用所有域的ATS，除非你重新通过添加额外的域启用ATS，否则整个应用的ATS都不可用。<br>当你的应用允许用户指定随意的URL时,启用这个key。<br>启用整个key对调试和开发也比较有用。<br>禁用ATS允许连接不理会配置是HTTP还是HTTPS，允许连接到使用低版本TSL的服务器，同时允许连接使用不支持前向安全的密码套件.<br>对于那些没有指定特殊域的的连接来说这个值默认为NO。(This key’s default value of NO results in default ATS behavior for all connections except those for which you have specified an exception domain dictionary)|


####在以下两种情况下可以使用一个额外域字典来配置一个指定的服务器。

1. 从iOS9.0或OSX10.11开始,全局范围内ATS默认为开启，这个时候你可以使用额外域字典来移除ATS对某个特定服务器的限制。例如,设置服务器的NSExceptionAllowsInsecureHTTPLoads为YES，允许该服务器不安全的HTTP连接。
2. 如果ATS在全局范围禁用(通过设置NSAllowsArbitraryLoads为YES),这个情况下你可以使用额外域字典在一个特定服务器上增加ATS限制。例如,设置服务器的NSExceptionAllowsInsecureHTTPLoads为NO,让该服务器强制使用HTTPS。

#####下面展示了你的app中配置例外网络行为的所有的key。

|Key|Type| Description|
|---|---|---|
| NSIncludesSubdomains | Boolean |一个可选的Boolean值,当设置为YES的时候,所有名称在NSExceptionDomains字典中的子域将使用ATS.<br>默认为NO|
| NSExceptionAllowsInsecureHTTPLoads | Boolean |-|
| NSExceptionRequiresForwardSecrecy | Boolean |-|
| NSExceptionMinimumTLSVersion | String |-|
| NSThirdPartyExceptionAllowsInsecureHTTPLoads | Boolean |-|
| NSThirdPartyExceptionRequiresForwardSecrecy | Boolean |-|
| NSThirdPartyExceptionMinimumTLSVersion | String |-|