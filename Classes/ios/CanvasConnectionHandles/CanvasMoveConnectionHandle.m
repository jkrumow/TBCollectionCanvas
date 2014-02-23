//
//  CanvasMoveConnectionHandle.m
//
//  Created by Julian Krumow on 14.02.12.
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


#import <QuartzCore/QuartzCore.h>

#import "CanvasMoveConnectionHandle.h"
#import "CollectionCanvasView.h"

@interface CanvasMoveConnectionHandle()

@property (strong, nonatomic) CAShapeLayer *shapeLayer;

- (void)highlightAnimation;

@end

@implementation CanvasMoveConnectionHandle

@synthesize connection;
@synthesize shapeLayer = _shapeLayer;
@synthesize touchOffset = _touchOffset;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        CALayer *layer = [self layer];
        layer.backgroundColor = [self.backgroundColor CGColor];
        layer.borderColor = [[UIColor clearColor] CGColor];
        layer.borderWidth = 0.0f;
        layer.opaque = YES;
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.fillColor = [[UIColor purpleColor] CGColor];
        self.shapeLayer.strokeColor = [[UIColor purpleColor] CGColor];
        self.shapeLayer.lineWidth = 2.0f;
        self.shapeLayer.opaque = YES;
        [layer addSublayer:self.shapeLayer];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect bounds = self.bounds;
        CGPathAddEllipseInRect(path, NULL, bounds);
        
        self.shapeLayer.path = path;
        CGPathRelease(path);
        
        [self setNeedsDisplay];
    }
    return self;
}

- (void)setHighlighted:(BOOL)isHighlighted
{
    _isHighlighted = isHighlighted;
    
    [self highlightAnimation];
    
}

#define GROW_ANIMATION_DURATION_SECONDS 0.15
#define GROW_ANIMATION_SCALE 5.0

- (void)highlightAnimation
{
    if (_isHighlighted) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
        
        self.shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        CGAffineTransform transform = CGAffineTransformMakeScale(GROW_ANIMATION_SCALE, GROW_ANIMATION_SCALE);
        self.transform = transform;
        
        [UIView commitAnimations];
    } else {
        self.shapeLayer.fillColor = [[UIColor purpleColor] CGColor];
        self.transform = CGAffineTransformIdentity;
    }
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    
    _touchOffset.width = center.x - location.x;
    _touchOffset.height = center.y - location.y;
    
    if ([self.delegate canProcessCanvasMoveConnectionHandle:self])
        if ([self.delegate respondsToSelector:@selector(canvasMoveConnectionHandle:touchesBegan:withEvent:)])
            [self.delegate canvasMoveConnectionHandle:self touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate canProcessCanvasMoveConnectionHandle:self])
        if ([self.delegate respondsToSelector:@selector(canvasMoveConnectionHandle:touchesMoved:withEvent:)])
            [self.delegate canvasMoveConnectionHandle:self touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate canProcessCanvasMoveConnectionHandle:self])
        if ([self.delegate respondsToSelector:@selector(canvasMoveConnectionHandle:touchesBegan:withEvent:)])
            [self.delegate canvasMoveConnectionHandle:self touchesEnded:touches withEvent:event];
    
    _touchOffset = CGSizeZero;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate canProcessCanvasMoveConnectionHandle:self])
        if ([self.delegate respondsToSelector:@selector(canvasMoveConnectionHandle:touchesBegan:withEvent:)])
            [self.delegate canvasMoveConnectionHandle:self touchesCancelled:touches withEvent:event];
    
    _touchOffset = CGSizeZero;
}

@end
