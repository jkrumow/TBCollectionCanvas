//
//  CollectionCanvasViewDataSource.h
//
//  Created by julian krumow on 21.08.12.
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

#import <Foundation/Foundation.h>

/**
 This is the data source protocol for the CollectionCanvasView.
 
 */
@protocol CollectionCanvasViewDataSource <NSObject>

/**
 Returns the number of sections on the canvas.
 
 @return The number of sections.
 */
- (NSInteger)numberOfSectionsOnCanvas;

/**
 Returns the number of Node objects of a given section on the canvas.
 
 @param section The given section number
 
 @return The number of CanvasNodeView objects
 */
- (NSInteger)numberOfNodesInSection:(NSInteger)section;

/**
 Returns the CanvasNodeView object with a given index path from the canvas.
 
 @param indexPath The given index path
 
 @return The CanvasNodeView object with the corresponding index. Otherwise nil.
 */
- (CanvasNodeView *)nodeViewOnCanvasAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns a set of Connection objects for a given Node object.
 
 Iterates through the set and connects the corresponding CanvasNodeView objects with CanvasNodeConnections.
 
 @param indexPath The index path of the given collection.
 
 @return The NSArray object with all CanvasNodeConnection objects. Otherwise nil.
 */
- (NSSet *)connectionsForNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath;

/**
 Requests a single thumbimage for a CanvasNodeView at a given index path.
 Just a trigger for an asynchronuous fetch of the image. Return image by calling
 
 - (void)updateNodeViewAtIndexPath:(NSIndexPath *)indexPath
 
 on CollectionCanvasView.
 
 @param indexPath The given index path
 */
- (void)thumbImageForNodeViewAtIndexPath:(NSIndexPath *)indexPath;

@end
