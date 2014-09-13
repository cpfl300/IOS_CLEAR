//
//  TodayTableViewCell.h
//  clear
//
//  Created by 김민주 on 2014. 9. 13..
//  Copyright (c) 2014년 김민주. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *todo;
@property (weak, nonatomic) IBOutlet UIImageView *todoImg;

@end
