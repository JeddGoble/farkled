//
//  Button.h
//  FarkleWeekendProject
//
//  Created by Jedd Goble on 10/8/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum Color  {
    OrangeColor,
    BlueColor,
    RedColor,
    ClearColor
} ColorType;

@interface Button : UIView



@property (strong, nonatomic) NSString *text;
@property (nonatomic) ColorType mainColor;
@property (nonatomic) ColorType textColor;
@property (nonatomic) ColorType borderColor;
@property (nonatomic) CGRect *originAndBounds;
@property (strong, nonatomic) NSString *backgroundImage;

- (UIView *) initWithText:(NSString *)text andColor:(ColorType)mainColor andTextColor:(ColorType)textColor andFrame:(CGRect)originAndBounds;

- (UIView *) initWithImage:(NSString *)imageName andFrame:(CGRect)originAndBounds;


@end
