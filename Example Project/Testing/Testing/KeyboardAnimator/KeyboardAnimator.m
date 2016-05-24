//
//  KeyboardAnimator.m
//
//  Created by Ratul Sharker on 8/4/15.
//

#import "KeyboardAnimator.h"


@implementation KeyboardAnimator
{
    CGFloat animatedHeight;
    UIView *viewThatWillBeActuallyAnimated;
    NSArray *textFields;
    NSArray *targetTextFields;
    
    NSArray *verticalBottomConstraints;
    NSArray *verticalNonBottomConstraints;
    
    
    //some optional params
    NSTimeInterval keyboardUpTimeInterval, keyboardDownTimeInterval;
    CGFloat        spacingBetweenKeyboardAndTarget;
    
    NSString *animateKeyboardUpEvent;
    NSString *animateKeyboardDownEvent;
    
    enum KeyboardAnimatorDurationType durationType;
}

-(id)initKeyboardAnimatorWithTextFieldArray:(NSArray*)tf
                   AndWhichViewWillAnimated:(UIView*)view
                          bottomConstraints:(NSArray*)bottomConstraints
                       nonBottomConstraints:(NSArray*)nonBottomConstraints
{
    self = [super init];
    
    if(self != nil)
    {
        //do necessary initialization here
        animatedHeight = 0;
        textFields = tf;
        targetTextFields = tf;
        viewThatWillBeActuallyAnimated = view;
        
        verticalBottomConstraints = bottomConstraints;
        verticalNonBottomConstraints = nonBottomConstraints;
        
        //setting default values to the animation params
        keyboardUpTimeInterval = DEFAULT_KEYBOARD_UP_ANIMATION_DURATION;
        keyboardDownTimeInterval = DEFAULT_KEYBOARD_DOWN_ANIMATION_DURATION;
        spacingBetweenKeyboardAndTarget = DEFAULT_SPACING_BETWEEN_TEXTFIELD_AND_KEYBOARD;
        
        animateKeyboardUpEvent = DEFAULT_KEYBOARD_ANIMATE_UP_EVENT;
        animateKeyboardDownEvent = DEFAULT_KEYBOARD_ANIMATE_DOWN_EVENT;
        
        
        durationType = KEYBOARD_ANIMATION_DURATION_TYPE_PROVIDED;
    }
    
    return self;
}

-(id)initKeyboardAnimatorWithTextField:(NSArray*)tf
                   withTargetTextField:(NSArray*)targetTf
              AndWhichViewWillAnimated:(UIView*)animatedView
                     bottomConstraints:(NSArray*)bottomConstraints
                  nonBottomConstraints:(NSArray*)nonBottomConstraints
{
    
    self = [self initKeyboardAnimatorWithTextFieldArray:tf
                               AndWhichViewWillAnimated:animatedView
                                      bottomConstraints:bottomConstraints
                                   nonBottomConstraints:nonBottomConstraints];
    
    if(self != nil)
    {
        //additional param initializer values
        targetTextFields = targetTf;
        viewThatWillBeActuallyAnimated = animatedView;
    }
    
    return self;
}

#pragma mark public functionality
-(void)registerKeyboardEventListener
{
    //register keyboard on screen & off screen callback notification
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(keyboardOnScreen:) name:animateKeyboardUpEvent object:nil];
    [notiCenter addObserver:self selector:@selector(keyboardOffScreen:) name:animateKeyboardDownEvent object:nil];
}

-(void)unregisterKeyboardEventListener
{
    //de-register keyboard on screen & off screen callback notification
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self];
}










#pragma mark optional public functionality
-(void) setKeyboardUpAnimationDuration:(NSTimeInterval)uptimeInterval
{
    keyboardUpTimeInterval = uptimeInterval;
}

-(void) setKeyboardDownAnimationDuration:(NSTimeInterval)downTimeInterval
{
    keyboardDownTimeInterval = downTimeInterval;
}

-(void) setSpacingBetweenKeyboardAndTargetedTextField:(CGFloat)spacing
{
    spacingBetweenKeyboardAndTarget = spacing;
}

-(void) setKeyboardUpAnimationOn:(NSString*)animateUpEvent
{
    animateKeyboardUpEvent = animateUpEvent;
}

