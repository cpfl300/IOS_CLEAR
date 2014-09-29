//
//  ListTodo.m
//  clear
//
//  Created by 김민주 on 2014. 9. 30..
//  Copyright (c) 2014년 김민주. All rights reserved.
//

#import "ListTodo.h"

@implementation ListTodo

-(id)initWithTitle:(NSString*)title andStarteDate:(NSString*)start andEndDate:(NSString*)end withWeek:(NSString*)week{
    self = [super init];
    if(self) {
        _title = title;
        _start = start;
        _end  = end;
        _week  = week;
    }
    return self;
}
@end
