//
//  CollectionCanvasViewController.h
//
//  Created by Julian Krumow on 27.01.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import <UIKit/UIKit.h>

#import "TBCollectionCanvasView.h"


/**
 This class represents the view controller for a TBCollectionCanvasContentView.
 
 */
@interface CollectionCanvasViewController : UIViewController <TBCollectionCanvasContentViewDataSource, TBCollectionCanvasContentViewDelegate>

@property (weak, nonatomic) IBOutlet TBCollectionCanvasView *collectionCanvasScrollView;

/**
 Returns `YES` if the TBCollectionCanvasContentView is processing items.
 
 @return `YES`if the TBCollectionCanvasContentView is processing items.
 */
- (BOOL)isProcessingViews;

/**
 Loads the content to canvas.
 */
- (void)loadCanvas;

/**
 Toggles connect mode on the TBCollectionCanvasContentView.
 */
- (void)toggleConnectMode;

@end
