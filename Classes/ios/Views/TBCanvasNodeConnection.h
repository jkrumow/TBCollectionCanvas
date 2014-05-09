//
//  TBCanvasNodeConnection
//
//  Created by Julian Krumow on 29.01.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//

#import <QuartzCore/QuartzCore.h>

#import "TBCanvasItemView.h"
#import "TBCanvasMoveConnectionHandle.h"

@protocol CanvasNodeConnectionDelegate;

@class TBCanvasNodeView;

/**
 This class represents a connection between two CanvasNodeViews on the canvas.
 
 */
@interface TBCanvasNodeConnection : TBCanvasItemView

@property (assign, nonatomic) id<CanvasNodeConnectionDelegate> canvasNodeConnectionDelegate;

@property (assign, nonatomic, readonly) NSUInteger parentIndex;
@property (assign, nonatomic, readonly) NSUInteger childIndex;

@property (weak, nonatomic) TBCanvasNodeView *parentNode;
@property (weak, nonatomic) TBCanvasNodeView *childNode;
@property (weak, nonatomic) TBCanvasMoveConnectionHandle *moveConnectionHandle;

@property (strong, nonatomic) UIColor *lineColor;
@property (assign, nonatomic, readonly) CGPoint visibleStartPoint;
@property (assign, nonatomic, readonly) CGPoint visibleEndPoint;

/**
 Returns `YES` if the connection is a valid connection inside CollectionCanvasView's viewhierarchy.
 `NO` if the connection is about to be removed from the viewhierarchy.
 */
@property (assign, nonatomic, readonly, getter = isValid) BOOL valid;

/**
 Initializes the TBCanvasNodeConnection object with a given CGRect and the value of parentIndex and childIndex.
 
 @param frame The frame of the TBCanvasNodeConnection view
 @return The initialized TBCanvasNodeConnection object
 */
- (id)initWithFrame:(CGRect)frame;

/**
 Destroys all views and connections and wipes the canvas.
 */
- (void)reset;

/**
 Draws a connection from one node to another.
 
 @param start The starting point of the connection
 @param end   The ending point of the connection
 */
- (void)drawConnectionFromPoint:(CGPoint)start toPoint:(CGPoint)end;

/**
  Draws a connection between parent and child node view.
 
 */
- (void)drawConnection;

/**
 Checks if a touch on the connection is valid.
 
 @param touch The touch location
 
 @return true if the touch is valid.
 */
- (BOOL)checkTouchIsValid:(CGPoint)touch;

/**
 Makes the connection snap back to the parent node view like a suspender strap.
 */
- (void)suspenderSnapAnimation;

/**
 Returns the indexPath of the TBCanvasNodeConnection object.
 
 @return The NSIndexPath object
 */
- (NSIndexPath *)indexPath;

/**
 Sets the center point of the CanvasNodeItem.
 Set animated to YES to slide item into place and redraw connection afterwards.
 
 @param center   The given CGPoint for the new center point
 @param animated Set to YES to animate re-positioning and redraw.
 */
- (void)setCenter:(CGPoint)center animated:(BOOL)animated;

@end

/**
 This protocol is used to notifiy the receiver about the state of a TBCanvasNodeConnection.
 
 */
@protocol CanvasNodeConnectionDelegate <NSObject>

/**
 Notifies the receiver that the suspenderSnapAnimation has completed.
 
 @param connection The animated TBCanvasNodeConnection
 @param indexPath  The index path of the given TBCanvasNodeConnection
 */
- (void)removedConnection:(TBCanvasNodeConnection *)connection atIndexPath:(NSIndexPath *)indexPath;

@end
