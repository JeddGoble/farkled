//
//  GameViewController.m
//  FarkleWeekendProject
//
//  Created by Jedd Goble on 10/8/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "GameViewController.h"
#import "Button.h"
#import "GameModel.h"
#import "Player.h"
#import "MainMenuViewController.h"

@interface GameViewController () <ButtonDelegate, UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) NSArray *diceImageNames;
@property (strong, nonatomic) NSCountedSet *diceSet;
@property (strong, nonatomic) NSCountedSet *masterDiceSet;
@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (strong, nonatomic) NSTimer *diceChangeTimer;
@property (nonatomic) NSTimeInterval timeInterval;

@property (strong, nonatomic) IBOutlet UILabel *currentScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentFullTurnScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *winnerLabel;

@property (nonatomic) NSInteger currentScore;
@property (nonatomic) BOOL diceOnBoard;
@property (strong, nonatomic) IBOutlet Button *cashInButton;
@property (strong, nonatomic) IBOutlet Button *rollButton;
@property (strong, nonatomic) GameModel *gameModel;
@property (strong, nonatomic) IBOutlet UILabel *farkleLabel;
@property (nonatomic) BOOL farkleFound;
@property (nonatomic) NSInteger currentFullTurnScore;
@property (nonatomic) BOOL canRollAgain;
@property (nonatomic) BOOL firstRoll;
@property (strong, nonatomic) NSMutableArray *players;
@property (nonatomic) NSInteger whosTurn;
@property (strong, nonatomic) IBOutlet Button *playerOneLabel;
@property (strong, nonatomic) IBOutlet Button *playerTwoLabel;
@property (strong, nonatomic) IBOutlet Button *playerThreeLabel;
@property (strong, nonatomic) IBOutlet Button *playerFourLabel;
@property (strong, nonatomic) IBOutlet Button *playAgainButton;
@property (nonatomic) BOOL gameOver;
@property (strong, nonatomic) IBOutlet UIImageView *loadingOverlay;


@end

@implementation GameViewController


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (void)viewDidAppear:(BOOL)animated {
    
    [self restartGame];

}

