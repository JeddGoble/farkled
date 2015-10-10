//
//  GameModel.m
//  FarkleWeekendProject
//
//  Created by Jedd Goble on 10/9/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "GameModel.h"
#import "Button.h"

@implementation GameModel


- (NSInteger) countScore:(NSCountedSet *)diceSet forAll:(BOOL)scoreCheckYesOrNo {
    NSInteger score;
    score = 0;
    
    BOOL keepSearching = YES;
    
    NSCountedSet *selectedSet = [[NSCountedSet alloc] init];
    
    //If checking just selected, create a set of only those dice that have been selected by the user
    if (!scoreCheckYesOrNo) {
        for (Button *dice in diceSet) {
            if (dice.selected) {
                [selectedSet addObject:dice.currentNumber];
            }
        }
    } else {
        for (Button *dice in diceSet) {
            [selectedSet addObject:dice.currentNumber];
        }
    }
    
    //Add 1 each time a pair is found. (A pair by itself is worthless, but 3 pairs is 1500 points)
    int threePairs = 0;
    
    int twoTriplets = 0;
    
    BOOL fourFound = NO;
    BOOL twoFound = NO;
    
    //Search for 6 of a kind, 5 of a kind, etc
    for (int i = 1; i < 7; i++) {
        
        NSUInteger matches = [selectedSet countForObject:[NSNumber numberWithInt:i]];
        
        if (matches == 6) {
            score = 3000;
        } else if (matches == 5) {
            score = 2000;
        } else if (matches == 4) {
            score = 1000;
            fourFound = YES;
        } else if (matches == 3) {
            if (i == 1) {
                score = 300;
            } else {
                score = i * 100;
            }
            twoTriplets ++;
        } else if (matches == 2) {
            threePairs++;
            twoFound = YES;
        }
        
        if (score > 0) {
            keepSearching = NO;
        }
        
    }
    
    //Check for combinations
    if (threePairs == 3) {
        score = 1500;
    }
    if (twoTriplets == 2) {
        score = 2500;
    }
    if (fourFound && twoFound) {
        score = 1500;
    }
    
    //Check for a straight
    NSCountedSet *straightSet = [[NSCountedSet alloc] initWithObjects:@1, @2, @3, @4, @5, @6, nil];
    if ([selectedSet isEqualToSet:straightSet]) {
        score = 1500;
        keepSearching = NO;
    }
    
    
    
    //If nothing found, just assign points for individual die
    if (keepSearching) {
        NSUInteger ones = [selectedSet countForObject:@1];
        score = 100 * (int)ones;
        
        NSUInteger fives = [selectedSet countForObject:@5];
        score = score + (50 * (int)fives);
    }
    
    return score;
}


@end
