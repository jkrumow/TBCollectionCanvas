//
//  TBCollectionCanvasContentViewDelegate.h
//
//  Created by julian krumow on 21.08.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//

#import <Foundation/Foundation.h>

/**
 This is the delegate protocol for the TBCollectionCanvasContentView.
 
 */
@protocol TBCollectionCanvasContentViewDelegate <NSObject>

@optional

/**
 A node has been selected on the canvas view.
 
 @param indexPath The index path of the selected TBCanvasNodeView object.
 */
- (void)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView didSelectNodeAtIndexPath:(NSIndexPath *)indexPath;

/**
 A node has been moved on the canvas view.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance calling this method
 @param indexPath The index path of the moved TBCanvasNodeView object.
 @param nodeView  The TBCanvasNodeView object that has been moved.
 */
- (void)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView didMoveNodeAtIndexPath:(NSIndexPath *)indexPath nodeView:(TBCanvasItemView *)nodeView;

/**
 A bunch of nodes has been moved on the canvas view.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance calling this method
 @param indexPaths The index paths of the moved TBCanvasNodeView objects.
 @param nodeViews  An Array with TBCanvasNodeView objects that have been moved.
 */
- (void)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView didMoveSegmentOfNodesAtIndexPaths:(NSArray *)indexPaths nodeViews:(NSArray *)nodeViews;

/**
 A node has been collapsed on the canvas view.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance calling this method
 @param indexPath The index path of the collapsed TBCanvasNodeView object.
 @param nodeView  The TBCanvasNodeView object that has been collapsed.
 */
- (void)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView didCollapseNodeAtIndexPath:(NSIndexPath *)indexPath nodeView:(TBCanvasNodeView *)nodeView;

/**
 A bunch of nodes has been collapsed on the canvas view.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance calling this method
 @param indexPaths The index paths of the collapsed TBCanvasNodeView objects.
 @param nodeViews  An Array with TBCanvasNodeView objects that have been collapsed.
 */
- (void)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView didCollapseSegmentOfNodesAtIndexPaths:(NSArray *)indexPaths nodeViews:(NSArray *)nodeViews;

/**
 A node has been expanded on the canvas view.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance calling this method
 @param indexPath The index path of the expanded TBCanvasNodeView object.
 @param nodeView  The TBCanvasNodeView object that has been expanded.
 */
- (void)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView didExpandNodeAtIndexPath:(NSIndexPath *)indexPath nodeView:(TBCanvasNodeView *)nodeView;

/**
 A bunch of nodes has been expanded on the canvas view.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance calling this method
 @param indexPaths The index paths of the expanded TBCanvasNodeView objects.
 @param nodeViews  An Array with TBCanvasNodeView objects that have been expanded.
 */
- (void)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView didExpandSegmentOfNodesAtIndexPaths:(NSArray *)indexPaths nodeViews:(NSArray *)nodeViews;

/**
 A  TBCanvasNodeView's connections have been collapsed on the canvas view.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance calling this method
 @param nodeView  The TBCanvasNodeView object that has been collapsed.
 @param indexPath The index path of the collapsed TBCanvasNodeView object.
 */
- (void)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView didCollapseConnectionsBelowNodeView:(TBCanvasNodeView *)nodeView atIndexPath:(NSIndexPath *)indexPath;

/**
 A  TBCanvasNodeView's connections have been expanded on the canvas view.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance calling this method
 @param nodeView  The TBCanvasNodeView object that has been expanded.
 @param indexPath The index path of the expanded TBCanvasNodeView object.
 */
- (void)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView didExpandConnectionsBelowNodeView:(TBCanvasNodeView *)nodeView atIndexPath:(NSIndexPath *)indexPath;

/**
 A node has been deleted from the canvas view.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance calling this method
 @param indexPath The index path of the deleted TBCanvasNodeView object.
 */
- (void)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView didDeleteNodeAtIndexPath:(NSIndexPath *)indexPath;

/**
 A new connection has been established between two nodes on the canvas view.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance calling this method
 @param parentIndexPath The index path of the parent TBCanvasNodeView object.
 @param childIndexPath  The index path of the child TBCanvasNodeView object.
 */
- (void)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView didAddConnectionBetweenParentAtIndexPath:(NSIndexPath *)parentIndexPath childAtIndexPath:(NSIndexPath *)childIndexPath;

/**
 A connection has been removed between two nodes on the canvas view.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance calling this method
 @param indexPath The index path of the parent TBCanvasConnectionView object.
 */
- (void)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView didRemoveConnectionAtIndexPath:(NSIndexPath *)indexPath;

/**
 A connection has been moved between two child nodes on the canvas view.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance calling this method
 @param indexPath The index path of the parent TBCanvasConnectionView object.
 @param newChildIndexPath The index path of the new child TBCanvasNodeView object.
 */
- (void)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView didMoveConnectionAtNode:(NSIndexPath *)indexPath toNewChildIndexPath:(NSIndexPath *)newChildIndexPath;

/**
 Attributes of a connection have been changed.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance calling this method
 @param indexPath  The index path of the TBCanvasConnectionView object.
 */
- (void)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView didChangeAttributesForConnectionViewAtIndexPath:(NSIndexPath *)indexPath;

@end