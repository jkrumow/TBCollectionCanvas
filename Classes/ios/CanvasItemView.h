//
//  CanvasView.h
//
//  Created by Julian Krumow on 10.02.12.
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
