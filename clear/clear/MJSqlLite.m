//
//  MJSqlLite.m
//  clear
//
//  Created by 김민주 on 2014. 9. 29..
//  Copyright (c) 2014년 김민주. All rights reserved.
//

#import "MJSqlLite.h"
#import <sqlite3.h>
#import "ListTodo.h"
#import "TodayTodo.h"

@implementation MJSqlLite

-(void)makeTable{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
   _databasePath = [documentsDirectory stringByAppendingPathComponent:@"clear.db"];
    NSLog(@"%@", _databasePath);
    
//    NSLog(@"%@", databasePath);
    
    //  db가 원래 존재하는지 체크
    bool databaseAlreadyExists = [[NSFileManager defaultManager] fileExistsAtPath:_databasePath];
    if(sqlite3_open([_databasePath UTF8String], &_feedDb) == SQLITE_OK){
        if(!databaseAlreadyExists){
            //  create user table
            const char *userSqlStatement = "CREATE TABLE IF NOT EXISTS user (id INT PRIMARY KEY, PWD TEXT)";
            char* userError;
            
            if(sqlite3_exec(_feedDb, userSqlStatement, NULL, NULL, &userError) == SQLITE_OK){
                NSLog(@"DB table created");
            } else {
                NSLog(@"Error: %s", userError);
            }
            
            //  create user table
            const char *insertSqlStatement = "INSERT INTO user values (1, \"0000\")";
            char* insertError;
            
            if(sqlite3_exec(_feedDb, insertSqlStatement, NULL, NULL, &insertError) == SQLITE_OK){
                NSLog(@"inserted");
            } else {
                NSLog(@"Error: %s", insertError);
            }
            
            //  create today table
            const char *todaySqlStatement = "CREATE TABLE IF NOT EXISTS today (TITLE TEXT PRIMARY KEY, DO INT, TODAY DATE)";
            char* todayError;
            
            if(sqlite3_exec(_feedDb, todaySqlStatement, NULL, NULL, &todayError) == SQLITE_OK){
                NSLog(@"DB table created");
            } else {
                NSLog(@"Error: %s", todayError);
            }
            
            //  create list table
            const char *listSqlStatement = "CREATE TABLE IF NOT EXISTS list (TITLE TEXT PRIMARY KEY, START DATE, END DATE, WEEK TEXT)";
            char* listError;
            
            if(sqlite3_exec(_feedDb, listSqlStatement, NULL, NULL, &listError) == SQLITE_OK){
                NSLog(@"DB table created");
            } else {
                NSLog(@"Error: %s", listError);
            }
            
        }
    }
}

-(BOOL)authenticatePwd:(NSString*)pwd
{
    NSString *realPwd;
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT PWD FROM user"];
    sqlite3_stmt *statement;

    if (sqlite3_prepare_v2(_feedDb, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            realPwd = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
        }
        sqlite3_finalize(statement);
    }

    if([pwd isEqualToString:realPwd]){
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:@"비밀번호가 일치하지 않습니다 :(" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    return NO;
}

-(void)changePwd:(NSString*)newPwd{
    
    NSString *replaceStatement = [NSString stringWithFormat:@"UPDATE user SET PWD = \"%@\" WHERE ID = 1;", newPwd];
    NSLog(@"%@", replaceStatement);
    char *error;
    if(sqlite3_exec(_feedDb, [replaceStatement UTF8String], NULL, NULL, &error) == SQLITE_OK){
        [[[UIAlertView alloc] initWithTitle:[[NSString alloc]initWithFormat:@"비밀번호가 %@(으)로 변경되었습니다 :)", newPwd] message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    } else {
        NSLog(@"Error: %s", error);
    }
}

-(int)getTodayTodoNum{
    int result = 0;
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT * FROM today"];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_feedDb, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            result = result+1;
        }
        sqlite3_finalize(statement);
    }
    
    return result;
}

-(int)getListTodoNum{
    int result = 0;
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT * FROM list"];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_feedDb, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            result = result+1;
        }
        sqlite3_finalize(statement);
    }
    
    return result;
}

-(void)addTodo:(NSString*)todo start:(NSString*)start end:(NSString*)end at:(NSString*)week{

    start = [start stringByReplacingOccurrencesOfString:@"년 " withString:@"-"];
    start = [start stringByReplacingOccurrencesOfString:@"월 " withString:@"-"];
    start = [start stringByReplacingOccurrencesOfString:@"일" withString:@""];
    
    end = [end stringByReplacingOccurrencesOfString:@"년 " withString:@"-"];
    end = [end stringByReplacingOccurrencesOfString:@"월 " withString:@"-"];
    end = [end stringByReplacingOccurrencesOfString:@"일" withString:@""];
    
    NSString *insertSqlStatement = [NSString stringWithFormat:@"INSERT INTO list values (\"%@\", \"%@\", \"%@\", \"%@\")", todo, start, end, week];
    char* insertError;
    
    if(sqlite3_exec(_feedDb, [insertSqlStatement UTF8String], NULL, NULL, &insertError) == SQLITE_OK){
        [self clearToday];
        [self setTodayData];
//        list에 있는 컬럼을 select * 한다
//        조건에 맞는 것
//        1. 날짜가 사이에 있음 2. 요일 해당이 있음
//        을 찾아서 today 테이블에 insert한다.

    } else {
        NSLog(@"Error: %s", insertError);
    }
}

