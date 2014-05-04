//
//  TBCollectionCanvasController.h
//
//  Created by Julian Krumow on 02.05.14.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//

#import "TBCollectionCanvasController.h"

@implementation TBCollectionCanvasController

- (instancetype)initWithCanvasView:(TBCollectionCanvasView<CollectionCanvasControllerDelegate> *)canvasView
{
    self = [super init];
    if (self) {
        
        _canvasView = canvasView;
        
    }
    return self;
}

@end
