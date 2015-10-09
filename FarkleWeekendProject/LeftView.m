//
//  LeftView.m
//  FarkleWeekendProject
//
//  Created by Jedd Goble on 10/8/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "LeftView.h"
#import "Button.h"


@implementation LeftView

-(void)awakeFromNib {
    
    Button *backButton = [[Button alloc] initWithImage:@"backarrow" andFrame:CGRectMake(20.0, 25.0, 70.0, 40.0)];
    
    [self addSubview:backButton];
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    
    
}

@end