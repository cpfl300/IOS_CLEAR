//
//  TodayTodo.h
//  clear
//
//  Created by 김민주 on 2014. 9. 30..
//  Copyright (c) 2014년 김민주. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayTodo : NSObject

@property NSString* title;
@property NSInteger complete;

-(id)initWithTitle:(NSString*)title andComplete:(NSInteger)complete;

@end
