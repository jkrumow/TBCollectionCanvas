//
//  CanvasNodeConnection
//
//  Created by Julian Krumow on 29.01.12.
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

#import <QuartzCore/QuartzCore.h>

#import "CanvasItemView.h"
#import "CanvasMoveConnectionHandle.h"

@protocol CanvasNodeConnectionDelegate;

@class CanvasNodeView;

/**
 This class represents a connection between two CanvasNodeViews on the canvas.
 
 */
@interface CanvasNodeConnection : CanvasItemView

@property (assign, nonatomic) id<CanvasNodeConnectionDelegate> canvasNodeConnectionDelegate;

@property (assign, nonatomic, readonly) NSUInteger parentIndex;
@property (assign, nonatomic, readonly) NSUInteger childIndex;

@property (weak, nonatomic) CanvasNodeView *parentNode;
@property (weak, nonatomic) CanvasNodeView *childNode;
@property (weak, nonatomic) CanvasMoveConnectionHandle *moveConnectionHandle;

@property (strong, nonatomic) NSString *colorString;
@property (assign, nonatomic, readonly) CGPoint visibleStartPoint;
@property (assign, nonatomic, readonly) CGPoint visibleEndPoint;

/**
 Returns `YES` if the connection is a valid connection inside CollectionCanvasView's viewhierarchy.
 `NO` if the connection is about to be removed from the viewhierarchy.
 */
@property (assign, nonatomic, readonly, getter = isValid) BOOL valid;

/**
 Initializes the CanvasNodeConnection object with a given CGRect and the value of parentIndex and childIndex.
 
 @param frame The frame of the CanvasNodeConnection view
 @return The initialized CanvasNodeConnection object
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
 Returns the indexPath of the CanvasNodeConnection object.
 
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
 This protocol is used to notifiy the receiver about the state of a CanvasNodeConnection.
 
 */
@protocol CanvasNodeConnectionDelegate <NSObject>

/**
 Notifies the receiver that the suspenderSnapAnimation has completed.
 
 @param connection The animated CanvasNodeConnection
 @param indexPath  The index path of the given CanvasNodeConnection
 */
- (void)removedConnection:(CanvasNodeConnection *)connection atIndexPath:(NSIndexPath *)indexPath;

@end
