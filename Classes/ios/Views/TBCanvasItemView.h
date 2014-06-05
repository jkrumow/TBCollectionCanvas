//
//  TBCanvasView.h
//
//  Created by Julian Krumow on 10.02.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import <UIKit/UIKit.h>

/**
 This class represents the base class of all subviews on the canvas.
 
 */
@interface TBCanvasItemView : UIView
{
    BOOL _isSelected;
    BOOL _isHighlighted;
    BOOL _isEditing;
}

/**
 *  The view's zoomscale.
 */
@property (assign, nonatomic) CGFloat zoomScale;

/**
 *  The view's touch offset from center.
 */
@property (assign, nonatomic, readonly) CGSize touchOffset;

/**
 *  x- and y-distance to the center of the parent node.
 */
@property (assign, nonatomic) CGSize deltaToCollapsedNode;

/**
 *  Set to `YES` if the view is inside a collapsed graph segment.
 */
@property (assign, nonatomic) BOOL isInCollapsedSegment;

/**
 Returns the frame transformed by zoomScale.
 */
- (CGRect)scaledFrame;

/**
 Returns the center transformed by zoomScale.
 */
- (CGPoint)scaledCenter;

/**
 Sets the TBCanvasNodeView's selected state.
 
 @param isSelected True when the TBCanvasNodeView shall be selected.
 */
- (void)setSelected:(BOOL)isSelected;

/**
 Sets the TBCanvasNodeView's highlight state.
 
 @param isHighlighted True when the TBCanvasNodeView shall be highlighted.
 */
- (void)setHighlighted:(BOOL)isHighlighted;

/**
 Sets the center point of the TBCanvasNodeItem.
 Set animated to YES to slide item into place.
 
 @param center   The given CGPoint for the new center point
 @param animated Set to YES to animate re-positioning
 */
- (void)setCenter:(CGPoint)center animated:(BOOL)animated;

@end
