//
//  TBCanvasNodeView.h
//
//  Created by Julian Krumow on 24.01.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import <UIKit/UIKit.h>

#import "TBCanvasItemView.h"
#import "TBCanvasConnectionView.h"
#import "TBCanvasCreateHandleView.h"

@protocol TBCanvasNodeViewDelegate;
@class TBCollectionCanvasContentView;

/**
 This class represents a node view on the canvas.
 
 */
@interface TBCanvasNodeView : TBCanvasItemView

@property (assign, nonatomic) BOOL hasCollapsedSubStructure;
@property (assign, nonatomic) NSInteger headNodeTag;

@property (weak, nonatomic) TBCollectionCanvasContentView <TBCanvasNodeViewDelegate> *delegate;
@property (weak, nonatomic) TBCanvasCreateHandleView *connectionHandle;

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
 Sets the TBCanvasNodeView's selected state.
 
 @param isSelected True when the TBCanvasNodeView shall be selected.
 */
- (void)setSelected:(BOOL)isSelected;

/**
 Sets the TBCanvasNodeView's editing state.
 
 @param isEditing True when the TBCanvasNodeView shall switch to edit view.
 */
- (void)setEditing:(BOOL)isEditing;

/**
 Returns the segment rectangle transformed by zoomScale.
 
 @return The scaled segment rectangle.
 */
- (CGRect)scaledSegmentRect;

@end

/**
 This protocol is used by the TBCanvasNodeView to communicate its state.
 */
@protocol TBCanvasNodeViewDelegate <NSObject>

/**
 Return `YES` when the receiver is locked down to single touch processing.
 
 @param canvasNodeView The given TBCanvasNodeView
 @return `YES` when the receiver is locked down to single touch processing.
 */
- (BOOL)canProcessCanvasNodeView:(TBCanvasNodeView *)canvasNodeView;

/**
 A TBCanvasNodeView has been touched.
 
 @param canvasNodeView The given TBCanvasNodeView
 @param touches        The touches
 @param event          The event
 */
- (void)canvasNodeView:(TBCanvasNodeView *)canvasNodeView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 A TBCanvasNodeView has been moved.
 
 @param canvasNodeView The given TBCanvasNodeView
 @param touches        The touches
 @param event          The event
 */
- (void)canvasNodeView:(TBCanvasNodeView *)canvasNodeView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a TBCanvasNodeView has ended.
 
 @param canvasNodeView The given TBCanvasNodeView
 @param touches        The touches
 @param event          The event
 */
- (void)canvasNodeView:(TBCanvasNodeView *)canvasNodeView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 Touching a TBCanvasNodeView has been cancelled.
 
 @param canvasNodeView The given TBCanvasNodeView
 @param touches        The touches
 @param event          The event
 */
- (void)canvasNodeView:(TBCanvasNodeView *)canvasNodeView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
