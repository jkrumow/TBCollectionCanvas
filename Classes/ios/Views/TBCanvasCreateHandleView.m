//
//  TBCanvasCreateHandleView.m
//
//  Created by Julian Krumow on 11.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import <QuartzCore/QuartzCore.h>

#import "TBCanvasCreateHandleView.h"
#import "TBCanvasNodeView.h"
#import "TBCollectionCanvasContentView.h"

@interface TBCanvasCreateHandleView()

@property (strong, nonatomic) CAShapeLayer *shapeLayer;

- (void)highlightAnimation;

@end

@implementation TBCanvasCreateHandleView

//@synthesize nodeView = _nodeView;
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
        self.shapeLayer.fillColor = [[UIColor grayColor] CGColor];
        self.shapeLayer.strokeColor = [[UIColor darkGrayColor] CGColor];
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
        self.shapeLayer.fillColor = [[UIColor grayColor] CGColor];
        self.transform = CGAffineTransformIdentity;
    }
}

- (void)setNodeView:(TBCanvasNodeView *)nodeView
{
    _nodeView = nodeView;
    self.tag = nodeView.tag;
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    
    _touchOffset.width = center.x - location.x;
    _touchOffset.height = center.y - location.y;
    
    if ([self.delegate canProcessCanvasCreateHandle:self]) {
        if ([self.delegate respondsToSelector:@selector(canvasCreateHandle:touchesBegan:withEvent:)]) {
            [self.delegate canvasCreateHandle:self touchesBegan:touches withEvent:event];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate canProcessCanvasCreateHandle:self]) {
        if ([self.delegate respondsToSelector:@selector(canvasCreateHandle:touchesMoved:withEvent:)]) {
            [self.delegate canvasCreateHandle:self touchesMoved:touches withEvent:event];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate canProcessCanvasCreateHandle:self]) {
        if ([self.delegate respondsToSelector:@selector(canvasCreateHandle:touchesBegan:withEvent:)]) {
            [self.delegate canvasCreateHandle:self touchesEnded:touches withEvent:event];
        }
    }
    
    _touchOffset = CGSizeZero;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate canProcessCanvasCreateHandle:self]) {
        if ([self.delegate respondsToSelector:@selector(canvasCreateHandle:touchesBegan:withEvent:)]) {
            [self.delegate canvasCreateHandle:self touchesCancelled:touches withEvent:event];
        }
    }
    
    _touchOffset = CGSizeZero;
}

@end
