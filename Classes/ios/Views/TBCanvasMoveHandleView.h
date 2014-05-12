//
//  CanvasMoveConnectionHandle.h
//
//  Created by Julian Krumow on 14.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import "TBCanvasItemView.h"

@class TBCanvasConnectionView;
@class TBCollectionCanvasContentView;

@protocol CanvasMoveConnectionHandleDelegate;

/**
 This class represents a handle to move a connection on the canvas.
 It is transparent and hovers above the tip of the connection pointing to the child view.
 */
@interface TBCanvasMoveHandleView : TBCanvasItemView

@property (weak, nonatomic) TBCollectionCanvasContentView <CanvasMoveConnectionHandleDelegate> *delegate;
@property (weak, nonatomic) TBCanvasConnectionView *connection;

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
- (BOOL)canProcessCanvasMoveConnectionHandle:(TBCanvasMoveHandleView *)canvasMoveConnectionHandle;

/**
 A CanvasMoveConnectionHandle has been touched.
 
 @param canvasMoveConnectionHandle The given CanvasMoveConnectionHandle
 @param touches                    The touches
 @param event                      The event
 */
- (void)canvasMoveConnectionHandle:(TBCanvasMoveHandleView *)canvasMoveConnectionHandle touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 A CanvasMoveConnectionHandle has been moved.
 
 @param canvasMoveConnectionHandle The given CanvasMoveConnectionHandle
 @param touches                    The touches
 @param event                      The event
 */
- (void)canvasMoveConnectionHandle:(TBCanvasMoveHandleView *)canvasMoveConnectionHandle touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a CanvasMoveConnectionHandle has ended.
 
 @param canvasMoveConnectionHandle The given CanvasMoveConnectionHandle
 @param touches                    The touches
 @param event                      The event
 */
- (void)canvasMoveConnectionHandle:(TBCanvasMoveHandleView *)canvasMoveConnectionHandle touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a CanvasMoveConnectionHandle has been cancelled.
 
 @param canvasMoveConnectionHandle The given CanvasMoveConnectionHandle
 @param touches                    The touches
 @param event                      The event
 */
- (void)canvasMoveConnectionHandle:(TBCanvasMoveHandleView *)canvasMoveConnectionHandle touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end