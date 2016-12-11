//
//  NSTimer+Additions.m
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/11.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

#import "NSTimer+Additions.h"

@implementation NSTimer (Additions)

+ (void)executeTimerBlcock:(NSTimer *)timer
{
    TimerFireBlock block = [timer userInfo];
    block();
}

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval firing:(TimerFireBlock)fireBlock
{
    return [self scheduledTimerWithTimeInterval:inTimeInterval repeating:NO firing:fireBlock];
}

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval repeating:(BOOL)repeat firing:(TimerFireBlock)fireBlock
{
    id block = [fireBlock copy];
    return [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(executeTimerBlcock:) userInfo:block repeats:repeat];
}

@end
