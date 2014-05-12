//
//  TBCollectionCanvasScrollView.h
//
//  Created by Julian Krumow on 01.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import <UIKit/UIKit.h>

#import "TBCollectionCanvasView.h"

extern CGFloat const CONTENT_WIDTH;
extern CGFloat const CONTENT_HEIGHT;

/**
 This is the TBCollectionCanvasScrollView. It is the master view in with the TBCollectionCanvasView will be displayed as a subview - to make the whole canvas zoomable.
 
 Touch events in a subview will not be intercepted by the TBCollectionCanvasScrollView unless they appeared on
 the TBCollectionCanvasView itself. So dragging a TBCanvasNodeView as well as zooming and scrolling the TBCollectionCanvasScrollView will preserved.
 
 All touch events in a subview will not be cancelled while a CanvasItemView is being touched, moved etc.
 */
@interface TBCollectionCanvasScrollView : UIScrollView <UIScrollViewDelegate>

@property (strong, nonatomic) TBCollectionCanvasView *collectionCanvasView;

@end