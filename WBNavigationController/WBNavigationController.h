//
//  WBNavigationController.h
//  WBNavigationExample
//
//  Created by wans on 2017/5/25.
//  Copyright © 2017年 wans. All rights reserved.
//

#import <UIKit/UIKit.h>

// 快速注册viewcontroller
#undef	WB_IMPLEMENT_LOAD
#define WB_IMPLEMENT_LOAD( url ) \
+ (void)load { \
@autoreleasepool { \
    [WBNavigationController registerWithUrl:url viewControllerClass:[self class]]; \
} \
}

@class WBNode;

typedef void (^WBReplyAction)(id result);
typedef void (^WBCompleteAction)();

typedef void (^WBParams)(WBNode *node);

@interface WBNode : NSObject

@property (nonatomic, strong) NSString       *url;

@property (nonatomic, assign) BOOL           animate;

@property (nonatomic, strong) id             params;

@property (nonatomic, copy) WBCompleteAction completeAction;

@property (nonatomic, copy) WBReplyAction    replyAction;

@end

@interface UIViewController (URL)

@property (nonatomic, strong) id             wb_params;

@property (nonatomic, copy) WBReplyAction    wb_replyAction; 

- (instancetype)initWithParams:(id)params;
- (instancetype)initWithParams:(id)params replyAction:(WBReplyAction)replyAction;

- (void)wb_pushViewController:(WBParams)params;
- (void)wb_pushSimpleViewController:(NSString *)url;

- (void)wb_popViewController;
- (void)wb_popViewControllerAnimate:(BOOL)animated;
- (void)wb_popToRootViewControllerAnimated:(BOOL)animated;
- (void)wb_popToViewControllerWithUrl:(NSString *)url animated:(BOOL)animated;

- (void)wb_presentViewController:(WBParams)params;
- (void)wb_presentSimpleViewController:(NSString *)url;

- (void)wb_dismissSimpleViewController;
- (void)wb_dismissViewControllerAnimated:(BOOL)animated completion:(WBCompleteAction)completion;

@end

@interface WBNavigationController : UINavigationController

+ (instancetype)sharedInstance;

+ (void)registerWithUrl:(NSString *)url viewControllerClass:(Class)cls;

+ (void)removeViewControllerWithUrl:(NSString *)url;

+ (Class)findViewControllerClassWithUrl:(NSString *)url;

+ (BOOL)existViewControllerWithUrl:(NSString *)url;

+ (UIViewController *)findViewControllerIfExistWithUrl:(NSString *)url;

+ (void)deregisterUrl:(NSString *)url;

@end
