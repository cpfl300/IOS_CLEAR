//
//  TodayTableViewController.m
//  clear
//
//  Created by 김민주 on 2014. 9. 13..
//  Copyright (c) 2014년 김민주. All rights reserved.
//

#import "TodayTableViewController.h"
#import "TodayTableViewCell.h"
#import "RegisterViewController.h"
#import "MJSqlLite.h"
#import "TodayTodo.h"

@interface TodayTableViewController ()

@end

@implementation TodayTableViewController
{
    MJSqlLite *sql;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *img = [UIImage imageNamed:@"plus.png"];
    UIGraphicsBeginImageContext(CGSizeMake(25, 25));
    [img drawInRect:CGRectMake(0, 0, 25, 25)];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.navigationItem.rightBarButtonItem.image = newImg;
    
    UIImage* list = [UIImage imageNamed:@"listBtn.png"];
    UIGraphicsBeginImageContext(CGSizeMake(25, 25));
    [list drawInRect:CGRectMake(0, 0, 25, 25)];
    UIImage *newList = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.navigationItem.leftBarButtonItem.image = newList;

}

- (IBAction)Add:(id)sender{
    NSLog(@"add");
    RegisterViewController *addVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (IBAction)GoList:(id)sender{
    NSLog(@"list");
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    sql = [[MJSqlLite alloc]init];
    [sql makeTable];
    [sql clearToday];
    [sql setTodayData];
    
    int num = [sql getTodayTodoNum];
    
    if(num == 0){
        _todayEmpty.hidden = NO;
    }else{
        _todayEmpty.hidden = YES;
    }
    
    _todayTodos = [sql getTodayTodo];
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todayCell" forIndexPath:indexPath];

    NSString *dateString = [sql getTodayAtFormat:@"MM/dd"];
    _date.text = [[dateString stringByAppendingString:@" "] stringByAppendingString:[sql getDayOfWeek]];
    
    cell.layer.borderWidth = 2.0;
    cell.layer.borderColor = [UIColor colorWithRed:227.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0].CGColor;
    
    tableView.layer.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor;
    
    TodayTodo *todo = [_todayTodos objectAtIndex:indexPath.row];
    cell.todo.text = [todo title];
    
    
    if(![sql getTappedInfo:[todo title]]){
        cell.todoImg.image = [UIImage imageNamed:@"pinkCircle.png"];
        cell.todo.textColor = [UIColor colorWithRed:241.0/255.0 green:112.0/255.0 blue:104.0/255.0 alpha:1.0];
    }else{
        cell.todoImg.image = [UIImage imageNamed:@"blueCircle.png"];
        cell.todo.textColor = [UIColor colorWithRed:74.0/255.0 green:93.0/255.0 blue:226.0/255.0 alpha:1.0];
    }
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todayCell" forIndexPath:indexPath];
    
    TodayTodo *todo = [_todayTodos objectAtIndex:indexPath.row];
    cell.todo.text = [todo title];
    
    if([sql todayTapped:[todo title]]){
        cell.todoImg.image = [UIImage imageNamed:@"pinkCircle.png"];
//        cell.todo.textColor = [UIColor colorWithRed:241.0/255.0 green:112.0/255.0 blue:104.0/255.0 alpha:1.0];
        cell.todo.textColor = [UIColor redColor];
    }else{
        cell.todoImg.image = [UIImage imageNamed:@"blueCircle.png"];
        cell.todo.textColor = [UIColor colorWithRed:74.0/255.0 green:93.0/255.0 blue:226.0/255.0 alpha:1.0];
    }
    
    [self.tableView reloadData];
    
    
//    [cell isHighlighted];
//    if([cell isSelected]){
//        cell.todoImg.image = [UIImage imageNamed:@"blueCircle.png"];
//        cell.todo.textColor = [UIColor colorWithRed:74.0/255.0 green:93.0/255.0 blue:226.0/255.0 alpha:1.0];
//    } else {
//        cell.todoImg.image = [UIImage imageNamed:@"pinkCircle.png"];
//        cell.todo.textColor = [UIColor colorWithRed:241.0/255.0 green:112.0/255.0 blue:104.0/255.0 alpha:1.0];
//    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImageView *imageView = [[UIImageView alloc]
                              initWithFrame:CGRectMake(0,0,35,35)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = NO;
    imageView.image = [UIImage imageNamed:@"logo.png"];
    self.navigationItem.titleView = imageView;
}

@end
