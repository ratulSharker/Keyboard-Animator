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

//contanier views
@property (strong, nonatomic) IBOutlet UIView *groupAContainerView;
@property (strong, nonatomic) IBOutlet UIView *groupBContainerView;
@property (strong, nonatomic) IBOutlet UIView *groupCContainerView;


//text fields
@property (strong, nonatomic) IBOutlet UITextField *groupAFirstTextField;
@property (strong, nonatomic) IBOutlet UITextField *groupASecondTextField;

@property (strong, nonatomic) IBOutlet UITextField *groupBFirstTextField;
@property (strong, nonatomic) IBOutlet UITextField *groupBSecondTextField;

@property (strong, nonatomic) IBOutlet UITextField *groupCFirstTextField;
@property (strong, nonatomic) IBOutlet UITextField *groupCSecondTextField;


//contraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *groupABottomContraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *groupBTopContraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *groupBBottomContraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *groupCTopContraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *groupCBottomConstraint;

@end

@implementation GroupUsageViewController
{
    KeyboardAnimator *keyboardAnimatorForGrpA;
    KeyboardAnimator *keyboardAnimatorForGrpB;
    KeyboardAnimator *keyboardAnimatorForGrpC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    keyboardAnimatorForGrpA = [[KeyboardAnimator alloc] initKeyboardAnimatorWithTextField:@[self.groupAFirstTextField, self.groupASecondTextField]
//                                                                      withTargetTextField:@[self.groupASecondTextField, self.groupASecondTextField]
//                                                                 AndWhichViewWillAnimated:self.groupAContainerView
//                                                                        bottomConstraints:@[self.groupABottomContraint]
//                                                                     nonBottomConstraints:nil];
    
    keyboardAnimatorForGrpB = [[KeyboardAnimator alloc] initKeyboardAnimatorWithTextField:@[self.groupBFirstTextField, self.groupBSecondTextField]
                                                                      withTargetTextField:@[self.groupBSecondTextField, self.groupBSecondTextField]
                                                                 AndWhichViewWillAnimated:self.groupBContainerView
                                                                        bottomConstraints:@[self.groupBBottomContraint]
                                                                     nonBottomConstraints:@[self.groupBTopContraint]];
    
    keyboardAnimatorForGrpC = [[KeyboardAnimator alloc] initKeyboardAnimatorWithTextField:@[self.groupCFirstTextField, self.groupCSecondTextField]
                                                                      withTargetTextField:@[self.groupCSecondTextField, self.groupCSecondTextField]
                                                                      AndWhichViewWillAnimated:self.groupCContainerView
                                                                             bottomConstraints:@[self.groupCBottomConstraint]
                                                                          nonBottomConstraints:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [keyboardAnimatorForGrpA registerKeyboardEventListener];
    [keyboardAnimatorForGrpB registerKeyboardEventListener];
    [keyboardAnimatorForGrpC registerKeyboardEventListener];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [keyboardAnimatorForGrpA unregisterKeyboardEventListener];
    [keyboardAnimatorForGrpB unregisterKeyboardEventListener];
    [keyboardAnimatorForGrpC unregisterKeyboardEventListener];
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
