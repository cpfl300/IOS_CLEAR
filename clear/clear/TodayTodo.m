//
//  TodayTodo.m
//  clear
//
//  Created by 김민주 on 2014. 9. 30..
//  Copyright (c) 2014년 김민주. All rights reserved.
//

#import "TodayTodo.h"

@implementation TodayTodo

-(id)initWithTitle:(NSString*)title andComplete:(NSInteger)complete{
    
    self = [super init];
    if(self) {
        _title = title;
        _complete = complete;
    }
    return self;
    
}

@end
