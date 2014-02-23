//
//  CollectionCanvasScrollView.h
//
//  Created by Julian Krumow on 01.02.12.
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

#import "CollectionCanvasView.h"

extern CGFloat const CONTENT_WIDTH;
extern CGFloat const CONTENT_HEIGHT;

/**
 This is the CollectionCanvasScrollView. It is the master view in with the CollectionCanvasView will be displayed as a subview - to make the whole canvas zoomable.
 
 Touch events in a subview will not be intercepted by the CollectionCanvasScrollView unless they appeared on
 the CollectionCanvasView itself. So dragging a CanvasNodeView as well as zooming and scrolling the CollectionCanvasScrollView will preserved.
 
 All touch events in a subview will not be cancelled while a CanvasItemView is being touched, moved etc.
 */
@interface CollectionCanvasScrollView : UIScrollView

@property (strong, nonatomic) CollectionCanvasView *collectionCanvasView;

@end