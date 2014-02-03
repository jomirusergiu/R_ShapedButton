//
//  R_ShapedButton.m
//  R_ShapedButton
//
//  Created by RocKK on 2/3/14.
//  Copyright (c) 2014 RocKK.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms are permitted
//  provided that the above copyright notice and this paragraph are
//  duplicated in all such forms and that any documentation,
//  advertising materials, and other materials related to such
//  distribution and use acknowledge that the software was developed
//  by the RocKK.  The name of the
//  RocKK may not be used to endorse or promote products derived
//  from this software without specific prior written permission.
//  THIS SOFTWARE IS PROVIDED ''AS IS'' AND WITHOUT ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

#import "R_ShapedButton.h"
#import "UIImage+ColorAtPixel.h"

@implementation R_ShapedButton

- (BOOL)isAlphaVisibleAtPoint:(CGPoint)point forImage:(UIImage *)image 
{
    // Correct point to take into account that the image does not have to be the same size as the button.
    CGSize imageSize = image.size;
    CGSize buttonSize = self.frame.size;
    point.x *= (buttonSize.width != 0) ? (imageSize.width / buttonSize.width) : 1;
    point.y *= (buttonSize.height != 0) ? (imageSize.height / buttonSize.height) : 1;

    CGColorRef pixelColor = [[image colorAtPixel:point] CGColor];
    CGFloat alpha = CGColorGetAlpha(pixelColor);
    return alpha >= kAlphaVisibleThreshold;
}


// UIView uses this method in hitTest:withEvent: to determine which subview should receive a touch event.
// If pointInside:withEvent: returns YES, then the subview’s hierarchy is traversed; otherwise, its branch
// of the view hierarchy is ignored.
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event 
{
    // Return NO if even super returns NO (i.e., if point lies outside our bounds)
    BOOL superResult = [super pointInside:point withEvent:event];
    if (!superResult) {
        return superResult;
    }

    // We can't test the image's alpha channel if the button has no image. Fall back to super.
    UIImage *buttonImage = [self imageForState:UIControlStateNormal];
    UIImage *buttonBackground = [self backgroundImageForState:UIControlStateNormal];

    if (buttonImage == nil && buttonBackground == nil) {
        return YES;
    }
    else if (buttonImage != nil && buttonBackground == nil) {
        return [self isAlphaVisibleAtPoint:point forImage:buttonImage];
    }
    else if (buttonImage == nil && buttonBackground != nil) {
        return [self isAlphaVisibleAtPoint:point forImage:buttonBackground];
    }
    else {
        if ([self isAlphaVisibleAtPoint:point forImage:buttonImage]) {
            return YES;
        } else {
            return [self isAlphaVisibleAtPoint:point forImage:buttonBackground];
        }
    }
}

@end
