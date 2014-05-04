//
//  TBCollectionCanvasViewDataSource.h
//
//  Created by julian krumow on 21.08.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//

#import <Foundation/Foundation.h>

/**
 This is the data source protocol for the TBCollectionCanvasView.
 
 */
@protocol TBCollectionCanvasViewDataSource <NSObject>

/**
 Returns the number of sections on the canvas.
 
 @return The number of sections.
 */
- (NSInteger)numberOfSectionsOnCanvas;

/**
 Returns the number of Node objects of a given section on the canvas.
 
 @param section The given section number
 
 @return The number of TBCanvasNodeView objects
 */
- (NSInteger)numberOfNodesInSection:(NSInteger)section;

/**
 Returns the TBCanvasNodeView object with a given index path from the canvas.
 
 @param indexPath The given index path
 
 @return The TBCanvasNodeView object with the corresponding index. Otherwise nil.
 */
- (TBCanvasNodeView *)nodeViewOnCanvasAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns a new Connection object for a given Node object.
 
 @param indexPath The index path of the given collection.
 
 @return The TBCanvasNodeConnection object. Otherwise nil.
 */

- (TBCanvasNodeConnection *)newConectionForNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns a set of Connection objects for a given Node object.
 
 Iterates through the set and connects the corresponding TBCanvasNodeView objects with CanvasNodeConnections.
 
 @param indexPath The index path of the given collection.
 
 @return The NSArray object with all TBCanvasNodeConnection objects. Otherwise nil.
 */
- (NSSet *)connectionsForNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Returns a new connection handle at a specified point
 *
 *  @param point The center point of the new connection handle
 *
 *  @return The TBCanvasNewConnectionHandle object
 */
- (TBCanvasNewConnectionHandle *)newHandleForConnectionAtPoint:(CGPoint)point;

/**
 *  Returns a move connection handle at a specified point
 *
 *  @param point The center point of the move connection handle
 *
 *  @return The TBCanvasMoveConnectionHandle object
 */
- (TBCanvasMoveConnectionHandle *)moveHandleForConnectionAtPoint:(CGPoint)point;

@end
