//
//  UIControl+SDTrack.m
//  sdtrack
//
//  Created by lisd on 2017/4/26.
//  Copyright © 2017年 kingnet. All rights reserved.
//

#import "UIControl+SDTrackTool.h"
#import "SDTrackTool.h"

@implementation UIControl (SDTrackTool)
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(sd_sendAction:to:forEvent:);
        [SDTrackTool swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
    });
}


- (void)sd_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    //插入埋点代码
    [self trackAction:action to:target forEvent:event];
    //回归原方法
    [self sd_sendAction:action to:target forEvent:event];
}

- (void)trackAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
//    NSString *className =  NSStringFromClass([self class]);
    NSString *eventID = nil;
    //只统计触摸结束时
    if ([[[event allTouches] anyObject] phase] == UITouchPhaseEnded) {
        NSString *actionString = NSStringFromSelector(action);
        NSString *targetName = NSStringFromClass([target class]);
        NSDictionary *configDict = [self getConfigDict];
        NSLog(@"actionString: %@", actionString);
        eventID = configDict[targetName][@"ControlEventIDs"][actionString];
    }
    if (eventID != nil) {
        [SDTrackTool logEvent:eventID];
    }
}

- (NSDictionary *)getConfigDict {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SDTrackEvents" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSLog(@"%@", dic);
    return dic;
}

@end
