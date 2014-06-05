//
//  TBCanvasMoveHandleView.h
//
//  Created by Julian Krumow on 14.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import "TBCanvasItemView.h"

@class TBCanvasConnectionView;
@class TBCollectionCanvasContentView;

@protocol TBCanvasMoveHandleViewDelegate;

/**
 This class represents a handle to move a connection on the canvas.
 It is transparent and hovers above the tip of the connection pointing to the child view.
 */
@interface TBCanvasMoveHandleView : TBCanvasItemView

/**
 *  The handle's delegate. Receives messages about touch events of the view.
 */
@property (weak, nonatomic) TBCollectionCanvasContentView <TBCanvasMoveHandleViewDelegate> *delegate;

/**
 *  The hosting TBCanvasConnectionView.
 */
@property (weak, nonatomic) TBCanvasConnectionView *connection;

@end

/**
 This protocol is used by the  TBCanvasMoveHandle to communicate its state.
 */
@protocol TBCanvasMoveHandleViewDelegate <NSObject>

/**
 Return `YES` when the receiver is locked down to single touch processing.
 
 @param canvasMoveHandle The given TBCanvasMoveHandleView
 @return `YES` when the receiver is locked down to single touch processing.
 */
- (BOOL)canProcessCanvasMoveHandle:(TBCanvasMoveHandleView *)canvasMoveHandle;

/**
 A  TBCanvasMoveHandle has been touched.
 
 @param canvasMoveHandle The given TBCanvasMoveHandleView
 @param touches                    The touches
 @param event                      The event
 */
- (void)canvasMoveHandle:(TBCanvasMoveHandleView *)canvasMoveHandle touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 A  TBCanvasMoveHandle has been moved.
 
 @param canvasMoveHandle The given TBCanvasMoveHandleView
 @param touches                    The touches
 @param event                      The event
 */
- (void)canvasMoveHandle:(TBCanvasMoveHandleView *)canvasMoveHandle touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a  TBCanvasMoveHandle has ended.
 
 @param canvasMoveHandle The given TBCanvasMoveHandleView
 @param touches                    The touches
 @param event                      The event
 */
- (void)canvasMoveHandle:(TBCanvasMoveHandleView *)canvasMoveHandle touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a  TBCanvasMoveHandle has been cancelled.
 
 @param canvasMoveHandle The given TBCanvasMoveHandleView
 @param touches                    The touches
 @param event                      The event
 */
- (void)canvasMoveHandle:(TBCanvasMoveHandleView *)canvasMoveHandle touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end