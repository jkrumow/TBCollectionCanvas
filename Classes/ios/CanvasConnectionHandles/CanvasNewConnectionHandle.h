//
//  CanvasNodeConnectionBubble.h
//
//  Created by Julian Krumow on 11.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import "CanvasItemView.h"
#import "CanvasConnectionHandle.h"

@class CanvasNodeView;
@class CollectionCanvasView;

@protocol CanvasNewConnectionHandleDelegate;

/**
 This class represents a handle to draw connection between items on the canvas.
 */
@interface CanvasNewConnectionHandle : CanvasConnectionHandle

@property (weak, nonatomic) CollectionCanvasView <CanvasNewConnectionHandleDelegate> *delegate;
@property (weak, nonatomic) CanvasNodeView *nodeView;

@end

/**
 This protocol is used by the CanvasNewConnectionHandle to communicate its state.
 */
@protocol CanvasNewConnectionHandleDelegate <NSObject>

/**
 Return `YES` when the receiver is locked down to single touch processing.
 
 @param canvasNewConnectionHandle The given CanvasNewConnectionHandle
 @return `YES` when the receiver is locked down to single touch processing.
 */
- (BOOL)canProcessCanvasNewConnectionHandle:(CanvasNewConnectionHandle *)canvasNewConnectionHandle;

/**
 A CanvasNewConnectionHandle has been touched.
 
 @param canvasNewConnectionHandle The given CanvasNewConnectionHandle
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasNewConnectionHandle:(CanvasNewConnectionHandle *)canvasNewConnectionHandle touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 A CanvasNewConnectionHandle has been moved.
 
 @param canvasNewConnectionHandle The given CanvasNewConnectionHandle
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasNewConnectionHandle:(CanvasNewConnectionHandle *)canvasNewConnectionHandle touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a CanvasNewConnectionHandle has ended.
 
 @param canvasNewConnectionHandle The given CanvasNewConnectionHandle
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasNewConnectionHandle:(CanvasNewConnectionHandle *)canvasNewConnectionHandle touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a CanvasNewConnectionHandle has been cancelled.
 
 @param canvasNewConnectionHandle The given CanvasNewConnectionHandle
 @param touches                   The touches
 @param event                     The event
 */
- (void)canvasNewConnectionHandle:(CanvasNewConnectionHandle *)canvasNewConnectionHandle touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end