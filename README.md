## XCSRouter

#### 一、介绍
基于 NSMutableDictionary 的路由跳转器，通过将注册的 url 或者 key 来进行界面跳转，比如小厨说 App 中跳转到课程详情界面代码如下：

``` 
 [XCSRouter routerUrl:@"xcs://course?id=123"];
```

#### 二、适用场景

1. 基于点击推送通知跳转到指定的界面；
2. 页面中点击广告，跳转到不同的业务界面。


#### 三、详细使用方式

**注册协议**：通过注册协议来获取指定如何响应响应的 url，注册方式如下:

```
/* 方式一 */
[XCSRouter registerRouterUrl:@"your urlkey" toHandlder:^(NSDictionary *params) {
   SecondController *aVc = [[SecondController alloc] init];
   [self presentViewController:aVc animated:YES completion:nil];
   return aVc;
}];    
```

block方式需要注意内存泄露，而且如果不太喜欢这种方式可以试试这样注册：
    
```
/* 方式二 */
[XCSRouter registerRouterUrl:@"your urlkey" toControllerClassStr:@"SecondController"];
```
这种方式需要默认的是从当前界面 Push 出来，如果需要在跳转前做更多的准备工作，可以通过实现 *XCSRouterRequestProtocl* 来定义。


**界面跳转**：通过 *router:urlStr* 来跳转对应 url 的界面，方法描述如下：

``` 
/**
 根据协议路径跳转

 @param urlStr url协议路径
 */
+ (void)router:(NSString *)urlStr;
```
使用如下：
```
[XCSRouter routerUrl:@"your url key"];
```

**定义参数**：如果想给跳转的界面传值，只需要像访问 url 传值一样，如下：

```
[XCSRouter routerUrl:@"your url key?参数1=a&参数2=b"];
```
如果你使用的是 block 的注册方式，可以在 block 的回调中拿到参数值，如果你是使用方式二的话，需要实现 *XCSRouterRequestProtocl* 在协议中的 *XCSRouterRequeset:request* 方法中获取，具体可见代码。

欢迎提交修改，提出Bug，以及宝贵的建议👏

