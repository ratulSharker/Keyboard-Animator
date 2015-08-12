//
//  ViewController.m
//  Testing
//
//  Created by Ratul Sharker on 8/4/15.
//  Copyright (c) 2015 revesoft. All rights reserved.
//

#import "ViewController.h"
#import "KeyboardAnimator.h"

@interface ViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textFieldAtBottom;
@property (strong, nonatomic) IBOutlet UITextField *textFieldAboveBottom;

@end

@implementation ViewController
{
    KeyboardAnimator *keyboardAnimator;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    keyboardAnimator = [[KeyboardAnimator alloc] initKeyboardAnimatorWithTextFieldArray:@[self.textFieldAtBottom,
                                                                                          self.textFieldAboveBottom]
                                                               AndWhichViewWillAnimated:self.view];
    
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
    [keyboardAnimator unregisterKeyboardEventListener];
}



#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
