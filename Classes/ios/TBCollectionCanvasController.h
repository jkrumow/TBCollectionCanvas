//
//  TBCollectionCanvasController.h
//
//  Created by Julian Krumow on 02.05.14.
//
//  Copyright (c) 2014 Julian Krumow ()
//
//

#import <Foundation/Foundation.h>

#import "TBCollectionCanvasControllerDelegate.h"

@class TBCollectionCanvasView;
@class TBCanvasNodeView;
@interface TBCollectionCanvasController : NSObject

@property (nonatomic, weak)TBCollectionCanvasView *canvasView;

- (instancetype)initWithCanvasView:(TBCollectionCanvasView *)canvasView;

- (void)registerNodeView:(TBCanvasNodeView *)nodeView;

@end
