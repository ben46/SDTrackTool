//
//  SDTrackTool.m
//  sdtrack
//
//  Created by lisd on 2017/4/26.
//  Copyright © 2017年 kingnet. All rights reserved.
//

#import "SDTrackTool.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <objc/runtime.h>

@implementation SDTrackTool

+ (void)configure {
//    UMConfigInstance.appKey = UMENG_KEY;
//    UMConfigInstance.eSType = E_UM_NORMAL;
////    UMConfigInstance.ePolicy = 0;
//    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
//    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:currentVersion];
//    [MobClick startWithConfigure:UMConfigInstance];
//
//#ifdef DEBUG
//    [MobClick setLogEnabled:YES];
//    [MobClick setCrashReportEnabled:NO];
//#endif
}

+(void)beginLogPageID:(NSString *)pageID {
    [MobClick beginLogPageView:pageID];
}

+(void)endLogPageID:(NSString *)pageID {
    [MobClick endLogPageView:pageID];
}

+(void)logEvent:(NSString*)eventId {
    [MobClick event:eventId];
}


+ (void)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
    Class class = cls;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