-(void) setKeyboardDownAnimationOn:(NSString*)animateDownEvent
{
    animateKeyboardDownEvent = animateDownEvent;
}

-(void) setKeyboardAnimationIntervalType:(enum KeyboardAnimatorDurationType)durType
{
    durationType = durType;
}


#pragma mark core private handler
-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary    *info  = notification.userInfo;
    NSValue         *rectValue = info[UIKeyboardFrameEndUserInfoKey];
    NSNumber        *rawDuration = info[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber        *animationCurve = info[UIKeyboardAnimationCurveUserInfoKey];

    CGRect rawFrame      = [rectValue CGRectValue];
    CGRect keyboardFrame = [[UIApplication sharedApplication].keyWindow convertRect:rawFrame fromView:nil];
    
    double actualDuration;
    
    if(durationType == KEYBOARD_ANIMATION_DURATION_TYPE_PROVIDED)
    {
        actualDuration = keyboardUpTimeInterval;
    }
    else if(durationType == KEYBOARD_ANIMATION_DURATION_TYPE_AS_KEYBOARD)
    {
        actualDuration = [rawDuration doubleValue];
    }
    
    
    //NSLog(@"KEYBOARD FRAME: %@", NSStringFromCGRect(keyboardFrame));
    
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    
        //find out which uitextField is responsible for this keyboard operation
        UIView *responsibleTextField = nil;
        UIView *viewWhichWillAnimate = viewThatWillBeActuallyAnimated;
        
        for(unsigned int i = 0;i < textFields.count ; i++)
        {
            UITextView *textField = [textFields objectAtIndex:i];
            if([textField isFirstResponder])
            {
                responsibleTextField = [targetTextFields objectAtIndex:i];
                break;
            }
        }
        
        if(responsibleTextField != nil)
        {
            //now we calculate, do we need any animation or not
            
            
            //
            //  our designated text field are the reason for this
            //  keyboard to animate, so time to call the delegate
            //  all information collected, call the delegate
            //
            if(self.keyboardAnimatorDelegate &&
               [self.keyboardAnimatorDelegate respondsToSelector:@selector(keyboardAnimator:
                                                                           keywindowConvertedFrame:
                                                                           animationDuration:
                                                                           isKeyboardShowing:)])
            {
                //we are prepared to call the delegate
                [self.keyboardAnimatorDelegate keyboardAnimator:self
                                        keywindowConvertedFrame:keyboardFrame
                                              animationDuration:actualDuration
                                              isKeyboardShowing:YES];
            }
            
            
            
            CGPoint topLeftCorner = [responsibleTextField convertPoint:CGPointZero toView:[UIApplication sharedApplication].keyWindow];
            
            if([responsibleTextField isKindOfClass:[UITextView class]])
            {
                UITextView *responsibleTextView = (UITextView*)responsibleTextField;
                topLeftCorner.y += MAX(responsibleTextView.contentSize.height - responsibleTextView.frame.size.height, 0);
                
                NSLog(@"size %@", NSStringFromCGSize(responsibleTextView.contentSize));
            }

            
            //NSLog(@"RESPONSIBLE FIELD FRAME %f %f %f", topLeftCorner.y, responsibleTextField.frame.size.height , keyboardFrame.origin.y);
            
            
            if(topLeftCorner.y + responsibleTextField.frame.size.height > keyboardFrame.origin.y)
            {
                CGFloat animatedDistance = 0;
                
                //NSLog(@"Animated distance %f Animated Height %f", animatedDistance, animatedHeight);
                
                //so now we actually need the animation
                if(animatedHeight == 0)
                {
                    animatedDistance = animatedHeight = responsibleTextField.frame.size.height + topLeftCorner.y - keyboardFrame.origin.y + spacingBetweenKeyboardAndTarget;
                }
                else
                {
                    animatedDistance = responsibleTextField.frame.size.height + topLeftCorner.y - keyboardFrame.origin.y + spacingBetweenKeyboardAndTarget;
                    animatedHeight += animatedDistance;
                }
                
                if(verticalBottomConstraints || verticalNonBottomConstraints)
                {
                    if(verticalBottomConstraints)
                    for(NSLayoutConstraint *verticalConstraint in verticalBottomConstraints)
                    {
                        [UIView animateWithDuration:actualDuration
                                              delay:0.0
                                            options:[animationCurve intValue]
                                         animations:^{
                             verticalConstraint.constant += animatedDistance;
                             [viewWhichWillAnimate layoutIfNeeded];
                            }
                                         completion:nil];
                    }
                    
                    if(verticalNonBottomConstraints)
                    for(NSLayoutConstraint *verticalConstraint in verticalNonBottomConstraints)
                    {
                        [UIView animateWithDuration:actualDuration
                                              delay:0.0
                                            options:[animationCurve intValue]
                                         animations:^{
                            verticalConstraint.constant -= animatedDistance;
                            [viewWhichWillAnimate layoutIfNeeded];
                        }
                                         completion:nil];
                        
                    }
                    
                }
                else
                if(animatedDistance != 0)
                {
                    [UIView animateWithDuration:actualDuration
                                          delay:0.0
                                        options:[animationCurve intValue]
                                     animations:^{
                        viewWhichWillAnimate.frame = CGRectMake(viewWhichWillAnimate.frame.origin.x
                                                                , viewWhichWillAnimate.frame.origin.y - animatedDistance
                                                                , viewWhichWillAnimate.frame.size.width
                                                                , viewWhichWillAnimate.frame.size.height);
                    } completion:nil];
                    
                }
            }
        }
        else
        {
            //these grp or field is not responsible for animating the keybaord up word
        }
    }];
}

