//
//  MJSqlLite.h
//  clear
//
//  Created by 김민주 on 2014. 9. 29..
//  Copyright (c) 2014년 김민주. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface MJSqlLite : NSObject

@property (nonatomic) sqlite3 *feedDb;
@property (strong, nonatomic) NSString *databasePath;

-(BOOL)authenticatePwd:(NSString*)pwd;
-(void)changePwd:(NSString*)newPwd;
-(int)getTodayTodoNum;
-(int)getListTodoNum;
-(void)addTodo:(NSString*)todo start:(NSString*)start end:(NSString*)end at:(NSString*)week;
- (NSMutableArray*) getListTodo;
- (NSMutableArray*) getTodayTodo;


-(NSString*)getTodayAtFormat:(NSString*)format;
- (NSString*)getDayOfWeek;
-(void)clearToday;
-(void)setTodayData;
-(BOOL)todayTapped:(NSString*)title;
-(BOOL)getTappedInfo:(NSString*)title;
-(void)deleteList:(NSString*)title;
-(void)alterData:(NSMutableDictionary*)dic;
-(void)mandatoryClearToday;

//initialize
-(void)makeTable;


@end
