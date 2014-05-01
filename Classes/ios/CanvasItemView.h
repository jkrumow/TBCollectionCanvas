//
//  CanvasView.h
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
@interface CanvasItemView : UIView
{
    BOOL _isSelected;
    BOOL _isHighlighted;
    BOOL _isEditing;
}

@property (assign, nonatomic) CGFloat zoomScale;
@property (assign, nonatomic, readonly) CGSize touchOffset;
@property (assign, nonatomic) CGSize deltaToCollapsedNode;
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
 Sets the CanvasNodeView's selected state.
 
 @param isSelected True when the CanvasNodeView shall be selected.
 */
- (void)setSelected:(BOOL)isSelected;

/**
 Sets the CanvasNodeView's highlight state.
 
 @param isHighlighted True when the CanvasNodeView shall be highlighted.
 */
- (void)setHighlighted:(BOOL)isHighlighted;

/**
 Sets the center point of the CanvasNodeItem.
 Set animated to YES to slide item into place.
 
 @param center   The given CGPoint for the new center point
 @param animated Set to YES to animate re-positioning
 */
- (void)setCenter:(CGPoint)center animated:(BOOL)animated;

@end
