//
//  CollectionCanvasController.h
//
//  Created by Julian Krumow on 02.05.14.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//

#import "CollectionCanvasController.h"

@implementation CollectionCanvasController

- (instancetype)initWithCanvasView:(CollectionCanvasView<CollectionCanvasControllerDelegate> *)canvasView
{
    self = [super init];
    if (self) {
        
        _canvasView = canvasView;
        
    }
    return self;
}

@end
