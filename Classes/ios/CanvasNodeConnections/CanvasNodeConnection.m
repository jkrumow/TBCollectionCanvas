//
//  CanvasNodeConnection.m
//
//  Created by Julian Krumow on 29.01.12.
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

#import "CanvasNodeConnection.h"
#import "CanvasNodeView.h"

@interface CanvasNodeConnection()
{
    CAShapeLayer *shapeLayer;
}

/**
 Calculates the start point for the visible line. Point wanders around the bounds of the parent view.
 
 @param start The starting point of the connection
 @param end   The ending point of the connection
 
 @return The start point for the visible line.
 */
- (CGPoint)calculateStartPointForLineFrom:(CGPoint)start toPoint:(CGPoint)end;

/**
 Calculates the end point for the visible line. Point wanders around the bounds of the child view.
 
 @param start The starting point of the connection
 @param end   The ending point of the connection
 
 @return The end point for the visible line.
 */
- (CGPoint)calculateEndPointForLineFrom:(CGPoint)start toPoint:(CGPoint)end;

/**
 Calculates the offset between the center point a given CanvasNodeView and the intersection point with a given connection.
 
 @param start    The starting point of the connection
 @param end      The ending point of the connection
 @param nodeView The CanvasNodeView at either end.
 
 @return The offset between the center of the given CanvasNodeView and the intersection point.
 */
- (CGSize)calculateIntersectionOffsetForLineFrom:(CGPoint)start toPoint:(CGPoint)end forNodeView:(CanvasNodeView *)nodeView;

@end


@implementation CanvasNodeConnection

@synthesize parentIndex = _parentIndex;
@synthesize childIndex = _childIndex;
@synthesize parentNode = _parentNode;
@synthesize childNode = _childNode;
@synthesize canvasNodeConnectionDelegate;
@synthesize moveConnectionHandle;
@synthesize colorString;
@synthesize visibleStartPoint;
@synthesize visibleEndPoint;
@synthesize valid = _valid;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _parentIndex = -1;
        _childIndex = -1;
        
        _valid = YES;
        self.backgroundColor = [UIColor clearColor];
        
        CGColorRef backgroundColor = [self.backgroundColor CGColor];
        CALayer *layer = [self layer];
        layer.backgroundColor = backgroundColor;
        layer.borderColor = [[UIColor clearColor] CGColor];
        layer.borderWidth = 0.0;
        layer.opaque = YES;
        
#define showBorder 0
        
#if showBorder
        layer.borderColor = [[UIColor redColor] CGColor];
        layer.borderWidth = 4.0;
#endif
        shapeLayer = [CAShapeLayer layer];   
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        shapeLayer.strokeColor =[[UIColor lightGrayColor] CGColor];
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineWidth = 10.0f;
        shapeLayer.opaque = YES;
        [layer addSublayer:shapeLayer];
        
        [self setNeedsDisplay];
        
    }
    return self;
}

- (void)reset
{
    _parentNode = nil;
    _childNode = nil;
}

#pragma mark - Drawing

- (void)drawConnection
{
    self.frame = CGRectUnion(self.parentNode.frame, self.childNode.frame);
    CGPoint start = [self convertPoint:_parentNode.center fromView:self.superview];
    CGPoint end   = [self convertPoint:_childNode.center fromView:self.superview];
    
    [self drawConnectionFromPoint:start toPoint:end];
}

- (void)drawConnectionFromPoint:(CGPoint)start toPoint:(CGPoint)end
{
    visibleStartPoint = [self calculateStartPointForLineFrom:start toPoint:end];
    visibleEndPoint =  [self calculateEndPointForLineFrom:start toPoint:end];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, visibleStartPoint.x, visibleStartPoint.y);
    CGPoint controlPoint = CGPointMake(visibleStartPoint.x + ((visibleEndPoint.x - visibleStartPoint.x) * 0.5), visibleEndPoint.y);
    CGPathAddQuadCurveToPoint(path, NULL, controlPoint.x, controlPoint.y, visibleEndPoint.x, visibleEndPoint.y);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [self setNeedsDisplay];
}

