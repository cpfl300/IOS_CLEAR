//
//  ListTableViewController.m
//  clear
//
//  Created by 김민주 on 2014. 9. 13..
//  Copyright (c) 2014년 김민주. All rights reserved.
//

#import "ListTableViewController.h"
#import "ListTableViewCell.h"
#import "MJSqlLite.h"
#import "ListTodo.h"
#import "RegisterViewController.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController
{
    MJSqlLite *sql;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    // Return the number of rows in the section.
    sql = [[MJSqlLite alloc]init];
    [sql makeTable];
    int num = [sql getListTodoNum];
    if(num == 0){
        _listEmpty.hidden = NO;
    }else{
        _listEmpty.hidden = YES;
    }
    
    _listTodos = [sql getListTodo];
    
    return num;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    
    cell.layer.borderWidth = 2.0;
    cell.layer.borderColor = [UIColor colorWithRed:227.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0].CGColor;
    
    tableView.layer.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor;
    
    ListTodo *todo = [_listTodos objectAtIndex:indexPath.row];
    
    NSString *startDate = [todo start];
    startDate = [startDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endDate = [todo end];
    endDate = [endDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    
    NSString *date = [[NSString alloc]initWithFormat:@"%@ - %@", startDate, endDate];
    
        cell.todo.text = [todo title];
        cell.todoDate.text = date;
        cell.todoWeek.text = [todo week];

    return cell;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([sender class] == NSClassFromString(@"ListTableViewCell")){
        RegisterViewController *next = [segue.destinationViewController viewControllers][0];
        NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
        ListTableViewCell *cell = sender;
        
        NSMutableDictionary *preparedData = [[NSMutableDictionary alloc]init];
        [preparedData setObject:cell.todo.text forKey:@"todo"];
        NSArray* startEnd = [cell.todoDate.text componentsSeparatedByString:@" - "];
        [preparedData setObject:[[startEnd objectAtIndex:0] stringByReplacingOccurrencesOfString:@"." withString:@"-"] forKey:@"start"];
        [preparedData setObject:[[startEnd objectAtIndex:1] stringByReplacingOccurrencesOfString:@"." withString:@"-"] forKey:@"end"];
        [preparedData setObject:cell.todoWeek.text forKey:@"week"];
        
        next.selectedData = preparedData;
        
    }
}

//-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//    NSLog(@"%@", identifier);
//    return YES;
//}

@end
