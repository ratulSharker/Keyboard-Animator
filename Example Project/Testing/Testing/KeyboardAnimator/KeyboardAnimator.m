//
//  KeyboardAnimator.m
//  MissYouCall
//
//  Created by Ratul Sharker on 8/4/15.
//  Copyright (c) 2015 REVE Systems. All rights reserved.
//

#import "KeyboardAnimator.h"


@implementation KeyboardAnimator
{
    CGFloat animatedHeight;
    NSArray *allTextFields;
    UIView *viewThatWillBeActuallyAnimated;
}

-(id)initKeyboardAnimatorWithTextFieldArray:(NSArray*)textFields AndWhichViewWillAnimated:(UIView*)view;
{
    self = [super init];
    
    if(self != nil)
    {
        //do necessary initialization here
        animatedHeight = 0;
        allTextFields = textFields;
        viewThatWillBeActuallyAnimated = view;
    }
    
    return self;
}



#pragma mark public functionality
-(void)registerKeyboardEventListener
{
    //register keyboard on screen & off screen callback notification
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    [notiCenter addObserver:self selector:@selector(keyboardOffScreen:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)unregisterKeyboardEventListener
{
    //de-register keyboard on screen & off screen callback notification
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self];
}




#pragma keyboard appearance
-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [[UIApplication sharedApplication].keyWindow convertRect:rawFrame fromView:nil];
    
    //NSLog(@"KEYBOARD FRAME: %@", NSStringFromCGRect(keyboardFrame));
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        {
            //find out which uitextField is responsible for this keyboard operation

            UITextField *responsibleTextField = nil;
            UIView *viewWhichWillAnimate = viewThatWillBeActuallyAnimated;
            
            for(UITextField *textField in allTextFields)
            {
                if([textField isFirstResponder])
                {
                    responsibleTextField = textField;
                    break;
                }
            }
            
            if(responsibleTextField != nil)
            {
                //now we calculate, do we need any animation or not

                CGPoint topLeftCorner = [responsibleTextField convertPoint:CGPointZero toView:[UIApplication sharedApplication].keyWindow];
                
                //NSLog(@"RESPONSIBLE FIELD FRAME %f %f %f", topLeftCorner.y, responsibleTextField.frame.size.height , keyboardFrame.origin.y);
                
                if(topLeftCorner.y + responsibleTextField.frame.size.height != keyboardFrame.origin.y)
                {
                    
                    CGFloat animatedDistance = 0;
                    
                    
                    //NSLog(@"Animated distance %f Animated Height %f", animatedDistance, animatedHeight);
                    
                    
                    //so now we actually need the animation
                    if(animatedHeight == 0)
                    {
                        animatedDistance = animatedHeight = responsibleTextField.frame.size.height + topLeftCorner.y - keyboardFrame.origin.y + SPACING_BETWEEN_TEXTFIELD_AND_KEYBOARD;
                    }
                    else
                    {
                        animatedDistance = responsibleTextField.frame.size.height + topLeftCorner.y - keyboardFrame.origin.y + SPACING_BETWEEN_TEXTFIELD_AND_KEYBOARD;
                        animatedHeight += animatedDistance;
                    }

                    //NSLog(@"Animated distance %f Animated Height %f", animatedDistance, animatedHeight);
                    
                    if(animatedDistance != 0)
                    {
                        [UIView animateWithDuration:KEYBOARD_UP_ANIMATION_DURATION animations:^{
                            viewWhichWillAnimate.frame = CGRectMake(viewWhichWillAnimate.frame.origin.x
                                                                    , viewWhichWillAnimate.frame.origin.y - animatedDistance
                                                                    , viewWhichWillAnimate.frame.size.width
                                                                    , viewWhichWillAnimate.frame.size.height);
                            
                        }];
                    }
                }
            }
            
            else
            {
                //it wont never happen, just curious about it :)
                NSLog(@"NO RESPONSIBLE UITEXTFIELD FOUND FOR ANIMATION");
            }
        }
    }];
}

-(void)keyboardOffScreen:(NSNotification *)notification
{
    if(animatedHeight > 0)
    {
        if(animatedHeight > 0)
        {
            [UIView animateWithDuration:KEYBOARD_DOWN_ANIMATION_DURATION animations:^{
                viewThatWillBeActuallyAnimated.frame = CGRectMake(viewThatWillBeActuallyAnimated.frame.origin.x
                                                                  , viewThatWillBeActuallyAnimated.frame.origin.y + animatedHeight
                                                                  , viewThatWillBeActuallyAnimated.frame.size.width
                                                                  , viewThatWillBeActuallyAnimated.frame.size.height);
                
            }];
        }
        animatedHeight = 0;
    }
}




@end
