//
//  CollectionCanvasView.h
//
//  Created by Julian Krumow on 23.01.12.
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


#import <UIKit/UIKit.h>

#import "CanvasNodeView.h"
#import "CollectionCanvasViewDataSource.h"
#import "CollectionCanvasViewDelegate.h"

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

/**
 Updates the thumbImage of a CanvasNodeView at a given index path.
 
 @param image The updated thumb image.
 @param indexPath The index path of the given CanvasNodeView object.
 */
- (void)updateThumbImage:(UIImage *)image forNodeViewAtIndexPath:(NSIndexPath *)indexPath;

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