//
//  CanvasNodeConnectionBubble.h
//
//  Created by Julian Krumow on 11.02.12.
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

@class CanvasNodeView;
@class CollectionCanvasView;

@protocol CanvasNewConnectionHandleDelegate;

/**
 This class represents a handle to draw connection between items on the canvas.
 */
@interface CanvasNewConnectionHandle : CanvasItemView

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