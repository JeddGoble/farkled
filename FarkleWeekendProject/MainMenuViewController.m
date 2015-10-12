//
//  MainMenuViewController.m
//  FarkleWeekendProject
//
//  Created by Jedd Goble on 10/11/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "MainMenuViewController.h"
#import "Button.h"
#import "GameViewController.h"

@interface MainMenuViewController () <ButtonDelegate>

@property (strong, nonatomic) IBOutlet Button *playGameButton;

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numberOfPlayers = 0;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.playGameButton = [[Button alloc] initWithText:@"Play" andColor:OrangeColor andTextColor:BlueColor andFrame:self.playGameButton.frame];
    self.playGameButton.tag = 1;
    self.playGameButton.delegate = self;
    [self.view addSubview:self.playGameButton];
    
}

- (IBAction)playerSegementedControlValueChanged:(UISegmentedControl *)sender {
    
    self.numberOfPlayers = sender.selectedSegmentIndex;
    
}

- (void)buttonPressed:(UITapGestureRecognizer *)senderButton {
        UIView *sender = senderButton.view;

    
    if (sender.tag == 1) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GameViewController *gameView = (GameViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Game"];
        gameView.numberOfPlayers = self.numberOfPlayers;
        [self presentViewController:gameView animated:YES completion:nil];

    }
}



@end