- (NSMutableArray*) getListTodo{
    NSMutableArray* todos = [[NSMutableArray alloc]init];
    
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT * FROM list"];
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(_feedDb, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *title = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
            NSString *start = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
            NSString *end = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
            NSString *week = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
            
            ListTodo *todo = [[ListTodo alloc]initWithTitle:title andStarteDate:start andEndDate:end withWeek:week];
            [todos addObject:todo];
        }
        sqlite3_finalize(statement);
    }
    
    return todos;
    
}

- (NSMutableArray*) getTodayTodo{
    NSMutableArray* todos = [[NSMutableArray alloc]init];
    
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT * FROM today"];
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(_feedDb, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *title = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
            NSInteger complete = sqlite3_column_int(statement, 1);
            
            TodayTodo *todo = [[TodayTodo alloc]initWithTitle:title andComplete:complete];
            [todos addObject:todo];
        }
        sqlite3_finalize(statement);
    }
    
    return todos;
    
}



-(NSString*)getTodayAtFormat:(NSString*)format{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *result = [dateFormat stringFromDate:today];
    return result;
}

- (NSString*)getDayOfWeek
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekDayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    
    int week = [weekDayComponents weekday];
    NSString* weekStr;
    switch (week) {
        case 1:
            weekStr = @"일요일";
            break;
        case 2:
            weekStr = @"월요일";
            break;
        case 3:
            weekStr = @"화요일";
            break;
        case 4:
            weekStr = @"수요일";
            break;
        case 5:
            weekStr = @"목요일";
            break;
        case 6:
            weekStr = @"금요일";
            break;
        case 7:
            weekStr = @"토요일";
            break;
        default:
            break;
    }
    
    return weekStr;
}

-(void)clearToday{
    NSString *today = [self getTodayAtFormat:@"YYYY-MM-dd"];

    // 오늘 날짜를 받아온다.
    // today 테이블의 컬럼을 하나 읽는다.
    //        컬럼이 null 이면 pass 오늘 날짜와 다른 경우 delete from today;
    
    NSString *tableDate = [[NSString alloc]init];
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT * FROM today limit 1"];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_feedDb, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            tableDate = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
        }
        sqlite3_finalize(statement);
    }
    
    if([tableDate isEqualToString:@""]){
        return;
    } else if(today != tableDate){
        //  delete today table
        const char *delSqlStatement = "DELETE FROM today";
        char* delError;
        
        if(sqlite3_exec(_feedDb, delSqlStatement, NULL, NULL, &delError) == SQLITE_OK){
            NSLog(@"clear today table!");
        } else {
            NSLog(@"Error: %s", delError);
        }
    }
    
}

-(void)setTodayData{
    NSString *today = [self getTodayAtFormat:@"YYYY-MM-dd"];
    NSString *todayWeek = [[self getDayOfWeek]stringByReplacingOccurrencesOfString:@"요일" withString:@""];
    
    
    NSString *queryStatement = [NSString stringWithFormat:@"select * from list where start <= %@ <= end", today];
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(_feedDb, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *week = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
            NSString *title = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
            NSMutableArray* weeks = [week componentsSeparatedByString:@","];
            for(int i = 0 ; i < weeks.count; i++){
                if([[weeks objectAtIndex:i] isEqualToString:todayWeek]){
                    NSString* stringSql = [NSString stringWithFormat:@"INSERT INTO today values (\"%@\", 0, \"%@\")", title, today];
                    
                    const char *insertSqlStatement = [stringSql UTF8String];
                    char* insertError;
                    if(sqlite3_exec(_feedDb, insertSqlStatement, NULL, NULL, &insertError) == SQLITE_OK){
                        NSLog(@"inserted today table");
                    } else {
                        NSLog(@"Error: %s", insertError);
                    }
                }
            }
            
            
        }
        sqlite3_finalize(statement);
    }
    

    //        list에 있는 컬럼을 select * 한다
    //        조건에 맞는 것
    //        1. 날짜가 사이에 있음 2. 요일 해당이 있음
    //        을 찾아서 today 테이블에 insert한다.
}


@end
