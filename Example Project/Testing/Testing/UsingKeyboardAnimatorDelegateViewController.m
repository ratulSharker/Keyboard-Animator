//
//  UsingKeyboardAnimatorDelegateViewController.m
//  KeyboardAnimator
//
//  Created by Ratul Sharker on 5/22/16.
//  Copyright © 2016 revesoft. All rights reserved.
//

#import "UsingKeyboardAnimatorDelegateViewController.h"
#import "KeyboardAnimator.h"

@interface UsingKeyboardAnimatorDelegateViewController()<   KeyboardAnimatorDelegate,
                                                            UITextFieldDelegate>

@end

@implementation UsingKeyboardAnimatorDelegateViewController
{
    IBOutlet UITextField *mViewFormOneTextField;
    IBOutlet UITextField *mViewFormTwoTextField;
    
    IBOutlet UIView *mViewFormOneHolder;
    IBOutlet UIView *mViewFormTwoHolder;
    
    IBOutlet NSLayoutConstraint *mViewFormOneHolderBottomConstraint;
    
    
    
    IBOutlet NSLayoutConstraint *mViewFormTwoHolderTopConstraint;
    IBOutlet NSLayoutConstraint *mViewFormTwoHolderBottomConstraint;
    
    
    KeyboardAnimator *kaFormOne, *kaFormTwo;
}

#pragma mark view controller life cycle methods
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    kaFormOne = [[KeyboardAnimator alloc] initKeyboardAnimatorWithTextFieldArray:@[mViewFormOneTextField]
                                                        AndWhichViewWillAnimated:mViewFormOneHolder
                                                               bottomConstraints:@[mViewFormOneHolderBottomConstraint]
                                                            nonBottomConstraints:nil];
    
    kaFormTwo = [[KeyboardAnimator alloc] initKeyboardAnimatorWithTextFieldArray:@[mViewFormTwoTextField]
                                                        AndWhichViewWillAnimated:mViewFormTwoHolder
                                                               bottomConstraints:@[mViewFormTwoHolderBottomConstraint]
                                                            nonBottomConstraints:@[mViewFormTwoHolderTopConstraint]];
    
    
    [kaFormOne setKeyboardUpAnimationOn:UIKeyboardWillShowNotification];
    [kaFormOne setKeyboardDownAnimationOn:UIKeyboardWillHideNotification];
    [kaFormOne setKeyboardAnimationIntervalType:KEYBOARD_ANIMATION_DURATION_TYPE_AS_KEYBOARD];
    
    [kaFormTwo setKeyboardUpAnimationOn:UIKeyboardWillShowNotification];
    [kaFormTwo setKeyboardDownAnimationOn:UIKeyboardWillHideNotification];
    [kaFormTwo setKeyboardAnimationIntervalType:KEYBOARD_ANIMATION_DURATION_TYPE_AS_KEYBOARD];
    
    kaFormOne.keyboardAnimatorDelegate = self;
    kaFormTwo.keyboardAnimatorDelegate = self;
    
    self.title = @"KeyboardAnimatorDelegate";
}

-(void)viewWillAppear:(BOOL)animated
{
    [kaFormOne registerKeyboardEventListener];
    [kaFormTwo registerKeyboardEventListener];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [kaFormOne unregisterKeyboardEventListener];
    [kaFormTwo unregisterKeyboardEventListener];
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark KeyboardAnimatorDelegate
-(void)keyboardAnimator:(KeyboardAnimator*)ka
keywindowConvertedFrame:(CGRect)frame
      animationDuration:(NSTimeInterval)animTime
      isKeyboardShowing:(BOOL)isShowing
{
    
    UIColor *viewColor;
    if(isShowing)
    {
        if(ka == kaFormOne)
        {
            viewColor = [UIColor colorWithRed:143.0/255.0
                                        green:183.0/255.0
                                         blue:231.0/255.0
                                        alpha:1.0];
        }
        else if (ka == kaFormTwo)
        {
            viewColor = [UIColor colorWithRed:1.0
                                        green:1.0
                                         blue:152.0/255.0
                                        alpha:1.0];
        }
        
        [UIView animateWithDuration:animTime animations:^{
            self.view.backgroundColor = viewColor;
            
            if(ka == kaFormOne)
                mViewFormOneHolder.backgroundColor = [UIColor colorWithWhite:0.5
                                                                       alpha:0.5];
            else if(ka == kaFormTwo)
                mViewFormTwoHolder.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        }];
    }
    else
    {
        viewColor = [UIColor whiteColor];
        
        [UIView animateWithDuration:animTime animations:^{
            self.view.backgroundColor = viewColor;
            
            if(ka == kaFormOne)
            {
                //fallback to the previous color
                mViewFormOneHolder.backgroundColor = [UIColor colorWithRed:143.0/255.0  //storyboard violet
                                                                     green:183.0/255.0
                                                                      blue:231.0/255.0
                                                                     alpha:1.0];
            }
            else if(ka == kaFormTwo)
            {
                //fallback to the previous color
                mViewFormTwoHolder.backgroundColor = [UIColor colorWithRed:1.0  //storyboard yellow
                                                                     green:1.0
                                                                      blue:152.0/255.0
                                                                     alpha:1.0];
            }
            
            
        }];
    }
    
    
}

@end
