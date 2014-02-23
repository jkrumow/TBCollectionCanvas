//
//  CollectionCanvasScrollView.m
//
//  Created by Julian Krumow on 01.02.12.
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


#import "CollectionCanvasScrollView.h"

CGFloat const CONTENT_WIDTH  = 1000.0;
CGFloat const CONTENT_HEIGHT = 1000.0;

@implementation CollectionCanvasScrollView

@synthesize collectionCanvasView = _collectionCanvasView;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.delaysContentTouches = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.scrollEnabled = YES;
        self.zoomScale = 0.5;
        
        self.backgroundColor = [UIColor darkGrayColor];
        
        CollectionCanvasView *collectionCanvasView = [[CollectionCanvasView alloc] initWithFrame:CGRectMake(0.0, 0.0, CONTENT_WIDTH, CONTENT_HEIGHT)];
        self.collectionCanvasView = collectionCanvasView;
        self.collectionCanvasView.scrollView = self;
        
        [self addSubview:collectionCanvasView];
    }
    return self;
}

/**
 Forwards the zoomScale to the CollectionCanvasView.
 
 @param scale The zoom scale.
 */
- (void)setZoomScale:(CGFloat)scale
{
    [super setZoomScale:scale];
    [self.collectionCanvasView zoomToScale:scale];
}

/**
 Triggers resizing of the CollectionCanvasView.
 
 @param frame The frame rect to set.
 */
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.collectionCanvasView sizeCanvasToFit];
}

/*
 Touch events in a subview will not be cancelled.
 */
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    if ([self.collectionCanvasView isProcessingViews])
        return YES;
    
    return ([view isKindOfClass:[CollectionCanvasView class]] == NO && [view isKindOfClass:[CanvasNodeConnection class]] == NO);
}

/*
 All touch events in a subview will not be cancelled while a CanvasItemView is being touched, moved etc.
 */
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return ([self.collectionCanvasView isProcessingViews] == NO);
}

@end
