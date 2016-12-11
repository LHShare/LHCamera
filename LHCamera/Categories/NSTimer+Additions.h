//
//  NSTimer+Additions.h
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/11.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TimerFireBlock)(void);

@interface NSTimer (Additions)


+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval firing:(TimerFireBlock)fireBlock;
+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval repeating:(BOOL)repeat firing:(TimerFireBlock)fireBlock;

@end
