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
@property (strong, nonatomic) NSMutableArray *playerLabelsArray;

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
    
    
    self.players = [[NSMutableArray alloc] init];
    self.playerLabelsArray = [[NSMutableArray alloc] init];
    
    Player *playerOne = [[Player alloc] init];
    playerOne.playerName = @"John";
    [self.players addObject:playerOne];
    NSString *playerOneNameAndScore = [[NSString alloc] initWithFormat:@"  %@: 0", playerOne.playerName];
    self.playerOneLabel = [[Button alloc] initWithText:playerOneNameAndScore andColor:OrangeColor andTextColor:BlueColor andFrame:self.playerOneLabel.frame];
    self.playerOneLabel.backgroundColor = [self.playerOneLabel setColor:BlueColor];
    self.playerOneLabel.buttonLabel.textColor = [self.playerOneLabel setColor:OrangeColor];
    self.playerOneLabel.buttonLabel.textAlignment = NSTextAlignmentLeft;
    self.playerOneLabel.hidden = NO;
    [self.view addSubview:self.playerOneLabel];
    [self.playerLabelsArray addObject:self.playerOneLabel];
    
    Player *playerTwo = [[Player alloc] init];
    playerTwo.playerName = @"Paul";
    [self.players addObject:playerTwo];
    NSString *playerTwoNameAndScore = [[NSString alloc] initWithFormat:@"  %@: 0", playerTwo.playerName];
    self.playerTwoLabel = [[Button alloc] initWithText:playerTwoNameAndScore andColor:OrangeColor andTextColor:BlueColor andFrame:self.playerTwoLabel.frame];
    self.playerTwoLabel.buttonLabel.textAlignment = NSTextAlignmentLeft;
    self.playerOneLabel.hidden = NO;
    [self.view addSubview:self.playerTwoLabel];
    [self.playerLabelsArray addObject:self.playerTwoLabel];
    
    if (self.numberOfPlayers >= 1) {
        Player *playerThree = [[Player alloc] init];
        playerThree.playerName = @"Ringo";
        [self.players addObject:playerThree];
        NSString *playerThreeNameAndScore = [[NSString alloc] initWithFormat:@"  %@: 0", playerThree.playerName];
        self.playerThreeLabel = [[Button alloc] initWithText:playerThreeNameAndScore andColor:OrangeColor andTextColor:BlueColor andFrame:self.playerThreeLabel.frame];
        self.playerThreeLabel.buttonLabel.textAlignment = NSTextAlignmentLeft;
        self.playerThreeLabel.hidden = NO;
        [self.view addSubview:self.playerThreeLabel];
        [self.playerLabelsArray addObject:self.playerThreeLabel];
    }
    
    if (self.numberOfPlayers == 2) {
        Player *playerFour = [[Player alloc] init];
        playerFour.playerName = @"George";
        [self.players addObject:playerFour];
        NSString *playerFourNameAndScore = [[NSString alloc] initWithFormat:@"  %@: 0", playerFour.playerName];
        self.playerFourLabel = [[Button alloc] initWithText:playerFourNameAndScore andColor:OrangeColor andTextColor:BlueColor andFrame:self.playerFourLabel.frame];
        self.playerFourLabel.buttonLabel.textAlignment = NSTextAlignmentLeft;
        self.playerFourLabel.hidden = NO;
        [self.view addSubview:self.playerFourLabel];
        [self.playerLabelsArray addObject:self.playerFourLabel];
    }
    

    
    int i = 0;
    for (Player *player in self.players) {
        player.playerNumber = i;
        player.playerScore = 0;
        i++;
    }
    
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
    
    i = 1;
    
    for (Button *dice in self.diceSet) {
        dice.tag = i;
        [self.view addSubview:dice];
        dice.hidden = YES;
        dice.delegate = self;
        i++;
    }
    
    
    self.masterDiceSet = [[NSCountedSet alloc] initWithSet:self.diceSet];
    
    
    
    [self resetDiceAndSet];
    
    [self.view bringSubviewToFront:self.loadingOverlay];
    [UIView animateWithDuration:0.7 animations:^{
        self.loadingOverlay.alpha = 0.0;
    }];
    
    
}


- (void) resetDiceAndSet {
    self.rollButton.buttonLabel.text = @"Roll";
    self.farkleLabel.hidden = YES;
    
    self.cashInButton.delegate = self;
    self.rollButton.delegate = self;
    
    self.diceSet = [[NSCountedSet alloc] initWithSet:self.masterDiceSet];
    
//    CGRect diceStartingPoint = CGRectMake(self.view.center.x, self.view.center.y, 50, 50);

    
    for (Button *dice in self.diceSet) {
//        dice.frame = CGRectMake(self.view.center.x, self.view.center.y, 50, 50);
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
//        [self selectedDiceSnapAnimation];
//        NSTimer *cashInTimer = [[NSTimer alloc] init];
//        cashInTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(cashIn) userInfo:nil repeats:NO];
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
    
    if (self.whosTurn == self.players.count - 1) {
        self.whosTurn = 0;
    } else {
        self.whosTurn = self.whosTurn + 1;
    }
    
    Button *buttonForColor = [[Button alloc] init];
    
    for (Button *playerLabel in self.playerLabelsArray) {
        if ([self.playerLabelsArray indexOfObject:playerLabel] == self.whosTurn) {
            playerLabel.backgroundColor = [buttonForColor setColor:BlueColor];
            playerLabel.buttonLabel.textColor = [buttonForColor setColor:OrangeColor];
        } else {
            playerLabel.backgroundColor = [buttonForColor setColor:OrangeColor];
            playerLabel.buttonLabel.textColor = [buttonForColor setColor:BlueColor];
        }
        
    }
    
}




- (void) rollDice {
    
    if (self.firstRoll) {
        [self diceRollAnimation];
    } else {
//        [self selectedDiceSnapAnimation];
//        NSTimer *rollTimer = [[NSTimer alloc] init];
//        rollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(diceRollAnimation) userInfo:nil repeats:NO];
        [self diceRollAnimation];
    }
    
    
    
}

- (void) selectedDiceSnapAnimation {

    
    [self.dynamicAnimator removeAllBehaviors];
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.dynamicAnimator.delegate = self;
    
    CGPoint point = CGPointMake(self.rollButton.center.x, self.rollButton.center.y);
    
    for (Button *dice in self.diceSet) {
        if (dice.selected) {
            UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:dice snapToPoint:point];
            [self.dynamicAnimator addBehavior:snapBehavior];
            [UIView animateWithDuration:1.0 animations:^{
                dice.alpha = 0.0;
            }];
    
        }
    }
}


- (void) diceRollAnimation {
    
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
    
    [self.dynamicAnimator removeAllBehaviors];
    
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
