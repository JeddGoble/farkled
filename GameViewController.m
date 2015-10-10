//
//  GameViewController.m
//  FarkleWeekendProject
//
//  Created by Jedd Goble on 10/8/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "GameViewController.h"
#import "Button.h"

@interface GameViewController () <ButtonDelegate>
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) NSArray *diceImageNames;
@property (strong, nonatomic) NSSet *diceSet;
@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (strong, nonatomic) NSTimer *diceChangeTimer;
@property (nonatomic) NSTimeInterval timeInterval;
@property (strong, nonatomic) UILabel *currentTurnScoreLabel;
@property (nonatomic) BOOL diceOnBoard;
@property (strong, nonatomic) IBOutlet Button *cashInButton;
@property (strong, nonatomic) IBOutlet Button *rollButton;




@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.diceOnBoard = NO;
    
    self.diceImageNames = [[NSArray alloc] initWithObjects:@"dice1", @"dice2", @"dice3", @"dice4", @"dice5", @"dice6", nil];
    
    
//    self.currentTurnScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(rollButton.frame.origin.x, self.view.frame.size.height / 2, 100.0, 50.0)];
//    self.currentTurnScoreLabel.textAlignment = NSTextAlignmentCenter;
//    self.currentTurnScoreLabel.text = @"150";
//    self.currentTurnScoreLabel.textColor = [rollButton setColor:BlueColor];
//    [self.view addSubview:self.currentTurnScoreLabel];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.cashInButton = [[Button alloc] initWithText:@"Cash In" andColor:OrangeColor andTextColor:BlueColor andFrame:self.cashInButton.frame];
    [self.rightView addSubview:self.cashInButton];
    
    self.rollButton = [[Button alloc] initWithText:@"Roll" andColor:OrangeColor andTextColor:BlueColor andFrame:self.rollButton.frame];
    self.rollButton.layer.cornerRadius = self.rollButton.bounds.size.height/2.0;
    self.rollButton.tag = 7;
    self.rollButton.delegate = self;
    [self.view addSubview:self.rollButton];
    
    
    CGRect startingPoint = CGRectMake(self.rollButton.frame.origin.x - 100, self.rollButton.frame.origin.y + 50, 50, 50);
    
    Button *diceOne = [[Button alloc] initWithImage:@"dice6" andFrame:startingPoint];
    
    Button *diceTwo = [[Button alloc] initWithImage:@"dice6" andFrame:startingPoint];
    
    Button *diceThree = [[Button alloc] initWithImage:@"dice6" andFrame:startingPoint];
    
    Button *diceFour = [[Button alloc] initWithImage:@"dice6" andFrame:startingPoint];
    
    Button *diceFive = [[Button alloc] initWithImage:@"dice6" andFrame:startingPoint];
    
    Button *diceSix = [[Button alloc] initWithImage:@"dice6" andFrame:startingPoint];
    
    
    self.diceSet = [[NSSet alloc] initWithObjects:diceOne, diceTwo, diceThree, diceFour, diceFive, diceSix, nil];
    
    
    int i = 1;
    
    for (Button *dice in self.diceSet) {
        dice.tag = i;
        [self.view addSubview:dice];
        dice.hidden = YES;
        dice.delegate = self;
        i++;
    }
    
    
    Button *backButton = [[Button alloc] initWithImage:@"backarrow" andFrame:CGRectMake(20.0, 25.0, 70.0, 40.0)];
    backButton.tag = 8;
    [self.view addSubview:backButton];
    backButton.delegate = self;
    
    
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void) buttonPressed:(UITapGestureRecognizer *)sender {
    
    UIView *senderButton = sender.view;
    
    if (senderButton.tag == 0) {
        
    }
    else if (senderButton.tag < 7) {
        for (Button *dice in self.diceSet) {
            if (dice.tag == senderButton.tag) {
                if (dice.selected) {
                    dice.backgroundColor = [UIColor colorWithPatternImage:[dice imageForScaling:[UIImage imageNamed:dice.backgroundImage] scaledToSize:CGSizeMake(50.0, 50.0)]];
                } else {
                dice.backgroundColor = [UIColor colorWithPatternImage:[dice imageForScaling:[UIImage imageNamed:[NSString stringWithFormat:@"%@inverted", dice.backgroundImage]] scaledToSize:CGSizeMake(50.0, 50.0)]];
                }
                dice.selected = !dice.selected;
            }
        }
    }
        
    else if (senderButton.tag == 7) {
        [self rollDice];
    }
    
    
}

- (void) rollDice {
    
//    CGRect diceLandingArea = CGRectMake(self.leftView.frame.size.width, 0.0, self.view.frame.size.width - (self.leftView.bounds.size.width * 2), self.view.frame.size.height);
//    
//    int originX = (int) roundf(self.leftView.frame.size.width);
//    int originY = 0;
//    int width = self.view.frame.size.width - (self.leftView.bounds.size.width * 2);
//    int height = self.view.frame.size.height;
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
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
    
    
    
}

- (void) diceSwitchImage {
    for (Button *dice in self.diceSet) {
        int random = arc4random_uniform(6);
        dice.currentNumber = random;
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
