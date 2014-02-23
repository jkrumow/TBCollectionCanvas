//
//  CanvasView.m
//
//  Created by Julian Krumow on 10.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


#import "CanvasItemView.h"

@implementation CanvasItemView

@synthesize zoomScale;
@synthesize deltaToCollapsedNode;
@synthesize isInCollapsedSegment;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isSelected = NO;
        _isHighlighted = NO;
        _isEditing = NO;
        
        zoomScale = 0.5;
        
        deltaToCollapsedNode = CGSizeMake(0.0, 0.0);
        isInCollapsedSegment = NO;
        
        self.opaque = YES;
    }
    return self;
}

- (CGRect)scaledFrame
{
    return CGRectMake(self.frame.origin.x * zoomScale, self.frame.origin.y * zoomScale,
                      self.frame.size.width * zoomScale, self.frame.size.height * zoomScale);
}

- (CGPoint)scaledCenter
{
    return CGPointMake(self.center.x * zoomScale, self.center.y *zoomScale);
}

- (void)setSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
}

- (void)setHighlighted:(BOOL)isHighlighted
{
    _isHighlighted = isHighlighted;
}

- (void)setZoomScale:(CGFloat)scale
{
    zoomScale = scale;
}

- (void)setCenter:(CGPoint)center animated:(BOOL)animated
{
    if (animated) {
        
        void(^slideToCenter)(void) = ^(void) {
            
            [super setCenter:center];
        };
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut 
                         animations:slideToCenter 
                         completion:nil];
        
    } else
        [super setCenter:center];
}

@end
