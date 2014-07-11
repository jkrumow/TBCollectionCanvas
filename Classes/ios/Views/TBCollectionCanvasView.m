//
//  TBCollectionCanvasView.m
//
//  Created by Julian Krumow on 01.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import "TBCollectionCanvasView.h"

CGFloat const kTBCollectionCanvasContentViewWidth  = 1000.0;
CGFloat const kTBCollectionCanvasContentViewHeight = 1000.0;

@implementation TBCollectionCanvasView

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
        
        TBCollectionCanvasContentView *collectionCanvasView = [[TBCollectionCanvasContentView alloc] initWithFrame:CGRectMake(0.0, 0.0, kTBCollectionCanvasContentViewWidth, kTBCollectionCanvasContentViewHeight)];
        self.collectionCanvasView = collectionCanvasView;
        self.collectionCanvasView.scrollView = self;
        
        [self addSubview:collectionCanvasView];
    }
    return self;
}

/**
 Forwards the zoomScale to the TBCollectionCanvasContentView.
 
 @param scale The zoom scale.
 */
- (void)setZoomScale:(CGFloat)scale
{
    [super setZoomScale:scale];
    [self.collectionCanvasView zoomToScale:scale];
}

/**
 Triggers resizing of the TBCollectionCanvasContentView.
 
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
    if ([self.collectionCanvasView isProcessingViews]) {
        return YES;
    }
    
    return ([view isKindOfClass:[TBCollectionCanvasContentView class]] == NO && [view isKindOfClass:[TBCanvasConnectionView class]] == NO);
}

/*
 All touch events in a subview will not be cancelled while a  TBCanvasItemView is being touched, moved etc.
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
