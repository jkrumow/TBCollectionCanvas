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

@protocol CanvasNewConnectionHandleDelegate;

/**
 This class represents a handle to draw connection between items on the canvas.
 */
@interface TBCanvasCreateHandleView : TBCanvasItemView

@property (weak, nonatomic) TBCollectionCanvasContentView <CanvasNewConnectionHandleDelegate> *delegate;
@property (weak, nonatomic) TBCanvasNodeView *nodeView;

@end

/**
 This protocol is used by the TBCanvasCreateHandleView to communicate its state.
 */
@protocol CanvasNewConnectionHandleDelegate <NSObject>

/**
 Return `YES` when the receiver is locked down to single touch processing.
 
 @param canvasNewConnectionHandle The given TBCanvasCreateHandleView
 @return `YES` when the receiver is locked down to single touch processing.
 */
- (BOOL)canProcessCanvasNewConnectionHandle:(TBCanvasCreateHandleView *)canvasNewConnectionHandle;

/**
 A TBCanvasCreateHandleView has been touched.
 
 @param canvasNewConnectionHandle The given TBCanvasCreateHandleView
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasNewConnectionHandle:(TBCanvasCreateHandleView *)canvasNewConnectionHandle touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 A TBCanvasCreateHandleView has been moved.
 
 @param canvasNewConnectionHandle The given TBCanvasCreateHandleView
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasNewConnectionHandle:(TBCanvasCreateHandleView *)canvasNewConnectionHandle touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a TBCanvasCreateHandleView has ended.
 
 @param canvasNewConnectionHandle The given TBCanvasCreateHandleView
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasNewConnectionHandle:(TBCanvasCreateHandleView *)canvasNewConnectionHandle touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a TBCanvasCreateHandleView has been cancelled.
 
 @param canvasNewConnectionHandle The given TBCanvasCreateHandleView
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasNewConnectionHandle:(TBCanvasCreateHandleView *)canvasNewConnectionHandle touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end