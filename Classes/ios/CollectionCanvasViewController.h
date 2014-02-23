//
//  CollectionCanvasViewController.h
//
//  Created by Julian Krumow on 27.01.12.
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

#import "CollectionCanvasScrollView.h"


@protocol CollectionCanvasViewControllerDelegate;

/**
 This class represents the view controller for a CollectionCanvasView.
 
 */
@interface CollectionCanvasViewController : UIViewController <UIScrollViewDelegate
, CollectionCanvasViewDataSource, CollectionCanvasViewDelegate>

@property (weak, nonatomic) UIViewController<CollectionCanvasViewControllerDelegate> *delegate;
@property (weak, nonatomic) IBOutlet CollectionCanvasScrollView *collectionCanvasScrollView;

/**
 Returns `YES` if the CollectionCanvasView is processing items.
 
 @return `YES`if the CollectionCanvasView is processing items.
 */
- (BOOL)isProcessingViews;

/**
 Loads the content to canvas.
 */
- (void)loadCanvas;

/**
 Toggles connect mode on the CollectionCanvasView.
 */
- (void)toggleConnectMode;

@end

/**
 This protocol is used by the CollectionCanvasViewController.
 */
@protocol CollectionCanvasViewControllerDelegate <NSObject>

/**
 A CanvasNodeView has been selected.
 
 @param collectionCanvasViewController The sender of this message.
 @param nodeView  The selected view object.
 @param indexPath The index path of the selected item in the data store.
 */
- (void)collectionCanvasViewController:(CollectionCanvasViewController *)collectionCanvasViewController didSelectNode:(CanvasNodeView *)nodeView onCanvasAtIndexPath:(NSIndexPath *)indexPath;

@end