- (CGSize)calculateIntersectionOffsetForLineFrom:(CGPoint)start toPoint:(CGPoint)end forNodeView:(CanvasNodeView *)nodeView
{
    CGFloat largeX = end.x - start.x;
    CGFloat largeY = end.y - start.y;
    
    CGFloat littleX = nodeView.bounds.size.width * 0.5;
    
    // Calculating y position
    CGFloat shrinkFactorY = 1.0;
    if (largeX != 0.0)
        shrinkFactorY = littleX / largeX;
    
    if (shrinkFactorY < 0.0)
        shrinkFactorY *= -1;
    
    CGFloat littleY = largeY * shrinkFactorY;
    littleY = MIN(littleY, nodeView.bounds.size.height * 0.5);
    littleY = MAX(littleY, -1 * (nodeView.bounds.size.height * 0.5));
    
    // Calculating x position
    CGFloat shrinkFactorX = 1.0;
    if (largeY != 0.0)
        shrinkFactorX = littleY / largeY;
    
    if (shrinkFactorX < 0.0)
        shrinkFactorX *= -1;
    
    littleX = largeX * shrinkFactorX;
    littleX = MIN(littleX, nodeView.bounds.size.width * 0.5);
    littleX = MAX(littleX, -1 * (nodeView.bounds.size.width * 0.5));
    
    return CGSizeMake(littleX, littleY);
}

- (CGPoint)calculateStartPointForLineFrom:(CGPoint)start toPoint:(CGPoint)end
{
    CGSize offset = [self calculateIntersectionOffsetForLineFrom:start toPoint:end forNodeView:self.parentNode];
    CGPoint intersectionPoint = CGPointMake(start.x + offset.width, start.y + offset.height);
    return intersectionPoint;
}

- (CGPoint)calculateEndPointForLineFrom:(CGPoint)start toPoint:(CGPoint)end
{
    CGSize offset = [self calculateIntersectionOffsetForLineFrom:start toPoint:end forNodeView:self.childNode];
    CGPoint intersectionPoint = CGPointMake(end.x - offset.width, end.y - offset.height);
    return intersectionPoint;
}

#pragma mark - Animating

- (void)suspenderSnapAnimation
{	
	// Connection is no longer valid.
    _valid = NO;
    
    CGMutablePathRef shortPath = CGPathCreateMutable();
    CGPathMoveToPoint(shortPath, NULL, visibleStartPoint.x, visibleStartPoint.y);
    CGPathAddLineToPoint(shortPath, NULL, visibleStartPoint.x + 1.0, visibleStartPoint.y + 1.0);
    
    // TODO: later switch to CAKeyFrameAnimation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    
    animation.duration = 0.1;
	animation.repeatCount = 0;
	animation.autoreverses = NO;
    
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
	animation.fromValue = (id)shapeLayer.path;
	animation.toValue = (__bridge id)shortPath;
    
    shapeLayer.path = shortPath;
	[shapeLayer addAnimation:animation forKey:@"animatePath"];
    CGPathRelease(shortPath);
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    NSIndexPath *connectionIndexPath = [self indexPath];
    if ([canvasNodeConnectionDelegate respondsToSelector:@selector(removedConnection:atIndexPath:)])
        [canvasNodeConnectionDelegate removedConnection:self atIndexPath:connectionIndexPath];
}

#pragma mark - Selecting

- (void)setSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
}

- (void)setCenter:(CGPoint)center animated:(BOOL)animated
{
    if (animated) {
        
        void(^slideToCenter)(void) = ^(void) {
            
            [super setCenter:center];
        };
        
        void(^redrawConnection)(BOOL) = ^(BOOL complete) {
        
            [self drawConnection];   
        };
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:slideToCenter 
                         completion:redrawConnection];
        
    } else
        [super setCenter:center];
}

- (NSIndexPath *)indexPath
{
    return [NSIndexPath indexPathForRow:self.tag inSection:self.parentNode.tag]; 
}

- (BOOL)checkTouchIsValid:(CGPoint)touch
{
    CGPoint localTouch = [self convertPoint:touch fromView:self.superview];
    CGPathRef tappableArea = CGPathCreateCopyByStrokingPath(shapeLayer.path, NULL, fmaxf(35.0f, shapeLayer.lineWidth), kCGLineCapRound, kCGLineJoinMiter, shapeLayer.miterLimit);
    BOOL isValid = CGPathContainsPoint(tappableArea, NULL, localTouch, true);
    CGPathRelease(tappableArea);
    return isValid;
}

- (void)setParentNode:(CanvasNodeView *)parentNode
{
    _parentNode = parentNode;
    _parentIndex = parentNode.tag;
}

- (void)setChildNode:(CanvasNodeView *)childNode
{
    _childNode = childNode;
    _childIndex = childNode.tag;
}

@end
