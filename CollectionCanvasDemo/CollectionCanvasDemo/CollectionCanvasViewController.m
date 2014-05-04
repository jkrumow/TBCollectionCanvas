//
//  CollectionCanvasViewController.m
//
//  Created by Julian Krumow on 27.01.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//

#import "CollectionCanvasViewController.h"

@interface CollectionCanvasViewController()

/**
 Configures a TBCanvasNodeView object for the given location on the TBCollectionCanvasView.
 
 @param nodeView The given TBCanvasNodeView object to configure.
 @param indexPath The given location of the TBCanvasNodeView.
 */
- (void)configureNodeView:(TBCanvasNodeView *)nodeView atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation CollectionCanvasViewController

- (void)setCollectionCanvasScrollView:(TBCollectionCanvasScrollView *)collectionCanvasScrollView
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

#pragma mark - TBCollectionCanvasViewDataSource

- (NSInteger)numberOfSectionsOnCanvas
{
    return 0;
}

-(NSInteger)numberOfNodesInSection:(NSInteger)section
{
    return 5;
}

- (TBCanvasNodeView *)nodeViewOnCanvasAtIndexPath:(NSIndexPath *)indexPath
{
    TBCanvasNodeView *nodeView = [[TBCanvasNodeView alloc] initWithFrame:CGRectZero];
    nodeView.tag = indexPath.row;
    [self configureNodeView:nodeView atIndexPath:indexPath];
    return nodeView;
}

- (void)configureNodeView:(TBCanvasNodeView *)nodeView atIndexPath:(NSIndexPath *)indexPath
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 200.0)];
    contentView.backgroundColor = [UIColor colorWithRed:150.0f/255.0f green:214.0f/255.0f blue:217.0f/255.0f alpha:1.0f];
    nodeView.contentView = contentView;
    nodeView.backgroundColor = [UIColor grayColor];
    nodeView.center = CGPointMake(100.0 * (indexPath.row + 1), 100.0 * (indexPath.row + 1));
}

- (TBCanvasNodeConnection *)newConectionForNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath
{
    TBCanvasNodeConnection *newConnection = [[TBCanvasNodeConnection alloc] initWithFrame:CGRectZero];
    newConnection.lineColor = [UIColor colorWithRed:230.0f/255.0f green:213.0f/255.0f blue:143.0f/255.0f alpha:1.0f];
    return newConnection;
}

- (NSSet *)connectionsForNodeOnCanvasAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (TBCanvasMoveConnectionHandle *)moveHandleForConnectionAtPoint:(CGPoint)point
{
    return [[TBCanvasMoveConnectionHandle alloc] initWithFrame:CGRectMake(point.x - 10.0, point.y - 10.0, 20.0, 20.0)];
}

- (TBCanvasNewConnectionHandle *)newHandleForConnectionAtPoint:(CGPoint)point
{
    return [[TBCanvasNewConnectionHandle alloc] initWithFrame:CGRectMake(point.x - 10.0, point.y - 10.0, 20.0, 20.0)];
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
