//
//  TBCollectionCanvasViewDelegate.h
//
//  Created by julian krumow on 21.08.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//

#import <Foundation/Foundation.h>

/**
 This is the delegate protocol for the TBCollectionCanvasView.
 
 */
@protocol TBCollectionCanvasViewDelegate <NSObject>

@optional

/**
 A node has been selected on the canvas view.
 
 @param indexPath The index path of the selected TBCanvasNodeView object.
 */
- (void)didSelectNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath;

/**
 A node has been moved on the canvas view.
 
 @param indexPath The index path of the moved TBCanvasNodeView object.
 @param nodeView  The TBCanvasNodeView object that has been moved.
 */
- (void)didMoveNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath nodeView:(TBCanvasItemView *)nodeView;

/**
 A bunch of nodes has been moved on the canvas view.
 
 @param indexPaths The index paths of the moved TBCanvasNodeView objects.
 @param nodeViews  An Array with TBCanvasNodeView objects that have been moved.
 */
- (void)didMoveSegmentOfNodesOnCanvasWithIndexPaths:(NSArray *)indexPaths nodeViews:(NSArray *)nodeViews;

/**
 A node has been collapsed on the canvas view.
 
 @param indexPath The index path of the collapsed TBCanvasNodeView object.
 @param nodeView  The TBCanvasNodeView object that has been collapsed.
 */
- (void)didCollapseNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath nodeView:(TBCanvasNodeView *)nodeView;

/**
 A bunch of nodes has been collapsed on the canvas view.
 
 @param indexPaths The index paths of the collapsed TBCanvasNodeView objects.
 @param nodeViews  An Array with TBCanvasNodeView objects that have been collapsed.
 */
- (void)didCollapseSegmentOfNodesOnCanvasWithIndexPaths:(NSArray *)indexPaths nodeViews:(NSArray *)nodeViews;

/**
 A node has been expanded on the canvas view.
 
 @param indexPath The index path of the expanded TBCanvasNodeView object.
 @param nodeView  The TBCanvasNodeView object that has been expanded.
 */
- (void)didExpandNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath nodeView:(TBCanvasNodeView *)nodeView;

/**
 A bunch of nodes has been expanded on the canvas view.
 
 @param indexPaths The index paths of the expanded TBCanvasNodeView objects.
 @param nodeViews  An Array with TBCanvasNodeView objects that have been expanded.
 */
- (void)didExpandSegmentOfNodesOnCanvasWithIndexPaths:(NSArray *)indexPaths nodeViews:(NSArray *)nodeViews;

/**
 A CanvasNodeView's connections have been collapsed on the canvas view.
 
 @param nodeView  The TBCanvasNodeView object that has been collapsed.
 @param indexPath The index path of the collapsed TBCanvasNodeView object.
 */
- (void)didCollapseConnectionsOnCanvasUnderNodeView:(TBCanvasNodeView *)nodeView atIndexPath:(NSIndexPath *)indexPath;

/**
 A CanvasNodeView's connections have been expanded on the canvas view.
 
 @param nodeView  The TBCanvasNodeView object that has been expanded.
 @param indexPath The index path of the expanded TBCanvasNodeView object.
 */
- (void)didExpandConnectionsOnCanvasUnderNodeView:(TBCanvasNodeView *)nodeView atIndexPath:(NSIndexPath *)indexPath;

/**
 A node has been deleted from the canvas view.
 
 @param indexPath The index path of the deleted TBCanvasNodeView object.
 */
- (void)didDeleteNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath;

/**
 A new connection has been established between two nodes on the canvas view.
 
 @param parentIndexPath The index path of the parent TBCanvasNodeView object.
 @param childIndexPath  The index path of the child TBCanvasNodeView object.
 */
- (void)didAddConnectionAtIndexPath:(NSIndexPath *)parentIndexPath andNodeAtIndexPath:(NSIndexPath *)childIndexPath;

/**
 A connection has been removed between two nodes on the canvas view.
 
 @param indexPath The index path of the parent TBCanvasConnectionView object.
 */
- (void)didRemoveConnectionAtIndexPath:(NSIndexPath *)indexPath;

/**
 A connection has been moved between two child nodes on the canvas view.
 
 @param indexPath The index path of the parent TBCanvasConnectionView object.
 @param newChildIndexPath The index path of the new child TBCanvasNodeView object.
 */
- (void)didMoveConnectionAtNode:(NSIndexPath *)indexPath toNewChildIndexPath:(NSIndexPath *)newChildIndexPath;

/**
 Attributes of a connection have been changed.
 
 @param indexPath  The index path of the TBCanvasConnectionView object.
 @param connection The changed TBCanvasConnectionView object.
 */
- (void)didChangeAttributesForConnectionAtIndexPath:(NSIndexPath *)indexPath connectionView:(TBCanvasConnectionView *)connection;

@end