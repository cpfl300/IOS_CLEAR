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
    NSString *tableDate = [[NSString alloc]init];
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT * FROM today limit 1"];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_feedDb, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            tableDate = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
        }
        sqlite3_finalize(statement);
    }
    
    if([tableDate isEqualToString:@""]){
        return;
    } else if(![today isEqualToString:tableDate]){
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

-(void)mandatoryClearToday{
    const char *delSqlStatement = "DELETE FROM today";
    char* delError;
    
    if(sqlite3_exec(_feedDb, delSqlStatement, NULL, NULL, &delError) == SQLITE_OK){
        NSLog(@"clear today table!");
    } else {
        NSLog(@"Error: %s", delError);
    }
}

-(void)setTodayData{
    NSString *today = [self getTodayAtFormat:@"YYYY-MM-dd"];
    NSString *todayWeek = [[self getDayOfWeek]stringByReplacingOccurrencesOfString:@"요일" withString:@""];
    
    
    NSString *queryStatement = [NSString stringWithFormat:@"select * from list where start <= \'%@\' <= end", today];
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(_feedDb, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *week = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
            NSString *title = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
            NSMutableArray* weeks = [week componentsSeparatedByString:@","];
            for(int i = 0 ; i < weeks.count; i++){
                
                if([[[weeks objectAtIndex:i]stringByReplacingOccurrencesOfString:@" " withString:@""]  isEqualToString:todayWeek]){
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

}

-(BOOL)todayTapped:(NSString*)title{
    NSInteger result;
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT DO FROM today where TITLE=\"%@\"", title];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_feedDb, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            result = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
    }
    
    NSInteger changeDo;
    if(result == 0){
        changeDo = 1;
    } else if(result == 1){
        changeDo = 0;
    }
    
    NSString *replaceStatement = [NSString stringWithFormat:@"UPDATE today SET DO = %ld WHERE TITLE = \"%@\"", (long)changeDo, title];

    char *error;
    if(sqlite3_exec(_feedDb, [replaceStatement UTF8String], NULL, NULL, &error) == SQLITE_OK){
        NSLog(@"today's DO changed");
    } else {
        NSLog(@"Error: %s", error);
    }


    return changeDo;
}

-(BOOL)getTappedInfo:(NSString*)title{
    NSInteger result;
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT * FROM today where TITLE=\"%@\"", title];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_feedDb, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            result = sqlite3_column_int(statement, 1);
        }
        sqlite3_finalize(statement);
    }
    
    return result;
}

-(void)deleteList:(NSString*)title{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"clear.db"];
    
    NSLog(@"Path: %@", dbPath);
    if(sqlite3_open([dbPath UTF8String], &_feedDb) == SQLITE_OK){
        NSLog(@"OK");
    }
    
    
    NSString* nsdelSql = [[NSString alloc]initWithFormat:@"DELETE FROM list where TITLE =\"%@\"", title];
    const char *delSqlStatement = [nsdelSql UTF8String];
    char* delError;
    int test = sqlite3_exec(_feedDb, delSqlStatement, NULL, NULL, &delError);
    if(test == SQLITE_OK){
        NSLog(@"delete from list");
    } else {
        NSLog(@"Error: %s %d", delError, test);
    }
    
    const char *todayDelSqlStatement = [[[NSString alloc]initWithFormat:@"DELETE FROM today where TITLE =\"%@\"", title] UTF8String];
    char* todayDelError;
    
    if(sqlite3_exec(_feedDb, todayDelSqlStatement, NULL, NULL, &todayDelError) == SQLITE_OK){
        NSLog(@"delete from list");
    } else {
        NSLog(@"Error: %s", todayDelError);
    }
    
}

-(void)alterData:(NSMutableDictionary*)dic{
    NSString* key = [dic objectForKeyedSubscript:@"todo"];
    NSString* start = [dic objectForKeyedSubscript:@"start"];
    NSString* end = [dic objectForKeyedSubscript:@"end"];
    NSString* week = [dic objectForKeyedSubscript:@"week"];
    
    
    NSString *replaceStatement = [NSString stringWithFormat:@"UPDATE list SET START = \"%@\", END = \"%@\", WEEK = \"%@\" WHERE TITLE =\"%@\"", start, end, week, key];
    NSLog(@"%@", replaceStatement);
    char *error;
    if(sqlite3_exec(_feedDb, [replaceStatement UTF8String], NULL, NULL, &error) == SQLITE_OK){
        [[[UIAlertView alloc] initWithTitle:@"TODO가 변경되었습니다 :)" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    } else {
        NSLog(@"Error: %s", error);
    }
    
    [self setTodayData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changed" object:self userInfo:nil];
//    TodayTableViewController *today = [[TodayTableViewController alloc]init];
//    [today.tableView reloadData];
}
@end
