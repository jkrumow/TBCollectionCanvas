//
//  TBCollectionCanvasView.h
//
//  Created by Julian Krumow on 01.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import <UIKit/UIKit.h>

#import "TBCollectionCanvasContentView.h"

extern CGFloat const CONTENT_WIDTH;
extern CGFloat const CONTENT_HEIGHT;

/**
 This is the TBCollectionCanvasView. It is the master view in with the TBCollectionCanvasContentView will be displayed as a subview - to make the whole canvas zoomable.
 
 Touch events in a subview will not be intercepted by the TBCollectionCanvasView unless they appeared on
 the TBCollectionCanvasContentView itself. So dragging a TBCanvasNodeView as well as zooming and scrolling the TBCollectionCanvasView will preserved.
 
 All touch events in a subview will not be cancelled while a  TBCanvasItemView is being touched, moved etc.
 */
@interface TBCollectionCanvasView : UIScrollView <UIScrollViewDelegate>


/**
 *  The canvas which displays all collection items.
 */
@property (strong, nonatomic) TBCollectionCanvasContentView *collectionCanvasView;

@end