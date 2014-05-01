//
//  CanvasNodeView.h
//
//  Created by Julian Krumow on 24.01.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import <UIKit/UIKit.h>

#import "CanvasItemView.h"
#import "CanvasNodeConnection.h"
#import "CanvasNewConnectionHandle.h"

@protocol CanvasNodeViewDelegate;
@class CollectionCanvasView;

/**
 This class represents a node view on the canvas.
 
 */
@interface CanvasNodeView : CanvasItemView

@property (assign, nonatomic) BOOL hasCollapsedSubStructure;
@property (assign, nonatomic) NSInteger headNodeTag;

@property (weak, nonatomic) CollectionCanvasView <CanvasNodeViewDelegate> *delegate;
@property (weak, nonatomic) CanvasNewConnectionHandle *connectionHandle;

@property (strong, nonatomic) NSMutableArray *connectedNodes;
@property (strong, nonatomic) NSMutableArray *parentConnections;
@property (strong, nonatomic) NSMutableArray *childConnections;

@property (assign, nonatomic) CGPoint connectionHandleAncorPoint;
@property (assign, nonatomic) CGRect segmentRect;

@property (strong, nonatomic) UIView *contentView;

/**
 Resets all connections.
 */
- (void)reset;

/**
 Sets the CanvasNodeView's selected state.
 
 @param isSelected True when the CanvasNodeView shall be selected.
 */
- (void)setSelected:(BOOL)isSelected;

/**
 Sets the CanvasNodeView's editing state.
 
 @param isEditing True when the CanvasNodeView shall switch to edit view.
 */
- (void)setEditing:(BOOL)isEditing;

/**
 Returns the segment rectangle transformed by zoomScale.
 
 @return The scaled segment rectangle.
 */
- (CGRect)scaledSegmentRect;

@end

/**
 This protocol is used by the CanvasNodeView to communicate its state.
 */
@protocol CanvasNodeViewDelegate <NSObject>

/**
 Return `YES` when the receiver is locked down to single touch processing.
 
 @param canvasNodeView The given CanvasNodeView
 @return `YES` when the receiver is locked down to single touch processing.
 */
- (BOOL)canProcessCanvasNodeView:(CanvasNodeView *)canvasNodeView;

/**
 A CanvasNodeView has been touched.
 
 @param canvasNodeView The given CanvasNodeView
 @param touches        The touches
 @param event          The event
 */
- (void)canvasNodeView:(CanvasNodeView *)canvasNodeView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 A CanvasNodeView has been moved.
 
 @param canvasNodeView The given CanvasNodeView
 @param touches        The touches
 @param event          The event
 */
- (void)canvasNodeView:(CanvasNodeView *)canvasNodeView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a CanvasNodeView has ended.
 
 @param canvasNodeView The given CanvasNodeView
 @param touches        The touches
 @param event          The event
 */
- (void)canvasNodeView:(CanvasNodeView *)canvasNodeView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a CanvasNodeView has been cancelled.
 
 @param canvasNodeView The given CanvasNodeView
 @param touches        The touches
 @param event          The event
 */
- (void)canvasNodeView:(CanvasNodeView *)canvasNodeView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end