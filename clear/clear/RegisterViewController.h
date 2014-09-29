//
//  RegisterViewController.h
//  clear
//
//  Created by 김민주 on 2014. 9. 12..
//  Copyright (c) 2014년 김민주. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *todo;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *endDate;

@property (weak, nonatomic) IBOutlet UIView *pickerContainer;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

//pickerData
@property (nonatomic, strong) NSMutableArray *year;
@property (nonatomic, strong) NSMutableArray *month;
@property (nonatomic, strong) NSMutableArray *day;

//week
@property (weak, nonatomic) IBOutlet UIButton *sun;
@property (weak, nonatomic) IBOutlet UIButton *mon;
@property (weak, nonatomic) IBOutlet UIButton *tue;
@property (weak, nonatomic) IBOutlet UIButton *wed;
@property (weak, nonatomic) IBOutlet UIButton *thu;
@property (weak, nonatomic) IBOutlet UIButton *fri;
@property (weak, nonatomic) IBOutlet UIButton *sat;

@end
