//
//  RightView.m
//  FarkleWeekendProject
//
//  Created by Jedd Goble on 10/8/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "RightView.h"
#import "Button.h"

@implementation RightView

- (void)awakeFromNib {
    
    Button *rollButton = [[Button alloc] initWithText:@"Roll" andColor:OrangeColor andTextColor:BlueColor andFrame:CGRectMake((self.frame.size.width/2.0) - 25.0, (self.frame.size.height/5.0), 90.0, 90.0)];
    rollButton.layer.cornerRadius = rollButton.bounds.size.height/2.0;
    [self addSubview:rollButton];
    
    
    
}



@end
