//
//  RegisterViewController.m
//  clear
//
//  Created by 김민주 on 2014. 9. 12..
//  Copyright (c) 2014년 김민주. All rights reserved.
//

#import "RegisterViewController.h"
#import "MJSqlLite.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
{
    UILabel *tappedLabal;
    MJSqlLite *sql;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPickerData];
    [self pickerInitWithLabel];
    if(_selectedData != NULL){
        _modiTitle.text = @"TODO 변경하기";
        _todo.text = [_selectedData objectForKeyedSubscript:@"todo"];
        [_todo setUserInteractionEnabled:NO];
        _startDate.text = [_selectedData objectForKeyedSubscript:@"start"];
        _endDate.text = [_selectedData objectForKeyedSubscript:@"end"];
        NSString *weeks = [_selectedData objectForKeyedSubscript:@"week"];
        NSArray* seperated = [weeks componentsSeparatedByString:@","];
        NSMutableArray* btnweeks = [[NSMutableArray alloc]init];
        [btnweeks addObject:_mon];
        [btnweeks addObject:_tue];
        [btnweeks addObject:_wed];
        [btnweeks addObject:_thu];
        [btnweeks addObject:_fri];
        [btnweeks addObject:_sat];

        [btnweeks addObject:_sun];
        
        for(int i = 0; i < seperated.count; i++){
            for(int j = 0; j <btnweeks.count; j++){
                if([[[seperated objectAtIndex:i]stringByReplacingOccurrencesOfString:@" " withString:@""]isEqualToString:[[btnweeks objectAtIndex:j] titleLabel].text]){
                    [[btnweeks objectAtIndex:j] setSelected:YES];
                }
            }
        }
        
        _delButton.hidden = NO;
        [_addBtn setTitle:@"Modify" forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

-(BOOL) convertData{
    
    NSMutableDictionary *preparedData = [[NSMutableDictionary alloc]init];
    [preparedData setObject:_todo.text forKey:@"todo"];
    NSString* start = [_startDate.text stringByReplacingOccurrencesOfString:@"년 " withString:@"-"];
    start = [start stringByReplacingOccurrencesOfString:@"월 " withString:@"-"];
    start = [start stringByReplacingOccurrencesOfString:@"일" withString:@""];
    [preparedData setObject:start forKey:@"start"];
    
    NSString* end = [_endDate.text stringByReplacingOccurrencesOfString:@"년 " withString:@"-"];
    end = [end stringByReplacingOccurrencesOfString:@"월 " withString:@"-"];
    end = [end stringByReplacingOccurrencesOfString:@"일" withString:@""];
    [preparedData setObject:end forKey:@"end"];
    
    
    NSMutableArray *aCheckedWeeks = [self getWeek];
    if([_todo.text length] == 0 || [_startDate.text isEqualToString:@"click"] || [_endDate.text isEqualToString:@"click"] || [aCheckedWeeks count] == 0){
        
        [[[UIAlertView alloc] initWithTitle:@"입력되지 않은 항목이 있습니다 :(" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    }
    
    NSMutableString *week = [[NSMutableString alloc]init];
    
    for(int i = 0; i < aCheckedWeeks.count; i++){
        [week appendString:[aCheckedWeeks objectAtIndex:i]];
        if(i < aCheckedWeeks.count -1){
            [week appendString:@", "];
        }
    }
    
    [preparedData setObject:week forKey:@"week"];
    
    MJSqlLite *sq = [[MJSqlLite alloc]init];
    [sq makeTable];
    [sq mandatoryClearToday];
    [sq alterData:preparedData];
    return YES;
}

- (BOOL) resiveData{
    
    NSMutableArray *aCheckedWeeks = [self getWeek];
    if([_todo.text length] == 0 || [_startDate.text isEqualToString:@"click"] || [_endDate.text isEqualToString:@"click"] || [aCheckedWeeks count] == 0){
        
         [[[UIAlertView alloc] initWithTitle:@"입력되지 않은 항목이 있습니다 :(" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        return NO;
    }
    
    NSMutableString *week = [[NSMutableString alloc]init];

    for(int i = 0; i < aCheckedWeeks.count; i++){
        [week appendString:[aCheckedWeeks objectAtIndex:i]];
        if(i < aCheckedWeeks.count -1){
            [week appendString:@", "];
        }
    }
    
    sql = [[MJSqlLite alloc]init];
    [sql makeTable];
    [sql addTodo:_todo.text start:_startDate.text end:_endDate.text at:week];
    return YES;
}

-(NSMutableArray *)getWeek{
    
    NSMutableArray *aCheckedWeeks = [[NSMutableArray alloc]init];
    if([_sun isSelected]){
        [aCheckedWeeks addObject:@"일"];
    }
    
    if([_mon isSelected]){
        [aCheckedWeeks addObject:@"월"];
    }
    
    if([_tue isSelected]){
        [aCheckedWeeks addObject:@"화"];
    }
    
    if([_wed isSelected]){
        [aCheckedWeeks addObject:@"수"];
    }
    
    if([_thu isSelected]){
        [aCheckedWeeks addObject:@"목"];
    }
    
    if([_fri isSelected]){
        [aCheckedWeeks addObject:@"금"];
    }
    
    if([_sat isSelected]){
        [aCheckedWeeks addObject:@"토"];
    }
    
    return aCheckedWeeks;
}

#pragma mark -
#pragma mark UIPickerViewDataSource
- (void)setPickerData{
    NSMutableArray *years = [[NSMutableArray alloc] init];
    NSMutableArray *months = [[NSMutableArray alloc] init];
    NSMutableArray *days = [[NSMutableArray alloc] init];
    
    for(int i = 1; i <= 31; i++){
        [days addObject: [[NSMutableString stringWithFormat:@"%d", i] stringByAppendingString:@"일" ]];
        
    }
    
    for(int i = 1; i <= 12; i++){
        [months addObject:[[NSMutableString stringWithFormat:@"%d", i] stringByAppendingString:@"월"]];
    }
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    for(int i = 0; i < 10; i++){
        [years addObject: [[NSString stringWithFormat:@"%d", [dateString intValue]+i] stringByAppendingString:@"년"]];
    }
    
    _year = years;
    _month = months;
    _day = days;
    
}

-(void)pickerInitWithLabel{
//    처음에는 picker가 보이지 않음
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.0];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 290);
    _pickerContainer.transform = transform;
    [UIView commitAnimations];
    
    _picker.delegate = self;
    
//    label touch event register
    _startDate.userInteractionEnabled = YES;
    UITapGestureRecognizer *startDateTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTap:)];
    [_startDate addGestureRecognizer:startDateTapGesture];
    
    _endDate.userInteractionEnabled = YES;
    UITapGestureRecognizer *endDateTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTap:)];
    [_endDate addGestureRecognizer:endDateTapGesture];
}

