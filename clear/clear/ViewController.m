//
//  ViewController.m
//  clear
//
//  Created by 김민주 on 2014. 9. 12..
//  Copyright (c) 2014년 김민주. All rights reserved.
//

#import "ViewController.h"
#import "MJSqlLite.h"

@interface ViewController ()

@end

@implementation ViewController
{
    MJSqlLite *sql;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewUIset];
    sql = [[MJSqlLite alloc]init];
    
    [sql makeTable];

    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewUIset
{
    [_pwd setLeftViewMode:UITextFieldViewModeAlways];
    _pwd.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinkCircle.png"]];
    
    [_oldPwd setLeftViewMode:UITextFieldViewModeAlways];
    _oldPwd.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinkCircle.png"]];
    
    [_latestPwd setLeftViewMode:UITextFieldViewModeAlways];
    _latestPwd.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinkCircle.png"]];

}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL result = [sql authenticatePwd:_pwd.text];
    
    if([identifier isEqualToString:@"logIn"]){
        return result;
    }
    return YES;
}

- (IBAction)modify:(id)sender {
    BOOL result = [sql authenticatePwd:_oldPwd.text];
    if(result){
        [sql changePwd:_latestPwd.text];
    }
}
@end
