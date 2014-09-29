//
//  ListTodo.h
//  clear
//
//  Created by 김민주 on 2014. 9. 30..
//  Copyright (c) 2014년 김민주. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListTodo : NSObject

@property NSString* title;
@property NSString* start;
@property NSString* end;
@property NSString* week;

-(id)initWithTitle:(NSString*)title andStarteDate:(NSString*)start andEndDate:(NSString*)end withWeek:(NSString*)week;

@end
