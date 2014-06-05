//
//  TBCanvasCreateHandleView.h
//
//  Created by Julian Krumow on 11.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import "TBCanvasItemView.h"

@class TBCanvasNodeView;
@class TBCollectionCanvasContentView;

@protocol TBCanvasCreateHandleViewDelegate;

/**
 This class represents a handle to draw connection between items on the canvas.
 */
@interface TBCanvasCreateHandleView : TBCanvasItemView

/**
 *  The handle's delegate. Receives messages about touch events of the view.
 */
@property (weak, nonatomic) TBCollectionCanvasContentView <TBCanvasCreateHandleViewDelegate> *delegate;

/**
 *  The hosting TBCanvasNodeView.
 */
@property (weak, nonatomic) TBCanvasNodeView *nodeView;

@end

/**
 This protocol is used by the TBCanvasCreateHandleView to communicate its state.
 */
@protocol TBCanvasCreateHandleViewDelegate <NSObject>

/**
 Return `YES` when the receiver is locked down to single touch processing.
 
 @param canvasCreateHandle The given TBCanvasCreateHandleView
 @return `YES` when the receiver is locked down to single touch processing.
 */
- (BOOL)canProcessCanvasCreateHandle:(TBCanvasCreateHandleView *)canvasCreateHandle;

/**
 A TBCanvasCreateHandleView has been touched.
 
 @param canvasCreateHandle The given TBCanvasCreateHandleView
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasCreateHandle:(TBCanvasCreateHandleView *)canvasCreateHandle touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 A TBCanvasCreateHandleView has been moved.
 
 @param canvasCreateHandle The given TBCanvasCreateHandleView
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasCreateHandle:(TBCanvasCreateHandleView *)canvasCreateHandle touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a TBCanvasCreateHandleView has ended.
 
 @param canvasCreateHandle The given TBCanvasCreateHandleView
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasCreateHandle:(TBCanvasCreateHandleView *)canvasCreateHandle touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a TBCanvasCreateHandleView has been cancelled.
 
 @param canvasCreateHandle The given TBCanvasCreateHandleView
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasCreateHandle:(TBCanvasCreateHandleView *)canvasCreateHandle touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end