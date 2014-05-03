//
//  TBCanvasNewConnectionHandle.h
//
//  Created by Julian Krumow on 11.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import "TBCanvasItemView.h"
#import "TBCanvasConnectionHandle.h"

@class TBCanvasNodeView;
@class TBCollectionCanvasView;

@protocol CanvasNewConnectionHandleDelegate;

/**
 This class represents a handle to draw connection between items on the canvas.
 */
@interface TBCanvasNewConnectionHandle : TBCanvasConnectionHandle

@property (weak, nonatomic) TBCollectionCanvasView <CanvasNewConnectionHandleDelegate> *delegate;
@property (weak, nonatomic) TBCanvasNodeView *nodeView;

@end

/**
 This protocol is used by the TBCanvasNewConnectionHandle to communicate its state.
 */
@protocol CanvasNewConnectionHandleDelegate <NSObject>

/**
 Return `YES` when the receiver is locked down to single touch processing.
 
 @param canvasNewConnectionHandle The given TBCanvasNewConnectionHandle
 @return `YES` when the receiver is locked down to single touch processing.
 */
- (BOOL)canProcessCanvasNewConnectionHandle:(TBCanvasNewConnectionHandle *)canvasNewConnectionHandle;

/**
 A TBCanvasNewConnectionHandle has been touched.
 
 @param canvasNewConnectionHandle The given TBCanvasNewConnectionHandle
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasNewConnectionHandle:(TBCanvasNewConnectionHandle *)canvasNewConnectionHandle touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 A TBCanvasNewConnectionHandle has been moved.
 
 @param canvasNewConnectionHandle The given TBCanvasNewConnectionHandle
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasNewConnectionHandle:(TBCanvasNewConnectionHandle *)canvasNewConnectionHandle touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a TBCanvasNewConnectionHandle has ended.
 
 @param canvasNewConnectionHandle The given TBCanvasNewConnectionHandle
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasNewConnectionHandle:(TBCanvasNewConnectionHandle *)canvasNewConnectionHandle touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a TBCanvasNewConnectionHandle has been cancelled.
 
 @param canvasNewConnectionHandle The given TBCanvasNewConnectionHandle
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasNewConnectionHandle:(TBCanvasNewConnectionHandle *)canvasNewConnectionHandle touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end