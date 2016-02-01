//
//  ViewController.m
//  Testing
//
//  Created by Ratul Sharker on 8/4/15.
//

#import "SimpleUsageViewcontroller.h"
#import "KeyboardAnimator.h"

@interface SimpleUsageViewcontroller ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textFieldAtBottom;
@property (strong, nonatomic) IBOutlet UITextField *textFieldMiddle;
@property (strong, nonatomic) IBOutlet UITextField *textFieldTopLeft;
@property (strong, nonatomic) IBOutlet UITextField *textFieldTopRight;

@end

@implementation SimpleUsageViewcontroller
{
    KeyboardAnimator *keyboardAnimator;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    keyboardAnimator = [[KeyboardAnimator alloc] initKeyboardAnimatorWithTextFieldArray:@[self.textFieldAtBottom,
                                                                                          self.textFieldMiddle,
                                                                                          self.textFieldTopLeft,
                                                                                          self.textFieldTopRight]
                                                               AndWhichViewWillAnimated:self.view
                                                                      bottomConstraints:nil
                                                                   nonBottomConstraints:nil];
    
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
