//
//  TBCollectionCanvasContentViewDataSource.h
//
//  Created by julian krumow on 21.08.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//

#import <Foundation/Foundation.h>

/**
 This is the data source protocol for the TBCollectionCanvasContentView.
 
 */
@protocol TBCollectionCanvasContentViewDataSource <NSObject>

/**
 Returns the number of sections on the canvas.
 
 @return The number of sections.
 */
- (NSInteger)numberOfSectionsOnCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView;

/**
 Returns the number of Node objects of a given section on the canvas.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance requesting the data
 @param section The given section number
 
 @return The number of TBCanvasNodeView objects
 */
- (NSInteger)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView numberOfNodesInSection:(NSInteger)section;

/**
 Returns the TBCanvasNodeView object with a given index path from the canvas.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance requesting the data
 @param indexPath The given index path
 
 @return The TBCanvasNodeView object with the corresponding index. Otherwise nil.
 */
- (TBCanvasNodeView *)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView nodeViewAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns a new Connection object for a given Node object.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance requesting the data
 @param indexPath The index path of the given collection.
 
 @return The TBCanvasConnectionView object. Otherwise nil.
 */

- (TBCanvasConnectionView *)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView newConectionForNodeAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns a set of Connection objects for a given Node object.
 
 Iterates through the set and connects the corresponding TBCanvasNodeView objects with TBCanvasConnectionViews.
 
 @param collectionCanvasContentView The TBCollectionCanvasContentView instance requesting the data
 @param indexPath The index path of the given collection.
 
 @return The NSArray object with all TBCanvasConnectionView objects. Otherwise nil.
 */
- (NSSet *)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView connectionsForNodeAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Returns a new connection handle at a specified point
 *
 * @param collectionCanvasContentView The TBCollectionCanvasContentView instance requesting the data
 *  @param point The center point of the new connection handle
 *
 *  @return The TBCanvasCreateHandleView object
 */
- (TBCanvasCreateHandleView *)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView newHandleForConnectionAtPoint:(CGPoint)point;

/**
 *  Returns a move connection handle at a specified point
 *
 *  @param collectionCanvasContentView The TBCollectionCanvasContentView instance requesting the data
 *  @param point The center point of the move connection handle
 *
 *  @return The TBCanvasMoveHandleView object
 */
- (TBCanvasMoveHandleView *)collectionCanvasContentView:(TBCollectionCanvasContentView *)collectionCanvasContentView moveHandleForConnectionAtPoint:(CGPoint)point;

@end
