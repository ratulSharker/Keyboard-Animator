//
//  KeyboardAnimator.h
//  MissYouCall
//
//  Created by Ratul Sharker on 8/4/15.
//  Copyright (c) 2015 REVE Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//    These are the customization macro which are set to default values.
//    Change the values to complete you need
#define KEYBOARD_UP_ANIMATION_DURATION          0.5
#define KEYBOARD_DOWN_ANIMATION_DURATION        0.25
#define SPACING_BETWEEN_TEXTFIELD_AND_KEYBOARD  15



@interface KeyboardAnimator : NSObject



//    This is the simple initializer of the keyboard animator.
//    To initialize properly provide an NSArray of UITextField and the UIView object which will be actually animated.
//    For most of the case, animatedView param will be the ViewController's self.view
-(id)initKeyboardAnimatorWithTextFieldArray:(NSArray*)textFields AndWhichViewWillAnimated:(UIView*)animatedView;



//    Add a simple notification on keyboard change UIKeyboardDidShowNotification & UIKeyboardDidHideNotification
//    notification. These notification will trigger when keyboard will appear and disappear.
//    It is recommended to call this method in the viewWillAppear / viewDidAppear method of the UIViewController
-(void)registerKeyboardEventListener;

//    Adding a notification change listener add a overhead. Before getting out from the target viewController, you
//    must clean up the mess. Thats why this function will help you to remove the keyboard change notification.
//    It is recommended to call this method in the viewWillDisappear / viewDidDisappear of the UIVIewController
-(void)unregisterKeyboardEventListener;

@end
