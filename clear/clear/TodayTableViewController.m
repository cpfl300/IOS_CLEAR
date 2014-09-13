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

@interface TodayTableViewController ()

@end

@implementation TodayTableViewController

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
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todayCell" forIndexPath:indexPath];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd"];
    NSString *dateString = [dateFormat stringFromDate:today];
    _date.text = [[dateString stringByAppendingString:@" "] stringByAppendingString:[self _getDayOfWeek]];

//       cell.todo = @"IOS!?";
//    cell.todoImg = [UIImage imageNamed:@"greenCircle.png"];
    
    cell.layer.borderWidth = 2.0;
    cell.layer.borderColor = [UIColor colorWithRed:227.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0].CGColor;
    
    tableView.layer.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor;
    return cell;
}

- (NSString*)_getDayOfWeek
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