- (void) restartGame {
    
    self.diceOnBoard = NO;
    self.farkleFound = NO;
    self.firstRoll = YES;
    self.canRollAgain = YES;
    self.gameOver = NO;
    
    self.whosTurn = 0;
    self.currentFullTurnScore = 0;
    
    self.diceImageNames = [[NSArray alloc] initWithObjects:@"dice1", @"dice2", @"dice3", @"dice4", @"dice5", @"dice6", nil];
    
    
    self.farkleLabel.hidden = YES;
    self.winnerLabel.hidden = YES;
    self.playAgainButton.hidden = YES;
    
    
    Player *playerOne = [[Player alloc] init];
    playerOne.playerName = @"Joe";
    playerOne.playerNumber = 1;
    playerOne.playerScore = 0;
    Player *playerTwo = [[Player alloc] init];
    playerTwo.playerName = @"Sally";
    playerTwo.playerNumber = 1;
    playerTwo.playerScore = 0;
    
    self.players = [[NSMutableArray alloc] initWithObjects:playerOne, playerTwo, nil];
    
    NSString *playerOneNameAndScore = [[NSString alloc] initWithFormat:@"  %@: 0", playerOne.playerName];
    self.playerOneLabel = [[Button alloc] initWithText:playerOneNameAndScore andColor:OrangeColor andTextColor:BlueColor andFrame:self.playerOneLabel.frame];
    self.playerOneLabel.buttonLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.playerOneLabel];
    
    NSString *playerTwoNameAndScore = [[NSString alloc] initWithFormat:@"  %@: 0", playerTwo.playerName];
    self.playerTwoLabel = [[Button alloc] initWithText:playerTwoNameAndScore andColor:OrangeColor andTextColor:BlueColor andFrame:self.playerTwoLabel.frame];
    self.playerTwoLabel.buttonLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.playerTwoLabel];
    
    Button *buttonForColor = [[Button alloc] init];
    
    self.playerOneLabel.backgroundColor = [buttonForColor setColor:BlueColor];
    self.playerOneLabel.buttonLabel.textColor = [buttonForColor setColor:OrangeColor];
    self.playerTwoLabel.backgroundColor = [buttonForColor setColor:OrangeColor];
    self.playerTwoLabel.buttonLabel.textColor = [buttonForColor setColor:BlueColor];
    
    
    self.playerThreeLabel.hidden = YES;
    self.playerFourLabel.hidden = YES;
    
    self.rollButton = [[Button alloc] initWithText:@"Roll" andColor:OrangeColor andTextColor:BlueColor andFrame:self.rollButton.frame];
    self.rollButton.layer.cornerRadius = self.rollButton.bounds.size.height/2.0;
    self.rollButton.tag = 7;
    [self.view addSubview:self.rollButton];
    
    Button *backButton = [[Button alloc] initWithImage:@"backarrow" andFrame:CGRectMake(20.0, 25.0, 70.0, 40.0)];
    backButton.tag = 8;
    [self.view addSubview:backButton];
    backButton.delegate = self;
    
    self.cashInButton = [[Button alloc] initWithText:@"Cash In" andColor:OrangeColor andTextColor:BlueColor andFrame:self.cashInButton.frame];
    [self.view addSubview:self.cashInButton];
    [self.view bringSubviewToFront:self.cashInButton];
    self.cashInButton.tag = 9;
    
    
    CGRect startingPoint = CGRectMake(self.view.center.x, self.view.center.y, 50, 50);
    
    Button *diceOne = [[Button alloc] initWithImage:@"dice6" andFrame:startingPoint];
    
    Button *diceTwo = [[Button alloc] initWithImage:@"dice6" andFrame:startingPoint];
    
    Button *diceThree = [[Button alloc] initWithImage:@"dice6" andFrame:startingPoint];
    
    Button *diceFour = [[Button alloc] initWithImage:@"dice6" andFrame:startingPoint];
    
    Button *diceFive = [[Button alloc] initWithImage:@"dice6" andFrame:startingPoint];
    
    Button *diceSix = [[Button alloc] initWithImage:@"dice6" andFrame:startingPoint];
    
    
    self.diceSet = [[NSCountedSet alloc] initWithObjects:diceOne, diceTwo, diceThree, diceFour, diceFive, diceSix, nil];
    
    int i = 1;
    
    for (Button *dice in self.diceSet) {
        dice.tag = i;
        [self.view addSubview:dice];
        dice.hidden = YES;
        dice.delegate = self;
        i++;
    }
    
    
    self.masterDiceSet = [[NSCountedSet alloc] initWithSet:self.diceSet];
    
    
    
    [self resetDiceAndSet];
    
    [UIView animateWithDuration:2.0 animations:^{
        self.loadingOverlay.alpha = 0.0;
    }];
}


- (void) resetDiceAndSet {
    self.rollButton.buttonLabel.text = @"Roll";
    self.farkleLabel.hidden = YES;
    
    self.cashInButton.delegate = self;
    self.rollButton.delegate = self;
    
    self.diceSet = [[NSCountedSet alloc] initWithSet:self.masterDiceSet];
    
    
    
    
    for (Button *dice in self.diceSet) {
        dice.hidden = YES;
        dice.delegate = self;
        dice.dieInPlay = YES;
        dice.selected = NO;
        dice.backgroundColor = [UIColor colorWithPatternImage:[dice imageForScaling:[UIImage imageNamed:dice.backgroundImage] scaledToSize:CGSizeMake(50.0, 50.0)]];
        
    }
    self.firstRoll = YES;
    
    self.currentFullTurnScoreLabel.text = @"0";
    self.currentScoreLabel.text = @"0";
    
    Player *playerOne = [[Player alloc] init];
    playerOne = [self.players objectAtIndex:0];
    NSString *playerOneNameAndScore = [[NSString alloc] initWithFormat:@"  %@: %ld", playerOne.playerName, (long)playerOne.playerScore];
    self.playerOneLabel.buttonLabel.text = playerOneNameAndScore;
    
    Player *playerTwo = [[Player alloc] init];
    playerTwo = [self.players objectAtIndex:1];
    NSString *playerTwoNameAndScore = [[NSString alloc] initWithFormat:@"  %@: %ld", playerTwo.playerName, (long)playerTwo.playerScore];
    self.playerTwoLabel.buttonLabel.text = playerTwoNameAndScore;
    
    
    
}

