//
//  Button.m
//  FarkleWeekendProject
//
//  Created by Jedd Goble on 10/8/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "Button.h"

@implementation Button

- (UIView *) initWithText:(NSString *)text andColor:(ColorType)mainColor andTextColor:(ColorType)textColor andFrame:(CGRect)originAndBounds {
    
    self = [super init];
    
    if (self) {
        self.backgroundColor = [self setColor:mainColor];
        
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [self setColor:textColor].CGColor;
        
        self.frame = originAndBounds;
        

        
        UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        titleText.textAlignment = NSTextAlignmentCenter;
        titleText.text = text;
        titleText.textColor = [self setColor:textColor];
        
        [self addSubview:titleText];
        
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(3.0, 3.0);
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowRadius = 5.0;
        
    }
    
    
    
    return self;
}


- (UIView *) initWithImage:(NSString *)imageName andFrame:(CGRect)originAndBounds {
    
    self = [super init];
    
    if (self) {
        self.frame = originAndBounds;
        
        UIImage *imageForResize = [[UIImage alloc] init];
        imageForResize = [UIImage imageNamed:imageName];
        
        UIImage *resizedImage = [[UIImage alloc] init];
        resizedImage = [self imageWithImage:[UIImage imageNamed:imageName] scaledToSize:CGSizeMake(originAndBounds.size.width, originAndBounds.size.height)];
        
        self.backgroundColor = [UIColor colorWithPatternImage:resizedImage];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(3.0, 3.0);
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowRadius = 5.0;
        
    }
    
    return self;
}


- (UIColor *) setColor:(ColorType)paletteColor {
    UIColor *color = [[UIColor alloc] init];
    
    if (paletteColor == OrangeColor) {
        color = [UIColor colorWithRed:198.0/255.0 green:117.0/255.0 blue:45.0/255.0 alpha:1.0];
    } else if (paletteColor == BlueColor) {
        color = [UIColor colorWithRed:1.0/255.0 green:66.0/255.0 blue:72.0/255.0 alpha:1.0];
    } else if (paletteColor == RedColor) {
        color = [UIColor colorWithRed:198.0/255.0 green:53.0/255.0 blue:45.0/255.0 alpha:1.0];
    } else {
        color = [UIColor clearColor];
    }
    
    return color;
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end
