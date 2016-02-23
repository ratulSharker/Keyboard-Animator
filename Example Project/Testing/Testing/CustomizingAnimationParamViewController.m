//
//  CustomizingAnimationParamViewController.m
//  KeyboardAnimator Example
//
//  Created by Ratul Sharker on 9/13/15.
//

#import "CustomizingAnimationParamViewController.h"
#import <KeyboardAnimator/KeyboardAnimator.h>

@interface CustomizingAnimationParamViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *groupAContainerView;
@property (strong, nonatomic) IBOutlet UIView *groupBContainerView;
@property (strong, nonatomic) IBOutlet UIView *groupCContainerView;


@property (strong, nonatomic) IBOutlet UITextField *groupATextField;
@property (strong, nonatomic) IBOutlet UITextField *groupBTextField;
@property (strong, nonatomic) IBOutlet UITextField *groupCTextField;

//constraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *grpALayoutBottom;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *grpBLayoutTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *grpBLayoutBottom;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *grpCLayoutTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *grpCLayoutBottom;

@end

@implementation CustomizingAnimationParamViewController
{
    KeyboardAnimator *keyboardAnimatorForGrpA;
    KeyboardAnimator *keyboardAnimatorForGrpB;
    KeyboardAnimator *keyboardAnimatorForGrpC;
}



#pragma mark Life-cycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    keyboardAnimatorForGrpA = [[KeyboardAnimator alloc] initKeyboardAnimatorWithTextField:@[self.groupATextField]
                                                                      withTargetTextField:@[self.groupATextField]
                                                                 AndWhichViewWillAnimated:self.groupAContainerView
                                                                        bottomConstraints:@[self.grpALayoutBottom]
                                                                     nonBottomConstraints:nil];
    
    keyboardAnimatorForGrpB = [[KeyboardAnimator alloc] initKeyboardAnimatorWithTextField:@[self.groupBTextField]
                                                                      withTargetTextField:@[self.groupBTextField]
                                                                 AndWhichViewWillAnimated:self.groupBContainerView
                                                                        bottomConstraints:@[self.grpBLayoutBottom]
                                                                     nonBottomConstraints:@[self.grpBLayoutTop]];
    
    keyboardAnimatorForGrpC = [[KeyboardAnimator alloc] initKeyboardAnimatorWithTextField:@[self.groupCTextField]
                                                                      withTargetTextField:@[self.groupCTextField]
                                                                 AndWhichViewWillAnimated:self.groupCContainerView
                                                                        bottomConstraints:@[self.grpCLayoutBottom]
                                                                     nonBottomConstraints:@[self.grpCLayoutTop]];

    
    //customizing grp A
    [keyboardAnimatorForGrpA setKeyboardUpAnimationDuration:2.0];
    [keyboardAnimatorForGrpA setKeyboardDownAnimationDuration:3.0];

    //customizing grp B
    //animate down event is been customized for animate with the keyboard
    //not after the keyboard has moved to the bottom
    [keyboardAnimatorForGrpB setKeyboardDownAnimationOn:UIKeyboardWillHideNotification];

    //customizing grp C
    [keyboardAnimatorForGrpC setKeyboardUpAnimationOn:UIKeyboardWillShowNotification];
    [keyboardAnimatorForGrpC setKeyboardDownAnimationOn:UIKeyboardWillHideNotification];
    [keyboardAnimatorForGrpC setKeyboardAnimationIntervalType:KEYBOARD_ANIMATION_DURATION_TYPE_AS_KEYBOARD];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [keyboardAnimatorForGrpA registerKeyboardEventListener];
    [keyboardAnimatorForGrpB registerKeyboardEventListener];
    [keyboardAnimatorForGrpC registerKeyboardEventListener];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [keyboardAnimatorForGrpA unregisterKeyboardEventListener];
    [keyboardAnimatorForGrpB unregisterKeyboardEventListener];
    [keyboardAnimatorForGrpC unregisterKeyboardEventListener];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
