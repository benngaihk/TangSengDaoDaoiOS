//
//  WKWebViewVC.h
//  WuKongBase
//
//  Created by tt on 2020/4/3.
//

#import "WKBaseVC.h"
#import <WuKongIMSDK/WuKongIMSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface WKWebViewVC : WKBaseVC

@property(nonatomic,strong) NSURL *url;

// 频道对象，如果是从聊天页面跳转到web请给channel赋值
@property(nonatomic,strong,nullable) WKChannel *channel;

/**
 * 使用缓存创建WebView控制器，相同URL的WebView会被缓存复用
 * @param url 要加载的URL
 * @return 返回一个WebView控制器实例
 */
+ (instancetype)cachedWebViewWithURL:(NSURL *)url;

/**
 * 清除所有WebView缓存
 */
+ (void)clearWebViewCache;

@end

NS_ASSUME_NONNULL_END
