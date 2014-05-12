//
//  TBCollectionCanvasController.h
//
//  Created by Julian Krumow on 02.05.14.
//
//  Copyright (c) 2014 Julian Krumow ()
//
//

#import "TBCollectionCanvasController.h"
#import "TBCollectionCanvasView.h"

static void *canvasControllerContext = &canvasControllerContext;
static NSString *nodeViewCenter = @"center";

@implementation TBCollectionCanvasController

- (instancetype)initWithCanvasView:(TBCollectionCanvasView *)canvasView
{
    self = [super init];
    if (self) {
        
        _canvasView = canvasView;
        
    }
    return self;
}

- (void)registerNodeView:(TBCanvasNodeView *)nodeView
{
    [nodeView addObserver:self forKeyPath:nodeViewCenter options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:canvasControllerContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (context == canvasControllerContext) {
        
        // TBCanvasNodeView has been moved
        if ([keyPath isEqualToString:nodeViewCenter]) {
            
            if ([[change objectForKey:NSKeyValueChangeKindKey] integerValue] == NSKeyValueChangeSetting) {
                
                CGPoint oldCenter = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
                CGPoint newCenter = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
                
                NSLog(@"%@ --> %@", NSStringFromCGPoint(oldCenter), NSStringFromCGPoint(newCenter));
            }
        }
    }
}

@end