- (void) buttonPressed:(UITapGestureRecognizer *)sender {
    
    UIView *senderButton = sender.view;
    
    if (senderButton.tag == 0) {
    }
    else if (senderButton.tag < 7 && !self.farkleFound && !self.gameOver) {
        [self diceTapped:senderButton];
    } else if (senderButton.tag == 7 && !self.farkleFound && !self.gameOver) {
        [self rollDice];
    } else if (senderButton.tag == 8) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainMenuViewController *mainMenuVC = (MainMenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
        [self presentViewController:mainMenuVC animated:YES completion:nil];
    } else if (senderButton.tag == 9 && !self.farkleFound && !self.gameOver) {
        [self cashIn];
    } else if (senderButton.tag == 10 && self.gameOver) {
        [self restartGame];
    } else {
        NSLog(@"User tapping elsewhere.");
    }
}



- (void) diceTapped:(UIView *)senderButton {
    for (Button *dice in self.diceSet) {
        if (dice.tag == senderButton.tag) {
            if (dice.selected) {
                dice.backgroundColor = [UIColor colorWithPatternImage:[dice imageForScaling:[UIImage imageNamed:dice.backgroundImage] scaledToSize:CGSizeMake(50.0, 50.0)]];
                dice.selected = NO;
            } else {
                dice.backgroundColor = [UIColor colorWithPatternImage:[dice imageForScaling:[UIImage imageNamed:[NSString stringWithFormat:@"%@inverted", dice.backgroundImage]] scaledToSize:CGSizeMake(50.0, 50.0)]];
                dice.selected = YES;
            }
        }
    }
    
    self.gameModel = [[GameModel alloc] init];
    self.currentScore = [self.gameModel countScore:self.diceSet forAll:NO];
    self.currentScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.currentScore];
    
    if (!self.farkleFound) {
        self.rollButton.buttonLabel.text = @"Roll Again";
        self.canRollAgain = YES;
    }

}



- (void) cashIn {
    
    self.currentFullTurnScore = self.currentFullTurnScore + self.currentScore;
    
    Player *lastTurnPlayer = [[Player alloc] init];
    lastTurnPlayer = [self.players objectAtIndex:(int)self.whosTurn];
    lastTurnPlayer.playerScore = lastTurnPlayer.playerScore + self.currentFullTurnScore;
    
    [self resetDiceAndSet];
    
    for (Player *player in self.players) {
        if (player.playerScore >= 10000) {
            [self gameOver:player.playerName];
        }
    }
    
    self.currentFullTurnScore = 0;
    self.currentScore = 0;
    
    Button *buttonForColor = [[Button alloc] init];
    
    if (self.whosTurn == self.players.count - 1) {
        self.whosTurn = 0;
    } else {
        self.whosTurn = self.whosTurn + 1;
    }
    
    if (self.whosTurn == 0) {
        self.playerOneLabel.backgroundColor = [buttonForColor setColor:BlueColor];
        self.playerOneLabel.buttonLabel.textColor = [buttonForColor setColor:OrangeColor];
        self.playerTwoLabel.backgroundColor = [buttonForColor setColor:OrangeColor];
        self.playerTwoLabel.buttonLabel.textColor = [buttonForColor setColor:BlueColor];
    } else {
        self.playerOneLabel.backgroundColor = [buttonForColor setColor:OrangeColor];
        self.playerOneLabel.buttonLabel.textColor = [buttonForColor setColor:BlueColor];
        self.playerTwoLabel.backgroundColor = [buttonForColor setColor:BlueColor];
        self.playerTwoLabel.buttonLabel.textColor = [buttonForColor setColor:OrangeColor];
    }
    
}




