//
//  CollectionCanvasViewController.m
//
//  Created by Julian Krumow on 27.01.12.
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

#import "CollectionCanvasViewController.h"

@interface CollectionCanvasViewController()

/**
 Configures a CanvasNodeView object for the given location on the CollectionCanvasView.
 
 @param nodeView The given CanvasNodeView object to configure.
 @param indexPath The given location of the CanvasNodeView.
 */
- (void)configureNodeView:(CanvasNodeView *)nodeView atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation CollectionCanvasViewController

@synthesize delegate = _delegate;
@synthesize collectionCanvasScrollView = _collectionCanvasScrollView;


- (void)setCollectionCanvasScrollView:(CollectionCanvasScrollView *)collectionCanvasScrollView
{
    _collectionCanvasScrollView = collectionCanvasScrollView;
    _collectionCanvasScrollView.contentSize = CGSizeMake(CONTENT_WIDTH, CONTENT_HEIGHT);
    _collectionCanvasScrollView.zoomScale = 0.5;
    _collectionCanvasScrollView.minimumZoomScale = 0.3;
    _collectionCanvasScrollView.maximumZoomScale = 1.0;
    _collectionCanvasScrollView.collectionCanvasView.canvasViewDataSource = self;
    _collectionCanvasScrollView.collectionCanvasView.canvasViewDelegate = self;
    
    self.view = _collectionCanvasScrollView;
}

- (void)loadCanvas
{
    if (self.collectionCanvasScrollView) {
        
        self.collectionCanvasScrollView.contentOffset = CGPointMake(0.0, 0.0);
        
        [self.collectionCanvasScrollView.collectionCanvasView clearCanvas];
        [self.collectionCanvasScrollView.collectionCanvasView fillCanvas];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadCanvas];
    [self toggleConnectMode];
    self.collectionCanvasScrollView.zoomScale = 0.5;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.collectionCanvasScrollView.collectionCanvasView clearCanvas];
    self.collectionCanvasScrollView.collectionCanvasView = nil;
    self.collectionCanvasScrollView = nil;
}

# pragma mark - Rotation handling

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionCanvasScrollView.collectionCanvasView sizeCanvasToFit];
}

#pragma mark - CollectionCanvasViewDataSource

- (NSInteger)numberOfSectionsOnCanvas
{
    return 0;
}

-(NSInteger)numberOfNodesInSection:(NSInteger)section
{
    return 5;
}

- (CanvasNodeView *)nodeViewOnCanvasAtIndexPath:(NSIndexPath *)indexPath
{
    CanvasNodeView *nodeView = [[CanvasNodeView alloc] initWithFrame:CGRectZero];
    nodeView.tag = indexPath.row;
    [self configureNodeView:nodeView atIndexPath:indexPath];
    return nodeView;
}

- (void)configureNodeView:(CanvasNodeView *)nodeView atIndexPath:(NSIndexPath *)indexPath
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 200.0)];
    contentView.backgroundColor = [UIColor colorWithRed:150.0f/255.0f green:214.0f/255.0f blue:217.0f/255.0f alpha:1.0f];
    nodeView.contentView = contentView;
    nodeView.backgroundColor = [UIColor grayColor];
    nodeView.center = CGPointMake(100.0 * (indexPath.row + 1), 100.0 * (indexPath.row + 1));
}

- (CanvasNodeConnection *)newConectionForNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath
{
    CanvasNodeConnection *newConnection = [[CanvasNodeConnection alloc] initWithFrame:CGRectZero];
    newConnection.lineColor = [UIColor colorWithRed:230.0f/255.0f green:213.0f/255.0f blue:143.0f/255.0f alpha:1.0f];
    return newConnection;
}

- (NSSet *)connectionsForNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CanvasMoveConnectionHandle *)moveHandleForConnectionAtPoint:(CGPoint)point
{
    return [[CanvasMoveConnectionHandle alloc] initWithFrame:CGRectMake(point.x - 10.0, point.y - 10.0, 20.0, 20.0)];
}

- (CanvasNewConnectionHandle *)newHandleForConnectionAtPoint:(CGPoint)point
{
    return [[CanvasNewConnectionHandle alloc] initWithFrame:CGRectMake(point.x - 10.0, point.y - 10.0, 20.0, 20.0)];
}

- (void)thumbImageForNodeViewAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)isProcessingViews
{
    return [self.collectionCanvasScrollView.collectionCanvasView isProcessingViews];
}

#pragma mark - Connection handling

- (void)toggleConnectMode
{
    [self.collectionCanvasScrollView.collectionCanvasView toggleConnectMode];
}

@end
