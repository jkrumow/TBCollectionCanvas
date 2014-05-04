//
//  CollectionCanvasViewController.h
//
//  Created by Julian Krumow on 27.01.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import <UIKit/UIKit.h>

#import "TBCollectionCanvasScrollView.h"


/**
 This class represents the view controller for a TBCollectionCanvasView.
 
 */
@interface CollectionCanvasViewController : UIViewController <TBCollectionCanvasViewDataSource, TBCollectionCanvasViewDelegate>

@property (weak, nonatomic) IBOutlet TBCollectionCanvasScrollView *collectionCanvasScrollView;

/**
 Returns `YES` if the TBCollectionCanvasView is processing items.
 
 @return `YES`if the TBCollectionCanvasView is processing items.
 */
- (BOOL)isProcessingViews;

/**
 Loads the content to canvas.
 */
- (void)loadCanvas;

/**
 Toggles connect mode on the TBCollectionCanvasView.
 */
- (void)toggleConnectMode;

@end
