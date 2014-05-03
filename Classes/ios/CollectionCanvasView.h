//
//  CollectionCanvasView.h
//
//  Created by Julian Krumow on 23.01.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import <UIKit/UIKit.h>

#import "CanvasNodeView.h"
#import "CollectionCanvasViewDataSource.h"
#import "CollectionCanvasViewDelegate.h"
#import "CollectionCanvasController.h"

@class CollectionCanvasScrollView;

/**
 This class represents a canvas for node items in a collection.
 Items can be dragged, inserted, deleted etc.
 
 */
@interface CollectionCanvasView : UIView <CanvasNodeViewDelegate, CanvasNodeConnectionDelegate, CanvasNewConnectionHandleDelegate, CanvasMoveConnectionHandleDelegate> {
    
    CGFloat zoomScale;
}

@property (assign, nonatomic) id<CollectionCanvasViewDataSource> canvasViewDataSource;
@property (assign, nonatomic) id<CollectionCanvasViewDelegate> canvasViewDelegate;

@property (weak, nonatomic) CollectionCanvasScrollView *scrollView;
@property (strong, nonatomic) CollectionCanvasController *canvasController;

@property (assign, nonatomic, readonly, getter=isLockedToSingleTouch) BOOL lockedToSingleTouch;

/** @name Managing the CollectionCanvasView's content */

/**
 Fills the CollectionCanvasView with CanvasNodeView objects.
 */
- (void)fillCanvas;

/**
 Clears the canvas.
 Removes all CanvasNodeViews from view and from nodeViews array. 
 */
- (void)clearCanvas;

/**
 Reloads all items on the CollectionCanvasView.
 */
- (void)reloadCanvas;

/**
 Resizes the canvas view to an optimal size (optimal >= minimum size).
 */
- (void)sizeCanvasToFit;

/**
 Redraws all CanvasNodeViews and CanvasNodeConnections on the CollectionCanvasView in the actual zoomScale.
 
 @param scale The given zoom scale.
 */
- (void)zoomToScale:(CGFloat)scale;

/**
 Updates a single item on the CollectionCanvasView.
 
 @param indexPath The index path of the given CanvasNodeView object.
 */
- (void)updateNodeViewAtIndexPath:(NSIndexPath *)indexPath;

/**
 Inserts a node with a given index.
 
 @param indexPath The index path of the given CanvasNodeView object.
 */
- (void)insertNodeAtIndexPath:(NSIndexPath *)indexPath;

/**
 Deletes a node with a given index.
 
 @param indexPath The index path of the given CanvasNodeView object.
 */
- (void)deleteNodeAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns a CanvasNodeView with a given index.
 
 @param indexPath The index path of the given CanvasNodeView object.
 
 @return The specified CanvasNodeView object.
 */
- (CanvasNodeView *)nodeAtIndexPath:(NSIndexPath *)indexPath;


/** @name Controlling the CollectionCanvasView */

/**
 Toggles connection mode on and off.
 */
- (void)toggleConnectMode;

/**
 Returns `YES` when the CollectionCanvasView is currently processing subviews (tapping, dragging etc.).
 
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