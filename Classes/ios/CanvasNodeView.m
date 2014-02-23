//
//  CanvasNodeView.m
//
//  Created by Julian Krumow on 24.01.12.
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

#import "CanvasNodeView.h"
#import "CollectionCanvasView.h"

@interface CanvasNodeView()
{
    CGFloat scale;
}

@end

@implementation CanvasNodeView

@synthesize hasCollapsedSubStructure;
@synthesize headNodeTag;

@synthesize delegate;
@synthesize connectionHandle;

@synthesize connectedNodes;
@synthesize parentConnections;
@synthesize childConnections;

@synthesize connectionHandleAncorPoint;
@synthesize segmentRect;

@synthesize contentView = _contentView;
@synthesize touchOffset = _touchOffset;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        scale = [[UIScreen mainScreen] scale];
        
        connectedNodes = nil;
        parentConnections = nil;
        childConnections = nil;
        
        _isSelected = NO;
        _isHighlighted = NO;
        _isEditing = NO;
        hasCollapsedSubStructure = NO;
        headNodeTag = -1;
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = frame;
        self.segmentRect = self.frame;
        
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = self.window.screen.scale;
        self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
        self.clipsToBounds = NO;
        self.layer.masksToBounds = NO;
}
    return self;
}

- (void)reset
{
    [connectedNodes removeAllObjects];
    [parentConnections removeAllObjects];
    [childConnections removeAllObjects];
}

- (void)setSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    if (_isSelected)
        self.alpha = 0.5;
    else
        self.alpha = 1.0;
}

- (void)setHighlighted:(BOOL)isHighlighted
{
    _isHighlighted = isHighlighted;
}

- (void)setEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    
    if (_isEditing)
        self.backgroundColor = [UIColor yellowColor];
    else
        self.backgroundColor = [UIColor lightGrayColor];
}

- (NSMutableArray *)connectedNodes
{
    if (!connectedNodes)
        connectedNodes = [[NSMutableArray alloc] init];
    
    return connectedNodes;
}

- (NSMutableArray *)parentConnections
{
    if (!parentConnections)
        parentConnections = [[NSMutableArray alloc] init];
    
    return parentConnections;
}

- (NSMutableArray *)childConnections
{
    if (!childConnections)
        childConnections = [[NSMutableArray alloc] init];
    
    return childConnections;
}

- (CGRect)scaledSegmentRect
{
    return CGRectMake(self.segmentRect.origin.x * self.zoomScale, self.segmentRect.origin.y * self.zoomScale,
                      self.segmentRect.size.width * self.zoomScale, self.segmentRect.size.height * self.zoomScale);
}

- (void)setContentView:(UIView *)contentView
{
    if (contentView != _contentView) {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        
        CGSize size = CGSizeMake(_contentView.bounds.size.width, _contentView.bounds.size.height);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
        [self addSubview:_contentView];
    }
}

- (CGPoint)connectionHandleAncorPoint
{
    return CGPointMake(self.center.x, self.center.y + (self.frame.size.height / 2.0));
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    
    _touchOffset.width = center.x - location.x;
    _touchOffset.height = center.y - location.y;
    
    if ([self.delegate canProcessCanvasNodeView:self])
        if ([self.delegate respondsToSelector:@selector(canvasNodeView:touchesBegan:withEvent:)])
            [self.delegate canvasNodeView:self touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate canProcessCanvasNodeView:self])
        if ([self.delegate respondsToSelector:@selector(canvasNodeView:touchesMoved:withEvent:)])
            [self.delegate canvasNodeView:self touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate canProcessCanvasNodeView:self])
        if ([self.delegate respondsToSelector:@selector(canvasNodeView:touchesBegan:withEvent:)])
            [self.delegate canvasNodeView:self touchesEnded:touches withEvent:event];
    
    _touchOffset = CGSizeZero;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate canProcessCanvasNodeView:self])
        if ([self.delegate respondsToSelector:@selector(canvasNodeView:touchesBegan:withEvent:)])
            [self.delegate canvasNodeView:self touchesCancelled:touches withEvent:event];
    
    _touchOffset = CGSizeZero;
}

@end
