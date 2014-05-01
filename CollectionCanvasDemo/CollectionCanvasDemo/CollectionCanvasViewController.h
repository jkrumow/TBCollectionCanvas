//
//  CollectionCanvasViewController.h
//
//  Created by Julian Krumow on 27.01.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import <UIKit/UIKit.h>

#import "CollectionCanvasScrollView.h"


@protocol CollectionCanvasViewControllerDelegate;

/**
 This class represents the view controller for a CollectionCanvasView.
 
 */
@interface CollectionCanvasViewController : UIViewController <CollectionCanvasViewDataSource, CollectionCanvasViewDelegate>

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