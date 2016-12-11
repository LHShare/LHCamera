//
//  NSFileManager+LHAdditions.h
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/8.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (LHAdditions)

- (NSString *)temporaryDirectoryWithTemplateString:(NSString *)templateString;

@end
