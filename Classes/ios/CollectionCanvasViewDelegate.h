//
//  CollectionCanvasViewDelegate.h
//
//  Created by julian krumow on 21.08.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//

#import <Foundation/Foundation.h>

/**
 This is the delegate protocol for the CollectionCanvasView.
 
 */
@protocol CollectionCanvasViewDelegate <NSObject>

@optional

/**
 A node has been selected on the canvas view.
 
 @param indexPath The index path of the selected CanvasNodeView object.
 */
- (void)didSelectNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath;

/**
 A node has been moved on the canvas view.
 
 @param indexPath The index path of the moved CanvasNodeView object.
 @param nodeView  The CanvasNodeView object that has been moved.
 */
- (void)didMoveNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath nodeView:(CanvasItemView *)nodeView;

/**
 A bunch of nodes has been moved on the canvas view.
 
 @param indexPaths The index paths of the moved CanvasNodeView objects.
 @param nodeViews  An Array with CanvasNodeView objects that have been moved.
 */
- (void)didMoveSegmentOfNodesOnCanvasWithIndexPaths:(NSArray *)indexPaths nodeViews:(NSArray *)nodeViews;

/**
 A node has been collapsed on the canvas view.
 
 @param indexPath The index path of the collapsed CanvasNodeView object.
 @param nodeView  The CanvasNodeView object that has been collapsed.
 */
- (void)didCollapseNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath nodeView:(CanvasNodeView *)nodeView;

/**
 A bunch of nodes has been collapsed on the canvas view.
 
 @param indexPaths The index paths of the collapsed CanvasNodeView objects.
 @param nodeViews  An Array with CanvasNodeView objects that have been collapsed.
 */
- (void)didCollapseSegmentOfNodesOnCanvasWithIndexPaths:(NSArray *)indexPaths nodeViews:(NSArray *)nodeViews;

/**
 A node has been expanded on the canvas view.
 
 @param indexPath The index path of the expanded CanvasNodeView object.
 @param nodeView  The CanvasNodeView object that has been expanded.
 */
- (void)didExpandNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath nodeView:(CanvasNodeView *)nodeView;

/**
 A bunch of nodes has been expanded on the canvas view.
 
 @param indexPaths The index paths of the expanded CanvasNodeView objects.
 @param nodeViews  An Array with CanvasNodeView objects that have been expanded.
 */
- (void)didExpandSegmentOfNodesOnCanvasWithIndexPaths:(NSArray *)indexPaths nodeViews:(NSArray *)nodeViews;

/**
 A CanvasNodeView's connections have been collapsed on the canvas view.
 
 @param nodeView  The CanvasNodeView object that has been collapsed.
 @param indexPath The index path of the collapsed CanvasNodeView object.
 */
- (void)didCollapseConnectionsOnCanvasUnderNodeView:(CanvasNodeView *)nodeView atIndexPath:(NSIndexPath *)indexPath;

/**
 A CanvasNodeView's connections have been expanded on the canvas view.
 
 @param nodeView  The CanvasNodeView object that has been expanded.
 @param indexPath The index path of the expanded CanvasNodeView object.
 */
- (void)didExpandConnectionsOnCanvasUnderNodeView:(CanvasNodeView *)nodeView atIndexPath:(NSIndexPath *)indexPath;

/**
 A node has been deleted from the canvas view.
 
 @param indexPath The index path of the deleted CanvasNodeView object.
 */
- (void)didDeleteNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath;

/**
 A new connection has been established between two nodes on the canvas view.
 
 @param parentIndexPath The index path of the parent CanvasNodeView object.
 @param childIndexPath  The index path of the child CanvasNodeView object.
 */
- (void)didAddConnectionAtIndexPath:(NSIndexPath *)parentIndexPath andNodeAtIndexPath:(NSIndexPath *)childIndexPath;

/**
 A connection has been removed between two nodes on the canvas view.
 
 @param indexPath The index path of the parent CanvasNodeConnection object.
 */
- (void)didRemoveConnectionAtIndexPath:(NSIndexPath *)indexPath;

/**
 A connection has been moved between two child nodes on the canvas view.
 
 @param indexPath The index path of the parent CanvasNodeConnection object.
 @param newChildIndexPath The index path of the new child CanvasNodeView object.
 */
- (void)didMoveConnectionAtNode:(NSIndexPath *)indexPath toNewChildIndexPath:(NSIndexPath *)newChildIndexPath;

/**
 Attributes of a connection have been changed.
 
 @param indexPath  The index path of the CanvasNodeConnection object.
 @param connection The changed CanvasNodeConnection object.
 */
- (void)didChangeAttributesForConnectionAtIndexPath:(NSIndexPath *)indexPath connectionView:(CanvasNodeConnection *)connection;

@end