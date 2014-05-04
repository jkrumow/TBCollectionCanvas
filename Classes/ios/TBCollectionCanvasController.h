//
//  TBCollectionCanvasController.h
//
//  Created by Julian Krumow on 02.05.14.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//

#import <Foundation/Foundation.h>

#import "TBCollectionCanvasControllerDelegate.h"

@class TBCollectionCanvasView;
@interface TBCollectionCanvasController : NSObject

@property (nonatomic, weak)TBCollectionCanvasView<CollectionCanvasControllerDelegate> *canvasView;

@end
