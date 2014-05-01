//
//  CollectionCanvasScrollView.h
//
//  Created by Julian Krumow on 01.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import <UIKit/UIKit.h>

#import "CollectionCanvasView.h"

extern CGFloat const CONTENT_WIDTH;
extern CGFloat const CONTENT_HEIGHT;

/**
 This is the CollectionCanvasScrollView. It is the master view in with the CollectionCanvasView will be displayed as a subview - to make the whole canvas zoomable.
 
 Touch events in a subview will not be intercepted by the CollectionCanvasScrollView unless they appeared on
 the CollectionCanvasView itself. So dragging a CanvasNodeView as well as zooming and scrolling the CollectionCanvasScrollView will preserved.
 
 All touch events in a subview will not be cancelled while a CanvasItemView is being touched, moved etc.
 */
@interface CollectionCanvasScrollView : UIScrollView <UIScrollViewDelegate>

@property (strong, nonatomic) CollectionCanvasView *collectionCanvasView;

@end