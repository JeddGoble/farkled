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


@class Button;

@protocol ButtonDelegate <NSObject>

- (void) buttonPressed:(UITapGestureRecognizer *)senderButton;

@end


@interface Button : UIView



@property (strong, nonatomic) NSString *text;
@property (nonatomic) ColorType mainColor;
@property (nonatomic) ColorType textColor;
@property (nonatomic) ColorType borderColor;
@property (nonatomic) CGRect *originAndBounds;
@property (strong, nonatomic) NSString *backgroundImage;
@property (strong, nonatomic) NSString *backgroundImageInverted;
@property (nonatomic) CGPoint startingCoordinates;
@property (nonatomic) CGPoint endCoordinates;
@property (nonatomic, assign) id <ButtonDelegate> delegate;
@property (nonatomic) BOOL selected;
@property (nonatomic) int currentNumber;

- (UIView *) initWithText:(NSString *)text andColor:(ColorType)mainColor andTextColor:(ColorType)textColor andFrame:(CGRect)originAndBounds;

- (UIView *) initWithImage:(NSString *)imageName andFrame:(CGRect)originAndBounds;

- (UIImage *)imageForScaling:(UIImage *)image scaledToSize:(CGSize)newSize;

- (UIColor *) setColor:(ColorType)paletteColor;


@end
