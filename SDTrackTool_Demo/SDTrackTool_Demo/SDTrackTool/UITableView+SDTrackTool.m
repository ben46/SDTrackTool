//
//  UITableView+SDTrackTool.m
//  SDTrackTool_Demo
//
//  Created by nobby heell on 2019/2/14.
//  Copyright © 2019年 lisd. All rights reserved.
//

#import "UITableView+SDTrackTool.h"
#import "SDTrackTool.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation UITableView (SDTrackTool)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(setDelegate:);
        SEL swizzledSelector = @selector(sd_setDelegate:);
        [SDTrackTool swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
    });
}

- (void)sd_setDelegate:(id<UITableViewDelegate>)delegate{
    [self sd_setDelegate:delegate];
    Class class = [delegate class];
    if (class_addMethod(class, NSSelectorFromString(@"tracking_didSelectRowAtIndexPath"), (IMP)tracking_didSelectRowAtIndexPath, "v@:@@")) {
        Method dis_originalMethod = class_getInstanceMethod(class, NSSelectorFromString(@"tracking_didSelectRowAtIndexPath"));
        Method dis_swizzledMethod = class_getInstanceMethod(class, @selector(tableView:didSelectRowAtIndexPath:));
        method_exchangeImplementations(dis_originalMethod, dis_swizzledMethod);
    }
}

void tracking_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, id indexpath)
{
    SEL selector = NSSelectorFromString(@"tracking_didSelectRowAtIndexPath");
    ((void(*)(id, SEL,id, id))objc_msgSend)(self, selector, tableView, indexpath);
    //此处添加你想统计的打点事件
    __unsafe_unretained NSIndexPath *ip = indexpath;
}

@end
