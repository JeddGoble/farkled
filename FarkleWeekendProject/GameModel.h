//
//  GameModel.h
//  FarkleWeekendProject
//
//  Created by Jedd Goble on 10/9/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject

- (NSInteger) countScore:(NSCountedSet *)diceSet forAll:(BOOL)scoreCheckYesOrNO;

@end
