//
//  CollectionCanvasController.h
//
//  Created by Julian Krumow on 02.05.14.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//

#import <Foundation/Foundation.h>

#import "CollectionCanvasControllerDelegate.h"

@class CollectionCanvasView;
@interface CollectionCanvasController : NSObject

@property (nonatomic, weak)CollectionCanvasView<CollectionCanvasControllerDelegate> *canvasView;

@end
