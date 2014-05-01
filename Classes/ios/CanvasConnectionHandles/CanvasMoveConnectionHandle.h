//
//  CanvasMoveConnectionHandle.h
//
//  Created by Julian Krumow on 14.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import "CanvasItemView.h"
#import "CanvasConnectionHandle.h"

@class CanvasNodeConnection;
@class CollectionCanvasView;

@protocol CanvasMoveConnectionHandleDelegate;

/**
 This class represents a handle to move a connection on the canvas.
 It is transparent and hovers above the tip of the connection pointing to the child view.
 */
@interface CanvasMoveConnectionHandle : CanvasConnectionHandle

@property (weak, nonatomic) CollectionCanvasView <CanvasMoveConnectionHandleDelegate> *delegate;
@property (weak, nonatomic) CanvasNodeConnection *connection;

@end

/**
 This protocol is used by the CanvasMoveConnectionHandle to communicate its state.
 */
@protocol CanvasMoveConnectionHandleDelegate <NSObject>

/**
 Return `YES` when the receiver is locked down to single touch processing.
 
 @param canvasMoveConnectionHandle The given CanvasMoveConnectionHandle
 @return `YES` when the receiver is locked down to single touch processing.
 */
- (BOOL)canProcessCanvasMoveConnectionHandle:(CanvasMoveConnectionHandle *)canvasMoveConnectionHandle;

/**
 A CanvasMoveConnectionHandle has been touched.
 
 @param canvasMoveConnectionHandle The given CanvasMoveConnectionHandle
 @param touches                    The touches
 @param event                      The event
 */
- (void)canvasMoveConnectionHandle:(CanvasMoveConnectionHandle *)canvasMoveConnectionHandle touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 A CanvasMoveConnectionHandle has been moved.
 
 @param canvasMoveConnectionHandle The given CanvasMoveConnectionHandle
 @param touches                    The touches
 @param event                      The event
 */
- (void)canvasMoveConnectionHandle:(CanvasMoveConnectionHandle *)canvasMoveConnectionHandle touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a CanvasMoveConnectionHandle has ended.
 
 @param canvasMoveConnectionHandle The given CanvasMoveConnectionHandle
 @param touches                    The touches
 @param event                      The event
 */
- (void)canvasMoveConnectionHandle:(CanvasMoveConnectionHandle *)canvasMoveConnectionHandle touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a CanvasMoveConnectionHandle has been cancelled.
 
 @param canvasMoveConnectionHandle The given CanvasMoveConnectionHandle
 @param touches                    The touches
 @param event                      The event
 */
- (void)canvasMoveConnectionHandle:(CanvasMoveConnectionHandle *)canvasMoveConnectionHandle touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end