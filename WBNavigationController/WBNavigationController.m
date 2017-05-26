//
//  WBNavigationController.m
//  WBNavigationExample
//
//  Created by wans on 2017/5/25.
//  Copyright © 2017年 wans. All rights reserved.
//

#import "WBNavigationController.h"
#import "objc/runtime.h"

static void *paramsKey      = &paramsKey;
static void *replyActionKey = &replyActionKey;

@implementation WBNode

@end

@implementation UIViewController (URL)

- (id)setupNode:(WBCompleteAction)action {
    WBNode *node = [WBNode new];
    node.animate = YES; // 默认使用动画
    action(node);
    
    return node;
}

- (instancetype)initWithParams:(id)params {

    return [self initWithParams:params replyAction:nil];
}

#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)initWithParams:(id)params replyAction:(WBReplyAction)replyAction {

    self = [super init];
    if ( self ) {
        
        self.wb_params = params;
        
        self.wb_replyAction = replyAction;
    }
    
    return self;
}

- (void)wb_pushSimpleViewController:(NSString *)url {

    [self wb_pushViewController:^(WBNode *node) {
        node.url = url;
    }];
}

- (void)wb_pushViewController:(WBParams)params {

    WBNode *node = [self setupNode:params];

    Class vcClass = [WBNavigationController findViewControllerClassWithUrl:node.url];
    if ( !vcClass ) {
        NSLog(@"URL:%@ not register", node.url);
    }
    UIViewController *controller = [[vcClass alloc] initWithParams:node.params replyAction:node.replyAction];
    
    [[WBNavigationController sharedInstance] pushViewController:controller animated:node.animate];
}

- (void)wb_popViewController {
    [self wb_popViewControllerAnimate:YES];
}

- (void)wb_popViewControllerAnimate:(BOOL)animated {
    [[WBNavigationController sharedInstance] popViewControllerAnimated:animated];
}

- (void)wb_popToRootViewControllerAnimated:(BOOL)animated {
    [[WBNavigationController sharedInstance] popToRootViewControllerAnimated:animated];
}

- (void)wb_popToViewControllerWithUrl:(NSString *)url animated:(BOOL)animated {
    UIViewController *vc = [WBNavigationController findViewControllerIfExistWithUrl:url];
    if ( vc ) {
        [[WBNavigationController sharedInstance] pushViewController:vc animated:animated];
    }
}

- (void)wb_presentViewController:(WBParams)params {

    WBNode *node = [self setupNode:params];
    
    Class vcClass = [WBNavigationController findViewControllerClassWithUrl:node.url];
    if ( !vcClass ) {
        NSLog(@"URL:%@ not register", node.url);
    }
    UIViewController *controller = [[vcClass alloc] initWithParams:node.params replyAction:node.replyAction];
    
    [self presentViewController:controller animated:node.animate completion:node.completeAction];
}

- (void)wb_presentSimpleViewController:(NSString *)url {
    
    [self wb_presentViewController:^(WBNode *node) {
        node.url = url;
    }];
}

- (void)wb_dismissSimpleViewController {
    
    [self wb_dismissViewControllerAnimated:YES completion:nil];
}

- (void)wb_dismissViewControllerAnimated:(BOOL)animated completion:(WBCompleteAction)completion {

    [self dismissViewControllerAnimated:animated completion:completion];
}

#pragma mark Getter && Setter

- (id)wb_params {
    return objc_getAssociatedObject(self, paramsKey);
}

- (void)setWb_params:(id)wb_params {
    objc_setAssociatedObject(self, paramsKey, wb_params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WBReplyAction)wb_replyAction {
    return objc_getAssociatedObject(self, replyActionKey);
}

- (void)setWb_replyAction:(WBReplyAction)wb_replyAction {
    objc_setAssociatedObject(self, replyActionKey, wb_replyAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@interface WBNavigationController ()

@property (nonatomic, strong) NSMutableDictionary *registerVCCls;

@end

@implementation WBNavigationController

+ (instancetype)sharedInstance {
    static WBNavigationController *navigationController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        navigationController = [[WBNavigationController alloc] init];
    });
    return navigationController;
}

+ (void)registerWithUrl:(NSString *)url viewControllerClass:(Class)cls {
    
    [WBNavigationController sharedInstance].registerVCCls[url] = cls;
}

+ (void)removeViewControllerWithUrl:(NSString *)url {

    NSMutableArray *viewControllers = [[WBNavigationController sharedInstance].viewControllers mutableCopy];
    UIViewController *targetVC = [[self class] findViewControllerIfExistWithUrl:url];
    
    if ( [viewControllers containsObject:targetVC] ) {
        [viewControllers removeObject:targetVC];
    }
    
    [WBNavigationController sharedInstance].viewControllers = viewControllers;
    
}

+ (Class)findViewControllerClassWithUrl:(NSString *)url {

    return [WBNavigationController sharedInstance].registerVCCls[url];
}

+ (BOOL)existViewControllerWithUrl:(NSString *)url {

    NSMutableArray *viewControllers = [[WBNavigationController sharedInstance].viewControllers mutableCopy];
    UIViewController *targetVC = [[self class] findViewControllerIfExistWithUrl:url];
    
    if ( [viewControllers containsObject:targetVC] ) {
        return YES;
    }
    
    return NO;
}

+ (UIViewController *)findViewControllerIfExistWithUrl:(NSString *)url {

    Class vcClassName = [[self class] findViewControllerClassWithUrl:url];
    for (UIViewController *vc in [WBNavigationController sharedInstance].viewControllers) {
        if ( vcClassName == vc.class ) {
            return vc;
        }
    }
    
    return nil;
}

+ (void)deregisterUrl:(NSString *)url {
    
    [[WBNavigationController sharedInstance].registerVCCls removeObjectForKey:url];
}

#pragma mark Getter

- (NSMutableDictionary *)registerVCCls {
    if( !_registerVCCls ) {
        _registerVCCls = [@{} mutableCopy];
    }
    return _registerVCCls;
}

@end
