//
//  TBCollectionCanvasContentView.h
//
//  Created by Julian Krumow on 23.01.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import <UIKit/UIKit.h>

#import "TBCanvasNodeView.h"
#import "TBCollectionCanvasContentViewDataSource.h"
#import "TBCollectionCanvasContentViewDelegate.h"

@class TBCollectionCanvasView;

/**
 This class represents a canvas for node items in a collection.
 Items can be dragged, inserted, deleted etc.
 
 */
@interface TBCollectionCanvasContentView : UIView <TBCanvasNodeViewDelegate, TBCanvasConnectionViewDelegate, TBCanvasCreateHandleViewDelegate, TBCanvasMoveHandleViewDelegate> {
    
    CGFloat zoomScale;
}

/**
 *  The views's datasource.
 */
@property (assign, nonatomic) id<TBCollectionCanvasContentViewDataSource> canvasViewDataSource;

/**
 *  The views's delegate.
 */
@property (assign, nonatomic) id<TBCollectionCanvasContentViewDelegate> canvasViewDelegate;

/**
 *  The view's hosting UIScrollView.
 */
@property (weak, nonatomic) TBCollectionCanvasView *scrollView;

/**
 *  Set to `YES` if the context menu is enabled.
 */
@property (assign, nonatomic, getter = isMenuEnabled) BOOL menuEnabled;

/**
 *  Set to `YES` if the view is currently handling single touches.
 */
@property (assign, nonatomic, readonly, getter=isLockedToSingleTouch) BOOL lockedToSingleTouch;

/** @name Managing the TBCollectionCanvasContentView's content */

/**
 Fills the TBCollectionCanvasContentView with TBCanvasNodeView objects.
 */
- (void)fillCanvas;

/**
 Clears the canvas.
 Removes all TBCanvasNodeViews from view and from nodeViews array.
 */
- (void)clearCanvas;

/**
 Reloads all items on the TBCollectionCanvasContentView.
 */
- (void)reloadCanvas;

/**
 Resizes the canvas view to an optimal size (optimal >= minimum size).
 */
- (void)sizeCanvasToFit;

/**
 Redraws all TBCanvasNodeViews and TBCanvasConnectionViews on the TBCollectionCanvasContentView in the actual zoomScale.
 
 @param scale The given zoom scale.
 */
- (void)zoomToScale:(CGFloat)scale;

/**
 Updates a single item on the TBCollectionCanvasContentView.
 
 @param indexPath The index path of the given TBCanvasNodeView object.
 */
- (void)updateNodeViewAtIndexPath:(NSIndexPath *)indexPath;

/**
 Inserts a node with a given index.
 
 @param indexPath The index path of the given TBCanvasNodeView object.
 */
- (void)insertNodeAtIndexPath:(NSIndexPath *)indexPath;

/**
 Deletes a node with a given index.
 
 @param indexPath The index path of the given TBCanvasNodeView object.
 */
- (void)deleteNodeAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns a TBCanvasNodeView with a given index.
 
 @param indexPath The index path of the given TBCanvasNodeView object.
 
 @return The specified TBCanvasNodeView object.
 */
- (TBCanvasNodeView *)nodeAtIndexPath:(NSIndexPath *)indexPath;


/** @name Controlling the TBCollectionCanvasContentView */

/**
 Toggles connection mode on and off.
 */
- (void)toggleConnectMode;

/**
 Returns `YES` when the TBCollectionCanvasContentView is currently processing subviews (tapping, dragging etc.).
 
 @return `YES` when subview are processed.
 */
- (BOOL)isProcessingViews;

/**
 Returns `YES`when the view is locked to processing of only one view.
 
 @return `YES`when the view is locked to processing of only one view.
 */
- (BOOL)isInSingleTouchMode;

/**
 Hides the menu to delete, collapse / expand the selected item.
 */
- (void)hideMenu;

@end