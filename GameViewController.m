//
//  GameViewController.m
//  FarkleWeekendProject
//
//  Created by Jedd Goble on 10/8/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "GameViewController.h"
#import "Button.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    Button *diceTest = [[Button alloc] initWithImage:@"dice5" andFrame:CGRectMake(400, 100, 50, 50)];
    [self.view addSubview:diceTest];
    
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