#pragma mark -
#pragma mark Actions

- (void)labelTap:(UITapGestureRecognizer * )tapGesture {
    @try {
        tappedLabal = tapGesture.view;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);
        _pickerContainer.transform = transform;
        [UIView commitAnimations];
        
//        tappedLabal.text = @"그래.. 수고했다";
//        NSLog(@"%@", tapGesture.view);
    }
    @catch (NSException *exception) {
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
    
}

- (IBAction)done:(id)sender {
    [tappedLabal setTextColor:[UIColor blackColor]];
    tappedLabal.text = [NSString stringWithFormat:@"%@ %@ %@", _year[[_picker selectedRowInComponent:0]], _month[[_picker selectedRowInComponent:1]], _day[[_picker selectedRowInComponent:2]]];
    
//    tappedLabel 에 정보 쓰기
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 290);
    _pickerContainer.transform = transform;
    [UIView commitAnimations];
}

- (IBAction)cancel:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 290);
    _pickerContainer.transform = transform;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_year count];
    }
    else if (component == 1) {
        return [_month count];
    } else {
        return [_day count];
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0)
    {
        return  [_year objectAtIndex:row];
    }
    else
        if (component==1)
        {
            return  [_month objectAtIndex:row];
        }
    return [_day objectAtIndex:row];
}

#pragma mark -
#pragma mark WeekButtonAction
- (IBAction)mon:(id)sender {
    UIButton *button = (id)sender;
    button.selected = !button.selected;
}

- (IBAction)tue:(id)sender {
    UIButton *button = (id)sender;
    button.selected = !button.selected;
}

- (IBAction)wed:(id)sender {
    UIButton *button = (id)sender;
    button.selected = !button.selected;
}

- (IBAction)thu:(id)sender {
    UIButton *button = (id)sender;
    button.selected = !button.selected;
}

- (IBAction)fri:(id)sender {
    UIButton *button = (id)sender;
    button.selected = !button.selected;
}

- (IBAction)sat:(id)sender {
    UIButton *button = (id)sender;
    button.selected = !button.selected;
}

- (IBAction)sun:(id)sender {
    UIButton *button = (id)sender;
    button.selected = !button.selected;
}

//resiveData
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if(_selectedData != NULL){
        return [self convertData];
    }
    return [self resiveData];
}

- (IBAction)delTodo:(id)sender {
    MJSqlLite *sq = [[MJSqlLite alloc]init];
    [sq deleteList:_todo.text];
}

@end
