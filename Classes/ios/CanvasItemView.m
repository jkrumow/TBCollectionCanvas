//
//  CanvasView.m
//
//  Created by Julian Krumow on 10.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
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
