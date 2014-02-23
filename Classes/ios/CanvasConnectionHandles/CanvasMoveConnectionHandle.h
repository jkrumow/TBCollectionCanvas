//
//  CanvasMoveConnectionHandle.h
//
//  Created by Julian Krumow on 14.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


#import "CanvasItemView.h"

@class CanvasNodeConnection;
@class CollectionCanvasView;

@protocol CanvasMoveConnectionHandleDelegate;

/**
 This class represents a handle to move a connection on the canvas.
 It is transparent and hovers above the tip of the connection pointing to the child view.
 */
@interface CanvasMoveConnectionHandle : CanvasItemView

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