-(void)keyboardOffScreen:(NSNotification *)notification
{
    
    NSDictionary            *info  = notification.userInfo;
    NSNumber                *rawDuration = info[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber                *animationCurve = info[UIKeyboardAnimationCurveUserInfoKey];
    
    
    double actualDuration=0.0;
    
    if(durationType == KEYBOARD_ANIMATION_DURATION_TYPE_PROVIDED)
    {
        actualDuration = keyboardDownTimeInterval;
    }
    else if(durationType == KEYBOARD_ANIMATION_DURATION_TYPE_AS_KEYBOARD)
    {
        actualDuration = [rawDuration doubleValue];
    }
    
    
    if(animatedHeight > 0)
    {
        //
        //  all information collected, call the delegate
        //
        if(self.keyboardAnimatorDelegate &&
           [self.keyboardAnimatorDelegate respondsToSelector:@selector(keyboardAnimator:
                                                                       keywindowConvertedFrame:
                                                                       animationDuration:
                                                                       isKeyboardShowing:)])
        {
            //we are prepared to call the delegate
            [self.keyboardAnimatorDelegate keyboardAnimator:self
                                    keywindowConvertedFrame:CGRectZero
                                          animationDuration:actualDuration
                                          isKeyboardShowing:NO];
        }
        
        if(verticalBottomConstraints || verticalNonBottomConstraints)
        {
            if(verticalBottomConstraints)
                for(NSLayoutConstraint *verticalConstraint in verticalBottomConstraints)
                {
                    [UIView animateWithDuration:actualDuration
                                          delay:0.0
                                        options:[animationCurve intValue]
                                     animations:^{
                        verticalConstraint.constant -= animatedHeight;
                        [viewThatWillBeActuallyAnimated layoutIfNeeded];
                    }
                                     completion:nil];
                }
            
            if(verticalNonBottomConstraints)
                for(NSLayoutConstraint *verticalConstraint in verticalNonBottomConstraints)
                {
                    [UIView animateWithDuration:actualDuration
                                          delay:0.0
                                        options:[animationCurve intValue]
                                     animations:^{
                        verticalConstraint.constant += animatedHeight;
                        [viewThatWillBeActuallyAnimated layoutIfNeeded];
                    }
                                     completion:nil];
                }
            
        }
        else
        {
            
            [UIView animateWithDuration:actualDuration
                                  delay:0.0
                                options:[animationCurve intValue]
                             animations:^{
                viewThatWillBeActuallyAnimated.frame = CGRectMake(viewThatWillBeActuallyAnimated.frame.origin.x
                                                                  , viewThatWillBeActuallyAnimated.frame.origin.y + animatedHeight
                                                                  , viewThatWillBeActuallyAnimated.frame.size.width
                                                                  , viewThatWillBeActuallyAnimated.frame.size.height);
            } completion:nil];
            
        }
        animatedHeight = 0;
    }
}

@end
