//
//  TodayTableViewController.h
//  clear
//
//  Created by 김민주 on 2014. 9. 13..
//  Copyright (c) 2014년 김민주. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *listBtn;

@end
