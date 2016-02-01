//
//  SupportingUITextViewViewController.m
//  KeyboardAnimator Example
//
//  Created by Ratul Sharker on 12/22/15.
//

#import "SupportingUITextViewViewController.h"
#import "KeyboardAnimator/KeyboardAnimator.h"


@interface SupportingUITextViewViewController ()

@property (strong, nonatomic) IBOutlet UITextView *mViewTextView;
@property (strong, nonatomic) IBOutlet UIView *mViewHolderView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *holderViewBottomContraint;

@end

@implementation SupportingUITextViewViewController
{
    KeyboardAnimator *keyboardAnimator;
}

#pragma mark life-cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    keyboardAnimator = [[KeyboardAnimator alloc] initKeyboardAnimatorWithTextFieldArray:@[self.mViewTextView]
                                                               AndWhichViewWillAnimated:self.view
                                                                      bottomConstraints:@[self.holderViewBottomContraint] nonBottomConstraints:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [keyboardAnimator registerKeyboardEventListener];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [keyboardAnimator unregisterKeyboardEventListener];
}


#pragma mark IBActions
- (IBAction)onHideKeyboardPressed:(id)sender
{
    [self.mViewTextView resignFirstResponder];
}



@end