- (void) rollDice {
    
//    CGRect diceLandingArea = CGRectMake(self.leftView.frame.size.width, 0.0, self.view.frame.size.width - (self.leftView.bounds.size.width * 2), self.view.frame.size.height);
//    
//    int originX = (int) roundf(self.leftView.frame.size.width);
//    int originY = 0;
//    int width = self.view.frame.size.width - (self.leftView.bounds.size.width * 2);
//    int height = self.view.frame.size.height;
    
    
    if (!self.firstRoll) {
        NSCountedSet *tempSet = [[NSCountedSet alloc] initWithSet:self.diceSet];
        
            for (Button *dice in tempSet) {
                if (dice.selected) {
                    [self.diceSet removeObject:dice];
                    dice.hidden = YES;
                }
            }
        self.currentFullTurnScore = self.currentFullTurnScore + self.currentScore;
        self.currentScore = 0;
        
        self.currentFullTurnScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.currentFullTurnScore];
        self.currentScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.currentScore];
    }

    
    self.diceOnBoard = YES;
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.dynamicAnimator.delegate = self;
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:[self.diceSet allObjects]];
    [collisionBehavior addItem:self.leftView];
    [collisionBehavior addItem:self.rightView];
    
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.dynamicAnimator addBehavior:collisionBehavior];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:[self.diceSet allObjects]];
    itemBehavior.resistance = 1.8;
    itemBehavior.elasticity = 0.5;
    itemBehavior.angularResistance = 2.0;
    [self.dynamicAnimator addBehavior:itemBehavior];
    
    
    
    for (Button *dice in self.diceSet) {
//        int xAxis = arc4random_uniform(width) + originX;
//        int yAxis = arc4random_uniform(height);
//        dice.endCoordinates = CGPointMake(xAxis, yAxis);
        
        dice.hidden = NO;
        
        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[dice] mode:UIPushBehaviorModeInstantaneous];
        
        float pushDirection;
        
        if (self.diceOnBoard) {
            pushDirection = arc4random_uniform(550);
        } else {
            pushDirection = arc4random_uniform(200) + 350;
        }
        
        pushDirection = pushDirection / 100;
        
        [pushBehavior setAngle:pushDirection magnitude:1.5];
        [self.dynamicAnimator addBehavior:pushBehavior];
        
    }
    
    self.diceOnBoard = YES;
    
    self.diceChangeTimer = [[NSTimer alloc] init];
    self.timeInterval = 0.2;
    self.diceChangeTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(diceSwitchImage) userInfo:nil repeats:YES];
    
    self.firstRoll = NO;
    
    
}

//Once the dice stop moving, check for a farkle
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    self.gameModel = [[GameModel alloc] init];
    
    if ([self.gameModel countScore:self.diceSet forAll:YES] == 0) {
        self.farkleLabel.hidden = NO;
        [self.view bringSubviewToFront:self.farkleLabel];
        self.farkleFound = YES;
        self.canRollAgain = NO;
        
        NSTimer *farkleOnScreenDelay = [[NSTimer alloc] init];
        farkleOnScreenDelay = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(farkleDelayOver) userInfo:nil repeats:NO];
    }
    
}

- (void) farkleDelayOver {
    self.farkleLabel.hidden = YES;
    self.farkleFound = NO;
    
    self.currentFullTurnScore = 0;
    self.currentScore = 0;
    
    [self cashIn];
    
}

- (void) gameOver:(NSString *)winnerName {
    
    self.gameOver = YES;
    
    self.winnerLabel.text = [NSString stringWithFormat:@"%@ Wins!", winnerName];
    self.winnerLabel.hidden = NO;
    
    self.playAgainButton = [[Button alloc] initWithText:@"Play Again" andColor:OrangeColor andTextColor:BlueColor andFrame:self.playAgainButton.layer.frame];
    self.playAgainButton.tag = 10;
    self.playAgainButton.delegate = self;
    self.playAgainButton.hidden = NO;
    [self.view addSubview:self.playAgainButton];
    
    
}

//Toggle through random dice sides while dice are being rolled
- (void) diceSwitchImage {
    for (Button *dice in self.diceSet) {
        int random = arc4random_uniform(6);
        dice.currentNumber = [NSNumber numberWithInt:(random + 1)];
        dice.backgroundImage = self.diceImageNames[random];
        
        UIImage *newImage = [[UIImage alloc] init];
        newImage = [dice imageForScaling:[UIImage imageNamed:dice.backgroundImage] scaledToSize:CGSizeMake(50.0, 50.0)];
        dice.backgroundColor = [UIColor colorWithPatternImage:newImage];
        self.timeInterval = self.timeInterval + 0.1;
        
        if (self.timeInterval > 3) {
            [self.diceChangeTimer invalidate];
        }
    }
}


@end
