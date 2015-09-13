//
//  GroupUsageViewController.m
//  KeyboardAnimator Example
//
//  Created by Ratul Sharker on 8/27/15.
//  Copyright (c) 2015 revesoft. All rights reserved.
//

#import "GroupUsageViewController.h"
#import "KeyboardAnimator.h"

@interface GroupUsageViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *groupAFirstTextField;
@property (strong, nonatomic) IBOutlet UITextField *groupASecondTextField;

@property (strong, nonatomic) IBOutlet UITextField *groupBFirstTextField;
@property (strong, nonatomic) IBOutlet UITextField *groupBSecondTextField;

@end

@implementation GroupUsageViewController
{
    KeyboardAnimator *keyboardAnimatorForGrpA;
    KeyboardAnimator *keyboardAnimatorForGrpB;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    keyboardAnimatorForGrpA = [[KeyboardAnimator alloc] initKeyboardAnimatorWithTextField:@[self.groupAFirstTextField, self.groupASecondTextField]
                                                                      withTargetTextField:@[self.groupASecondTextField, self.groupASecondTextField]
                                                                 AndWhichViewWillAnimated:self.view];
    
    keyboardAnimatorForGrpB = [[KeyboardAnimator alloc] initKeyboardAnimatorWithTextField:@[self.groupBFirstTextField, self.groupBSecondTextField]
                                                                      withTargetTextField:@[self.groupBSecondTextField, self.groupBSecondTextField]
                                                                 AndWhichViewWillAnimated:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [keyboardAnimatorForGrpA registerKeyboardEventListener];
    [keyboardAnimatorForGrpB registerKeyboardEventListener];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [keyboardAnimatorForGrpA unregisterKeyboardEventListener];
    [keyboardAnimatorForGrpB unregisterKeyboardEventListener];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
