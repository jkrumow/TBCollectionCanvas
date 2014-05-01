//
//  CollectionCanvasScrollView.m
//
//  Created by Julian Krumow on 01.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
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
        
        self.delegate = self;
        
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

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.collectionCanvasView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self.collectionCanvasView zoomToScale:scale];
}

@end
