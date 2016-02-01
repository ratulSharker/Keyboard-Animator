//
//  CustomizingAnimationParamViewController.m
//  KeyboardAnimator Example
//
//  Created by Ratul Sharker on 9/13/15.
//

#import "CustomizingAnimationParamViewController.h"
#import "KeyboardAnimator.h"

@interface CustomizingAnimationParamViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *groupAContainerView;
@property (strong, nonatomic) IBOutlet UIView *groupBContainerView;


@property (strong, nonatomic) IBOutlet UITextField *groupATextFieldA;
@property (strong, nonatomic) IBOutlet UITextField *groupATextFieldB;



@property (strong, nonatomic) IBOutlet UITextField *groupBTextFieldA;
@property (strong, nonatomic) IBOutlet UITextField *groupBTextFieldB;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *grpALayoutBottom;



@property (strong, nonatomic) IBOutlet NSLayoutConstraint *grpBLayoutTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *grpBLayoutBottom;



@end

@implementation CustomizingAnimationParamViewController
{
    KeyboardAnimator *keyboardAnimatorForGrpA;
    KeyboardAnimator *keyboardAnimatorForGrpB;
}



#pragma mark Life-cycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    keyboardAnimatorForGrpA = [[KeyboardAnimator alloc] initKeyboardAnimatorWithTextField:@[self.groupATextFieldA, self.groupATextFieldB]
                                                                      withTargetTextField:@[self.groupATextFieldB, self.groupATextFieldB]
                                                                 AndWhichViewWillAnimated:self.groupAContainerView
                                                                        bottomConstraints:@[self.grpALayoutBottom]
                                                                     nonBottomConstraints:nil];
    
    
    keyboardAnimatorForGrpB = [[KeyboardAnimator alloc] initKeyboardAnimatorWithTextField:@[self.groupBTextFieldA, self.groupBTextFieldB]
                                                                      withTargetTextField:@[self.groupBTextFieldB, self.groupBTextFieldB]
                                                                 AndWhichViewWillAnimated:self.groupBContainerView
                                                                        bottomConstraints:@[self.grpBLayoutBottom]
                                                                     nonBottomConstraints:@[self.grpBLayoutTop]];

    
    //customizing animation thing
    [keyboardAnimatorForGrpA setKeyboardUpAnimationDuration:2.0];
    [keyboardAnimatorForGrpA setKeyboardDownAnimationDuration:3.0];
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
