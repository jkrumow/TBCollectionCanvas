//
//  TBCollectionCanvasContentView.m
//
//  Created by Julian Krumow on 23.01.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import "TBCollectionCanvasContentView.h"
#import "TBCollectionCanvasView.h"
#import "TBCanvasCreateHandleView.h"
#import "TBCanvasMoveHandleView.h"

NSString * const kInternalInconsistencyException = @"InternalInconsistencyException";

@interface TBCollectionCanvasContentView()
{
    BOOL isInConnectMode;
    BOOL isMovingCanvasNodeViews;
    
    float autoscrollDistanceHorizontal;
    float autoscrollDistanceVertical;
}

// The currently touched views.
@property (nonatomic, strong) NSMutableArray *viewsTouched;

// Stores all node views displayed on the canvas.
@property (nonatomic, strong) NSMutableArray *nodeViews;

// Stores all node connections displayed on the canvas.
@property (nonatomic, strong) NSMutableArray *connectionViews;

// Stores all handles to establish a new connection.
@property (nonatomic, strong) NSMutableArray *createHandles;

// Stores all handles to move an established connection.
@property (nonatomic, strong) NSMutableArray *moveHandles;

// Stores all TBCanvasItemViews that are part of the selected tree segment and will be processed with the head node.
@property (nonatomic, strong) NSMutableDictionary *segmentsBelowNode;

// Stores all TBCanvasConnectionView of a node view inside a selected tree segment wich point to a node view outside the segment.
@property (nonatomic, strong) NSMutableArray *connectionViewsForFullRefresh;

// A connection that is used when the user wants to establish a new connection between two TBCanvasNodeViews.
@property (nonatomic, strong) TBCanvasConnectionView *temporaryConnectionView;

// When the temporary connection is above a TBCanvasNodeView, this view will be highlighted and stored at this pointer.
@property (nonatomic, strong) TBCanvasNodeView *connectableNodeView;

// A connection that has been tapped by the user. The attributes of this connection can be edited.
@property (nonatomic, strong) TBCanvasConnectionView *selectedConnectionView;

@property (nonatomic, strong) NSMutableArray *autoscrollingItems;

// Moves the dragged view and the parent scrollview by a given fraction when the view has been dragged outside the content view.
@property (nonatomic, strong) NSTimer *autoscrollTimer;

// Triggered when a touch on an TBCanvasNodeView has began. Invalidated when the touch has moved has ended.
@property (nonatomic, strong) NSTimer *menuTimer;

// The menu controller of this TBCollectionCanvasContentView.
@property (nonatomic, strong) UIMenuController *menuController;

// The view currently decorated with a menu.
@property (nonatomic, strong) TBCanvasNodeView *viewWithMenu;

/** @name Layout */

/**
 Returns a valid center point on the canvas for a new nodeview.
 
 @param nodeView the TBCanvasNodeView
 
 @return the valid center as CGPoint
 */
- (CGPoint)autoLayoutNodeView:(TBCanvasNodeView *)nodeView;

/** @name Handling TBCanvasConnectionView objects */

/**
 Adds a TBCanvasConnectionView between TBCanvasNodeViews.
 */
- (void)connectNodes;

/** @name Autoscrolling */

/**
 Cuts autoscroll distance to maxAutoscrollDistance when the value exceeds the maximum defined with const maxAutoscrollDistance.
 */
- (void)validateAutoscrollDistance;

/**
 Grows / shrinks the canvas by a given fraction.
 */
- (void)autoScrollOnEdges;

/**
 Calculates the autoscroll distance depending on the proximity to the view's edge.
 The closer the object to the view's edge the faster it will scroll.
 
 @param proximity The proximity of a given view
 @return The autoscroll value
 */
- (float)autoscrollDistanceForProximityToEdge:(float)proximity;

/**
 Checks wether the given view touches the right and or bottom egde of the content view
 and triggers an automatic dragging.
 
 @param itemView The given TBCanvasItemView to check.
 */
- (void)checkAutoScrollingForCanvasItemView:(TBCanvasItemView *)itemView;

/**
 Scrolls the touched view to be visible.
 */
- (void)scrollTouchedViewToVisible;

/** @name Connection Handles */

/**
 Adds handles to all connections.
 
 - Adds a TBCanvasCreateHandleView above every TBCanvasNodeView on the canvas.
 - Adds a TBCanvasMoveHandleView above every TBCanvasConnectionView.
 
 Handles will be subviews of the TBCollectionCanvasContentView.
 Handle objects will be stored in the NSMutableArrays
 - newHandles
 - moveHandles
 */
- (void)addConnectionHandles;

/**
 Returns a TBCanvasCreateHandleView for a given TBCanvasNodeView.
 
 @param  nodeView The given TBCanvasNodeView
 @return The resulting TBCanvasCreateHandleView
 */
- (TBCanvasCreateHandleView *)makeCreateHandleForNodeView:(TBCanvasNodeView *)nodeView;

/**
 Returns a TBCanvasMoveHandleView for a given TBCanvasConnectionView.
 
 @param  connection The given TBCanvasConnectionView
 @return The resulting TBCanvasMoveHandleView
 */
- (TBCanvasMoveHandleView *)makeMoveConnectionHandleForConnection:(TBCanvasConnectionView *)connection;

/**
 Removes all TBCanvasCreateHandles and TBCanvasMoveHandles from the TBCollectionCanvasContentView
 and from the 'newHandles' and 'moveHandles' arrays.
 */
- (void)removeConnectionHandles;

/**
 Redraws all given TBCanvasConnectionView objects passed in an array.
 
 @param connections The TBCanvasConnectionView objects to redraw.
 */
- (void)refreshConnections:(NSMutableArray *)connections;

/**
 Redraws all parent and child connections of a given TBCanvasNodeView object.
 
 @param canvasNodeView The given TBCanvasNodeView object
 */
- (void)refreshConnectionsForView:(TBCanvasNodeView *)canvasNodeView;

/**
 Redraws all TBCanvasConnectionViews inside the connectionsForFullRefresh array.
 */
- (void)refreshConnectionsOutsideSelection;

/**
 Move a TBCanvasItemView's connections.
 
 @param itemView The given TBCanvasItemView object.
 */
- (void)moveConnectionsForItemView:(TBCanvasItemView *)itemView;

/** @name Processing multiple items */

/**
 Collects all TBCanvasItemViews that belong to a selected tree segment (below the selected node view).
 Stores the collected objects inside the moveableSegment array.
 
 @param nodeView The given TBCanvasNodeView object
 
 @return A CGRect wich surrounds all collected CanvavsNodeView objects.
 */
- (NSMutableArray *)collectSegmentBelowNode:(TBCanvasNodeView *)nodeView;

/**
 Calculates the smallest possible rectangle around a given array of TBCanvasItemView objects.
 
 @param treeSegment The array containing the given TBCanvasItemViews.
 */
- (CGRect)segmentRectangleFromSegment:(NSArray *)treeSegment;

/**
 Collects all TBCanvasConnectionView objects wich point to node views outside the selected tree segment.
 Stores the collected objects inside the connectionsForFullRefresh array.
 */
- (void)collectConnectionsForFullRefresh;

/**
 Collapses all items below a given node view.
 
 @param nodeView The given node view to collapse
 */
- (void)collapseSegment:(TBCanvasNodeView *)nodeView;

/**
 Swing the visible TBCanvasNodeViews to a natural treeSegment.
 
 @param treeSegment The treeSegment of  TBCanvasNodeViews.
 */
- (void)ticktockSegment:(NSArray *)treeSegment;

/**
 Passes a collapsed treeSegment of TBCanvasNodeViews to the delegate to be saved.
 
 @param treeSegment The treeSegment of  TBCanvasNodeViews
 */
- (void)saveCollapsedSegment:(NSMutableArray *)treeSegment;

/**
 Expands all items below a given node view.
 
 @param nodeView The given node view to expand
 */
- (void)expandSegment:(TBCanvasNodeView *)nodeView;

/**
 Sets an item to expanded status.
 
 Resets the position on the canvas - relative to head node when it is not part of a collapsed subnode.
 
 @param item The given  TBCanvasItemView
 @param headNode The head node of this tree segment
 @param expandAsSubnode Set to NO when the subnode is collapsed too
 */
- (void)expandItem:(TBCanvasItemView *)item headNode:(TBCanvasNodeView *)headNode expandAsSubnode:(BOOL)expandAsSubnode;

/**
 Expands all items below a given node view.
 
 Though this method works recursive the head node is given as a separate parameter.
 
 @param nodeView The given node view
 @param headNode The head of the collapsed node
 @param expandSubnode Set to NO when the subnode is collapsed too
 */
- (void)expandSegment:(TBCanvasNodeView *)nodeView headNode:(TBCanvasNodeView *)headNode expandSubNode:(BOOL)expandSubnode;

/**
 Passes an expanded treeSegment of  TBCanvasNodeViews to the delegate to be saved.
 
 @param treeSegment The treeSegment of  TBCanvasNodeViews
 */
- (void)saveExpandedSegment:(NSMutableArray *)treeSegment;

/** @name Handling the menu */

/**
 Starts timer if necesary to present a menu above the given  TBCanvasItemView.
 
 @param canvasItemView The given  TBCanvasItemView
 */
- (void)scheduleMenuForItemView:(TBCanvasItemView *)canvasItemView;

/**
 Shows the menu to delete, collapse / expand the selected item.
 
 @param timer The NSTimer object invoking this method.
 */
- (void)showMenu:(NSTimer *)timer;

/**
 Adds custom items to the view's menu controller.
 */
- (void)configureMenu;

@end

@implementation TBCollectionCanvasContentView

static CGFloat OUTER_CANVAS_MARGIN      = 100.0;
static CGFloat OUTER_FILEVIEW_MARGIN    = 40.0;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        CALayer *layer = [self layer];
        layer.cornerRadius = 8.0;
        
        zoomScale = 0.5;
        
        _temporaryConnectionView = nil;
        _connectableNodeView = nil;
        _selectedConnectionView = nil;
        
        _scrollView = nil;
        _autoscrollTimer = nil;
        _menuTimer = nil;
        _menuEnabled = NO;
        
        _viewsTouched = [[NSMutableArray alloc] init];
        _nodeViews = [[NSMutableArray alloc] init];
        _connectionViews = [[NSMutableArray alloc] init];
        _createHandles = [[NSMutableArray alloc] init];
        _moveHandles = [[NSMutableArray alloc] init];
        _segmentsBelowNode = [[NSMutableDictionary alloc] init];
        _connectionViewsForFullRefresh = [[NSMutableArray alloc] init];
        _autoscrollingItems = [[NSMutableArray alloc] init];
        
        isMovingCanvasNodeViews = NO;
        isInConnectMode = NO;
        
        self.viewWithMenu = nil;
        self.menuController = [UIMenuController sharedMenuController];
    }
    return self;
}

- (void)configureMenu
{
    UIMenuItem *collapseItem = [[UIMenuItem alloc] initWithTitle:@"Collapse" action:@selector(collapse:)];
    UIMenuItem *expandItem = [[UIMenuItem alloc] initWithTitle:@"Expand" action:@selector(expand:)];
    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithObjects:collapseItem, expandItem, nil];
    self.menuController.menuItems = menuItems;
}

#pragma mark -  TBCanvas view setup

- (void)fillCanvas
{
    NSInteger nodeCount = 0;
    NSMutableArray *headNodes = [[NSMutableArray alloc] init];
    NSMutableArray *segmentNodes = [[NSMutableArray alloc] init];
    
    if ([_canvasViewDataSource respondsToSelector:@selector(numberOfNodesInSection:)]) {
        nodeCount = [_canvasViewDataSource numberOfNodesInSection:0];
    }
    
    for (NSInteger i = 0; i < nodeCount; i++) {
        TBCanvasNodeView *nodeView = nil;
        
        if ([_canvasViewDataSource respondsToSelector:@selector(nodeViewOnCanvasAtIndexPath:)]) {
            nodeView = [_canvasViewDataSource nodeViewOnCanvasAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        if (nodeView) {
            
            if (nodeView.tag == i) {
                
                nodeView.delegate = self;
                nodeView.zoomScale = zoomScale;
                
                if (CGPointEqualToPoint(nodeView.center, CGPointZero)) {
                    nodeView.center = [self autoLayoutNodeView:nodeView];
                }
                
                [_nodeViews addObject:nodeView];
                
                [self addSubview:nodeView];
                
                // Collect headnodes.
                if (nodeView.hasCollapsedSubStructure) {
                    [headNodes addObject:nodeView];
                }
                
                // Make treeSegment look natural.
                if (nodeView.isInCollapsedSegment) {
                    [segmentNodes addObject:nodeView];
                }
            } else {
                [NSException raise:kInternalInconsistencyException format:@"### Error: TBCollectionCanvasContentView: Internal Inconsistency: nodeView.tag %li not equal to %li", (long)nodeView.tag, (long)i];
            }
        }
    }
    [self connectNodes];
    [self sizeCanvasToFit];
    
    [self ticktockSegment:segmentNodes];
    
    // Bring headnodes to front - descending - parent first.
    for (NSInteger i=headNodes.count-1; i>=0; i--) {
        [self bringSubviewToFront:(UIView *)headNodes[i]];
    }
    
    // Cleanup.
    [headNodes removeAllObjects];
    [segmentNodes removeAllObjects];
}

- (CGPoint)autoLayoutNodeView:(TBCanvasNodeView *)nodeView
{
    CGRect frame = nodeView.frame;
    frame.origin.x = (CGRectGetMinX(self.scrollView.bounds) / zoomScale) + OUTER_FILEVIEW_MARGIN;
    frame.origin.y = (CGRectGetMinY(self.scrollView.bounds) / zoomScale) + OUTER_FILEVIEW_MARGIN;
    
    for (TBCanvasNodeView *view in _nodeViews) {
        if (CGRectIntersectsRect(frame, view.frame)) {
            
            // step to the right and keep a distance
            frame.origin.x = CGRectGetMaxX(view.frame) + OUTER_FILEVIEW_MARGIN;
            
            // if we are too right do a linebreak
            if (CGRectGetMaxX(frame) > CGRectGetMaxX(self.scrollView.bounds) / zoomScale) {
                frame.origin.x =  (CGRectGetMinX(self.scrollView.bounds) / zoomScale) + OUTER_FILEVIEW_MARGIN;
                frame.origin.y += frame.size.height + OUTER_FILEVIEW_MARGIN;
            }
        }
    }
    nodeView.frame = frame;
    
    return nodeView.center;
}

- (void)connectNodes
{
    NSSet *nodeConnections = nil;
    
    // Iterate through all nodes.
    for (TBCanvasNodeView *nodeView in _nodeViews) {
        
        if ([_canvasViewDataSource respondsToSelector:@selector(connectionsForNodeOnCanvasAtIndexPath:)]) {
            nodeConnections = [_canvasViewDataSource connectionsForNodeOnCanvasAtIndexPath:[NSIndexPath indexPathForRow:nodeView.tag inSection:0]];
        }
        
        // Iterate through all connections.
        for (TBCanvasConnectionView *nodeConnection in nodeConnections) {
            
            NSUInteger parentTag = nodeConnection.parentIndex;
            NSUInteger childTag  = nodeConnection.childIndex;
            
            TBCanvasNodeView *parentView = _nodeViews[parentTag];
            TBCanvasNodeView *childView = _nodeViews[childTag];
            
            // add a new connection and connect both
            nodeConnection.canvasNodeConnectionDelegate = self;
            nodeConnection.parentNode = parentView;
            nodeConnection.childNode = childView;
            
            // register connection in all three arrays.
            [parentView.childConnections addObject:nodeConnection];
            [childView.parentConnections addObject:nodeConnection];
            [_connectionViews addObject:nodeConnection];
            
            // set connection attributes.
            [self addSubview:nodeConnection];
            [self sendSubviewToBack:nodeConnection];
            [nodeConnection drawConnection];
        }
    }
}

- (void)clearCanvas
{
    [_segmentsBelowNode removeAllObjects];
    [_connectionViewsForFullRefresh removeAllObjects];
    
    [_connectionViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_connectionViews makeObjectsPerformSelector:@selector(reset)];
    [_connectionViews removeAllObjects];
    
    [_nodeViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_nodeViews makeObjectsPerformSelector:@selector(reset)];
    [_nodeViews removeAllObjects];
    
    [self removeConnectionHandles];
    isInConnectMode = NO;
    
    if (_temporaryConnectionView) {
        [_temporaryConnectionView removeFromSuperview];
        [_temporaryConnectionView reset];
        _temporaryConnectionView = nil;
    }
    
    if (_selectedConnectionView) {
        [_selectedConnectionView reset];
        _selectedConnectionView = nil;
    }
}

- (void)reloadCanvas
{
    [self clearCanvas];
    [self fillCanvas];
}

#pragma mark - Autoscrolling, resizing and zooming

static int     AUTOSCROLL_THRESHOLD     = 10;
static CGFloat MAX_AUTOSCROLL_DISTANCE  =  2.0;
static CGFloat AUTOSCROLL_MARGIN        =  1.0;

- (void)validateAutoscrollDistance {
    
    for (TBCanvasItemView *itemView in _autoscrollingItems) {
        
        // When the view reaches left or upper border of the view kill the timer.
        if (itemView.scaledFrame.origin.x <= 0.0) {
            autoscrollDistanceHorizontal = 0.0;
        }
        if (itemView.scaledFrame.origin.y <= 0.0) {
            autoscrollDistanceVertical  = 0.0;
        }
        
        // Keep values from exceeding minimum / maximum value.
        autoscrollDistanceHorizontal = MIN(autoscrollDistanceHorizontal,  MAX_AUTOSCROLL_DISTANCE);
        autoscrollDistanceHorizontal = MAX(autoscrollDistanceHorizontal, (MAX_AUTOSCROLL_DISTANCE * -1));
        
        autoscrollDistanceVertical   = MIN(autoscrollDistanceVertical,    MAX_AUTOSCROLL_DISTANCE);
        autoscrollDistanceVertical   = MAX(autoscrollDistanceVertical,   (MAX_AUTOSCROLL_DISTANCE * -1));
        
    }
    
    if ((autoscrollDistanceHorizontal == 0.0 && autoscrollDistanceVertical == 0.0) || _autoscrollingItems.count == 0) {
        if (_autoscrollTimer) {
            [_autoscrollTimer invalidate];
            _autoscrollTimer = nil;
            
            [_autoscrollingItems removeAllObjects];
            
            [self sizeCanvasToFit];
            [self scrollTouchedViewToVisible];
        }
    }
}

- (void)autoScrollOnEdges
{
    [self validateAutoscrollDistance];
    
    // Move the scrollview's content offset...
    CGPoint offset = self.scrollView.contentOffset;
    offset.x += autoscrollDistanceHorizontal;
    offset.y += autoscrollDistanceVertical;
    self.scrollView.contentOffset = offset;
    
    // And the touched view by the given fraction.
    
    for (TBCanvasItemView *itemView in _autoscrollingItems) {
        
        CGPoint center = itemView.center;
        center.x += autoscrollDistanceHorizontal / zoomScale;
        center.y += autoscrollDistanceVertical / zoomScale;
        itemView.center = center;
        
        if ([itemView isKindOfClass:[TBCanvasNodeView class]]) {
            
            TBCanvasNodeView *nodeView = (TBCanvasNodeView *)itemView;
            
            if (isInConnectMode) {
                TBCanvasCreateHandleView *newHandle = _createHandles[nodeView.tag];
                newHandle.center = CGPointMake(nodeView.center.x, nodeView.center.y + (nodeView.frame.size.height * 0.5));
            }
            
            NSMutableArray *segmentBelowNode = [self segmentForCanvasNodeView:nodeView];
            
            for (TBCanvasItemView *item in segmentBelowNode) {
                item.center = CGPointMake(item.center.x + autoscrollDistanceHorizontal / zoomScale, item.center.y + autoscrollDistanceVertical / zoomScale);
            }
            nodeView.segmentRect = CGRectOffset(nodeView.segmentRect, autoscrollDistanceHorizontal / zoomScale, autoscrollDistanceVertical / zoomScale);
        }
        [self moveConnectionsForItemView:itemView];
    }
}

- (float)autoscrollDistanceForProximityToEdge:(float)proximity {
    return ceilf((AUTOSCROLL_THRESHOLD - proximity) / 5.0);
}

- (void)checkAutoScrollingForCanvasItemView:(TBCanvasItemView *)itemView
{
    // Reset if nothing to scroll.
    if (_autoscrollingItems.count == 0) {
        autoscrollDistanceHorizontal = 0.0;
        autoscrollDistanceVertical   = 0.0;
    }
    
    CGRect scrollViewRect = CGRectInset(self.scrollView.bounds, AUTOSCROLL_MARGIN, AUTOSCROLL_MARGIN);
    CGRect viewTouchedRect = itemView.scaledFrame;
    
    //if ([itemView isKindOfClass:[TBCanvasNodeView class]])
    //    viewTouchedRect = ((TBCanvasNodeView *)itemView).scaledSegmentRect;
    
    float autoscrollDistanceH = 0.0;
    float autoscrollDistanceV = 0.0;
    
    if ((CGRectGetMinX(viewTouchedRect) < CGRectGetMinX(scrollViewRect)) || (CGRectGetMaxX(viewTouchedRect) > CGRectGetMaxX(scrollViewRect))
        || (CGRectGetMinY(viewTouchedRect) < CGRectGetMinY(scrollViewRect)) || (CGRectGetMaxY(viewTouchedRect) > CGRectGetMaxY(scrollViewRect))) {
        
        float distanceFromTopEdge    = CGRectGetMinY(viewTouchedRect) - CGRectGetMinY(self.scrollView.bounds);
        float distanceFromLeftEdge   = CGRectGetMinX(viewTouchedRect) - CGRectGetMinX(self.scrollView.bounds);
        float distanceFromRightEdge  = CGRectGetMaxX(self.scrollView.bounds) - CGRectGetMaxX(viewTouchedRect);
        float distanceFromBottomEdge = CGRectGetMaxY(self.scrollView.bounds) - CGRectGetMaxY(viewTouchedRect);
        
        if (distanceFromLeftEdge < AUTOSCROLL_THRESHOLD) {
            autoscrollDistanceH = [self autoscrollDistanceForProximityToEdge:distanceFromLeftEdge] * -1;
        } else if (distanceFromRightEdge < AUTOSCROLL_THRESHOLD) {
            autoscrollDistanceH = [self autoscrollDistanceForProximityToEdge:distanceFromRightEdge];
        }
        if (distanceFromTopEdge < AUTOSCROLL_THRESHOLD) {
            autoscrollDistanceV = [self autoscrollDistanceForProximityToEdge:distanceFromTopEdge] * -1;
        } else if (distanceFromBottomEdge < AUTOSCROLL_THRESHOLD) {
            autoscrollDistanceV = [self autoscrollDistanceForProximityToEdge:distanceFromBottomEdge];
        }
    }
    
    autoscrollDistanceHorizontal = MAX(autoscrollDistanceHorizontal, autoscrollDistanceH);
    
    autoscrollDistanceVertical = MAX(autoscrollDistanceVertical, autoscrollDistanceV);
    
    
    if ((autoscrollDistanceH == 0.0) && (autoscrollDistanceV == 0.0)) {
        [_autoscrollingItems removeObjectIdenticalTo:itemView];
    } else {
        if ([_autoscrollingItems containsObject:itemView] == NO) {
            [_autoscrollingItems addObject:itemView];
        }
    }
    // Reset timer when view is inside visible bounds again OR start timer if not.
    if ((autoscrollDistanceHorizontal == 0.0 && autoscrollDistanceVertical == 0.0) || _autoscrollingItems.count == 0) {
        
        if (_autoscrollTimer) {
            [_autoscrollTimer invalidate];
            _autoscrollTimer = nil;
            [_autoscrollingItems removeAllObjects];
            
            [self sizeCanvasToFit];
            [self scrollTouchedViewToVisible];
        }
        
    } else {
        
        if (_autoscrollingItems.count > 0) {
            if (_autoscrollTimer == nil) {
                _autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0) target:self selector:@selector(autoScrollOnEdges) userInfo:nil repeats:YES];
            }
        }
    }
}

- (void)scrollTouchedViewToVisible
{
    if (_viewsTouched.count == 1) {
        TBCanvasItemView *viewTouched = _viewsTouched.lastObject;
        [self.scrollView scrollRectToVisible:CGRectInset(viewTouched.scaledFrame, -OUTER_FILEVIEW_MARGIN * zoomScale, -OUTER_FILEVIEW_MARGIN * zoomScale) animated:YES];
    }
}

- (void)sizeCanvasToFit {
    
    CGSize size = {0.0, 0.0};
    
    // Get smallest possible rect around all views + outer margin.
    for (TBCanvasNodeView *nodeView in _nodeViews) {
        size.width  = MAX(CGRectGetMaxX(nodeView.scaledFrame), size.width);
        size.height = MAX(CGRectGetMaxY(nodeView.scaledFrame), size.height);
    }
    
    // Reset to default size if necessary.
    size.width  = MAX(size.width,  CONTENT_WIDTH * zoomScale);
    size.height = MAX(size.height, CONTENT_HEIGHT * zoomScale);
    
    // Reset to screen size if necessary.
    size.width  = MAX(size.width,  self.scrollView.bounds.size.width) + OUTER_CANVAS_MARGIN * zoomScale;
    size.height = MAX(size.height, self.scrollView.bounds.size.height) + OUTER_CANVAS_MARGIN * zoomScale;
    
    self.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    
    self.scrollView.contentSize = self.frame.size;
}

- (void)zoomToScale:(CGFloat)scale
{
    zoomScale = scale;
    
    // Iterate through all  TBCanvasNodeViews.
    for (TBCanvasNodeView *nodeView in _nodeViews) {
        nodeView.zoomScale = zoomScale;
    }
    
    // Iterate through all TBCanvasConnectionViews.
    for (TBCanvasConnectionView *connection in _connectionViews) {
        connection.zoomScale = zoomScale;
    }
    
    // Iterate through all  TBCanvasCreateHandles.
    for (TBCanvasCreateHandleView *handle in _createHandles) {
        handle.zoomScale = zoomScale;
    }
    
    // Iterate through all TBCanvasMoveHandleView.
    for (TBCanvasMoveHandleView *handle in _moveHandles) {
        handle.zoomScale = zoomScale;
    }
    
    // Don't forget the temporary connection if it has been set.
    if (_temporaryConnectionView) {
        _temporaryConnectionView.zoomScale = zoomScale;
    }
    
    [self sizeCanvasToFit];
}

#pragma mark - TBCanvasNodeView handling

- (void)updateNodeViewAtIndexPath:(NSIndexPath *)indexPath
{
    [[self nodeAtIndexPath:indexPath] removeFromSuperview];
    
    TBCanvasNodeView *nodeView = nil;
    
    if ([_canvasViewDataSource respondsToSelector:@selector(nodeViewOnCanvasAtIndexPath:)]) {
        nodeView = [_canvasViewDataSource nodeViewOnCanvasAtIndexPath:indexPath];
    }
    
    if (nodeView) {
        nodeView.tag = indexPath.row;
        nodeView.delegate = self;
        nodeView.frame = [_nodeViews[indexPath.row] frame];
        nodeView.zoomScale = zoomScale;
        
        _nodeViews[indexPath.row] = nodeView;
        [self addSubview:nodeView];
    }
}

- (void)insertNodeAtIndexPath:(NSIndexPath *)indexPath
{
    TBCanvasNodeView *nodeView = nil;
    
    if ([_canvasViewDataSource respondsToSelector:@selector(nodeViewOnCanvasAtIndexPath:)]) {
        nodeView = [_canvasViewDataSource nodeViewOnCanvasAtIndexPath:indexPath];
    }
    
    if (nodeView) {
        nodeView.tag = indexPath.row;
        nodeView.delegate = self;
        nodeView.zoomScale = zoomScale;
        
        [_nodeViews insertObject:nodeView atIndex:indexPath.row];
        [self addSubview:nodeView];
        
        // Reindex remaining node views
        for (NSInteger i = indexPath.row; i < _nodeViews.count; i++) {
            ((TBCanvasNodeView *)_nodeViews[i]).tag = i;
        }
        
        // Add new connection handle if necessary.
        if (isInConnectMode) {
            TBCanvasCreateHandleView *handle = [self makeCreateHandleForNodeView:nodeView];
            nodeView.connectionHandle = handle;
            
            [_createHandles insertObject:handle atIndex:handle.tag];
            
            // Reindex remaining handles
            for (NSInteger i = handle.tag; i < _createHandles.count; i++) {
                ((TBCanvasCreateHandleView *)_createHandles[i]).tag = i;
            }
            
            // Add new connection handle to node view.
            [self addSubview:handle];
        }
        
        [self sizeCanvasToFit];
    }
}

- (void)deleteNodeAtIndexPath:(NSIndexPath *)indexPath
{
    TBCanvasNodeView *nodeView = nil;
    
    nodeView = [self nodeAtIndexPath:indexPath];
    
    if (nodeView) {
        
        // Expand node when collapsed.
        if (nodeView.hasCollapsedSubStructure) {
            [self expandSegment:nodeView];
        }
        
        // Cascaded removal of parent and child connections
        for (TBCanvasConnectionView *parentConnection in nodeView.parentConnections) {
            [parentConnection removeFromSuperview];
            
            // Delete node
            [parentConnection.parentNode.connectedNodes removeObject:nodeView];
            
            // Delete connection
            [parentConnection.parentNode.childConnections removeObject:parentConnection];
            
            // Remove move handle
            TBCanvasMoveHandleView *handle = parentConnection.moveConnectionHandle;
            [handle removeFromSuperview];
            [_moveHandles removeObject:handle];
            
            // Remove connection
            [_connectionViews removeObject:parentConnection];
        }
        for (TBCanvasConnectionView *childConnection in nodeView.childConnections) {
            [childConnection removeFromSuperview];
            
            // Delete node
            [childConnection.childNode.connectedNodes removeObject:nodeView];
            
            // Delete connection
            [childConnection.childNode.parentConnections removeObject:childConnection];
            
            // Remove move handle
            TBCanvasMoveHandleView *handle = childConnection.moveConnectionHandle;
            [handle removeFromSuperview];
            [_moveHandles removeObject:handle];
            
            // Remove connection
            [_connectionViews removeObject:childConnection];
        }
        
        [_nodeViews removeObjectAtIndex:indexPath.row];
        
        // Reindex remaining node views
        for (NSInteger i = indexPath.row; i < _nodeViews.count; i++) {
            ((TBCanvasNodeView *)_nodeViews[i]).tag = i;
        }
        
        // Remove new connection handle if necessary.
        if (isInConnectMode) {
            TBCanvasCreateHandleView *handle = _createHandles[nodeView.tag];
            [handle removeFromSuperview];
            [_createHandles removeObjectAtIndex:nodeView.tag];
            
            // Reindex remaining handles
            for (NSInteger i = handle.tag; i < _createHandles.count; i++) {
                ((TBCanvasCreateHandleView *)_createHandles[i]).tag = i;
            }
        }
        
        [nodeView removeFromSuperview];
    }
}

- (TBCanvasNodeView *)nodeAtIndexPath:(NSIndexPath *)indexPath
{
    return _nodeViews[indexPath.row];
}


#pragma mark - Connection handles

- (void)toggleConnectMode
{
    if (isInConnectMode) {
        [self removeConnectionHandles];
    } else {
        [self addConnectionHandles];
    }
    isInConnectMode = !isInConnectMode;
}

- (void)addConnectionHandles
{
    // Add  TBCanvasCreateHandles
    for (TBCanvasNodeView *nodeView in _nodeViews) {
        
        if (nodeView.isInCollapsedSegment == NO) {
            
            TBCanvasCreateHandleView *handle = [self makeCreateHandleForNodeView:nodeView];
            nodeView.connectionHandle = handle;
            [_createHandles addObject:handle];
            
            [self addSubview:handle];
        }
    }
    
    // Add  TBCanvasMoveHandles
    for (TBCanvasConnectionView *connection in _connectionViews) {
        
        if (connection.isInCollapsedSegment == NO) {
            
            TBCanvasMoveHandleView *handle = [self makeMoveConnectionHandleForConnection:connection];
            connection.moveConnectionHandle = handle;
            [_moveHandles addObject:handle];
            
            [self addSubview:handle];
        }
    }
}

- (TBCanvasCreateHandleView *)makeCreateHandleForNodeView:(TBCanvasNodeView *)nodeView
{
    CGPoint handleCenter = [self convertPoint:nodeView.connectionHandleAncorPoint toView:self];
    
    TBCanvasCreateHandleView *handle = [self.canvasViewDataSource newHandleForConnectionAtPoint:handleCenter];
    handle.zoomScale = zoomScale;
    handle.nodeView = nodeView;
    handle.delegate = self;
    
    return handle;
}

- (TBCanvasMoveHandleView *)makeMoveConnectionHandleForConnection:(TBCanvasConnectionView *)connection
{
    CGPoint handleCenter = [self convertPoint:connection.visibleEndPoint fromView:connection];
    
    TBCanvasMoveHandleView *handle = [self.canvasViewDataSource moveHandleForConnectionAtPoint:handleCenter];
    handle.zoomScale = zoomScale;
    handle.connection = connection;
    handle.delegate = self;
    
    return handle;
}


- (void)removeConnectionHandles
{
    [_createHandles makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_createHandles removeAllObjects];
    
    [_moveHandles makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_moveHandles removeAllObjects];
}

#pragma mark - Drawing connections

- (void)refreshConnectionsForView:(TBCanvasNodeView *)canvasNodeView
{
    [self refreshConnections:canvasNodeView.parentConnections];
    [self refreshConnections:canvasNodeView.childConnections];
}

- (void)refreshConnections:(NSMutableArray *)connections
{
    for (TBCanvasConnectionView *canvasNodeConnection in connections) {
        [canvasNodeConnection drawConnection];
        
        if (isInConnectMode) {
            if (canvasNodeConnection.isValid) {
                TBCanvasMoveHandleView *handle = canvasNodeConnection.moveConnectionHandle;
                handle.center = [self convertPoint:canvasNodeConnection.visibleEndPoint fromView:canvasNodeConnection];
            }
        }
    }
}

- (void)refreshConnectionsOutsideSelection
{
    [self refreshConnections:_connectionViewsForFullRefresh];
}

- (void)moveConnectionsForItemView:(TBCanvasItemView *)itemView
{
    if ([itemView isKindOfClass:[TBCanvasNodeView class]]) {
        [self refreshConnectionsForView:(TBCanvasNodeView *)itemView];
        
    } else {
        
        TBCanvasConnectionView *connection = nil;
        
        if ([itemView isKindOfClass:[TBCanvasCreateHandleView class]]) {
            connection = _temporaryConnectionView;
        } else if ([itemView isKindOfClass:[TBCanvasMoveHandleView class]]) {
            connection = _selectedConnectionView;
        }
        
        connection.frame =  CGRectMake(connection.parentNode.center.x, connection.parentNode.center.y+20.0,
                                       itemView.center.x - connection.parentNode.center.x,
                                       itemView.center.y - connection.parentNode.center.y);
        
        CGPoint start = [self convertPoint:connection.parentNode.center toView:connection];
        CGPoint end   = [self convertPoint:itemView.center toView:connection];
        [connection drawConnectionFromPoint:start toPoint:end];
    }
}

#pragma mark - TBCanvasConnectionViewDelegate

- (void)removedConnectionView:(TBCanvasConnectionView *)connection atIndexPath:(NSIndexPath *)indexPath
{
    [connection removeFromSuperview];
    [connection.parentNode.connectedNodes removeObject:connection.childNode];
    [connection.parentNode.childConnections removeObject:connection];
    [connection.childNode.connectedNodes removeObject:connection.parentNode];
    [connection.childNode.parentConnections removeObject:connection];
    [_connectionViews removeObject:connection];
    
    if ([_canvasViewDelegate respondsToSelector:@selector(didRemoveConnectionAtIndexPath:)]) {
        [_canvasViewDelegate didRemoveConnectionAtIndexPath:indexPath];
    }
}

#pragma mark - Processing multiple items

- (NSMutableArray *)collectSegmentBelowNode:(TBCanvasNodeView *)nodeView
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (TBCanvasConnectionView *connection in nodeView.childConnections) {
        if (connection.isValid) {
            [array addObject:connection];
            
            // Avoid circular references to another parent view or to viewTouched.
            if ([array containsObject:connection.childNode] == NO && [_viewsTouched containsObject:connection.childNode] == NO) {
                [array addObject:connection.childNode];
                
                if (isInConnectMode) {
                    if (connection.childNode.connectionHandle) {
                        [array addObject:connection.childNode.connectionHandle];
                    }
                }
                
                [array addObjectsFromArray:[self collectSegmentBelowNode:connection.childNode]];
            }
            if (isInConnectMode) {
                if (connection.moveConnectionHandle) {
                    [array addObject:connection.moveConnectionHandle];
                }
            }
        }
    }
    return array;
}

- (CGRect)segmentRectangleFromSegment:(NSArray *)treeSegment
{
    CGRect segmentRect = CGRectZero;
    for (TBCanvasItemView *itemView in treeSegment) {
        segmentRect = CGRectUnion(itemView.frame, segmentRect);
    }
    return segmentRect;
}

- (void)collectConnectionsForFullRefresh
{
    for (NSMutableArray *segmentBelowNode in _segmentsBelowNode.allValues) {
        for (TBCanvasItemView *nodeItem in segmentBelowNode) {
            if ([nodeItem isKindOfClass:[TBCanvasNodeView class]]) {
                TBCanvasNodeView *nodeView = (TBCanvasNodeView *)nodeItem;
                if (nodeView.parentConnections.count > 1) {
                    for (TBCanvasConnectionView *parentConnection in nodeView.parentConnections) {
                        if ([segmentBelowNode containsObject:parentConnection] == NO) {
                            [_connectionViewsForFullRefresh addObject:parentConnection];
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - Collapsing a treeSegment

- (void)collapseSegment:(TBCanvasNodeView *)nodeView
{
    // Collect collapseable treeSegment
    NSMutableArray *segmentBelowNode = [self segmentForCanvasNodeView:nodeView];
    nodeView.segmentRect = CGRectUnion(nodeView.frame, [self segmentRectangleFromSegment:segmentBelowNode]);
    nodeView.hasCollapsedSubStructure = YES;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nodeView.tag inSection:0];
    if ([_canvasViewDelegate respondsToSelector:@selector(didCollapseNodeOnCanvasAtIndexPath:nodeView:)]) {
        [_canvasViewDelegate didCollapseNodeOnCanvasAtIndexPath:indexPath nodeView:nodeView];
    }
    
    if ([_canvasViewDelegate respondsToSelector:@selector(didCollapseConnectionsOnCanvasUnderNodeView:atIndexPath:)]) {
        [_canvasViewDelegate didCollapseConnectionsOnCanvasUnderNodeView:nodeView atIndexPath:indexPath];
    }
    
    // Collapse segment
    for (TBCanvasItemView *nodeItem in segmentBelowNode) {
        
        // if node is not yet in a collapsed (sub)treeSegment.
        if (nodeItem.isInCollapsedSegment == NO) {
            nodeItem.deltaToCollapsedNode = CGSizeMake(nodeItem.center.x - nodeView.center.x, nodeItem.center.y - nodeView.center.y);
            nodeItem.isInCollapsedSegment = YES;
            
            if ([nodeItem isKindOfClass:[TBCanvasNodeView class]]) {
                ((TBCanvasNodeView *)nodeItem).headNodeTag = nodeView.tag;
            }
        }
        [nodeItem setCenter:nodeView.center animated:YES];
    }
    
    [self ticktockSegment:segmentBelowNode];
    
    // Redraw connections witin the collapsed structure.
    for (TBCanvasConnectionView *connection in segmentBelowNode) {
        if ([connection isKindOfClass:[TBCanvasConnectionView class]]) {
            [connection drawConnection];
        }
    }
    // Redraw connections to external node views.
    [self collectConnectionsForFullRefresh];
    [self refreshConnectionsOutsideSelection];
    
    [self saveCollapsedSegment:segmentBelowNode];
    
    [self bringSubviewToFront:nodeView];
    [self sizeCanvasToFit];
}

- (void)ticktockSegment:(NSArray *)treeSegment
{
    int ticktock = 0;
    
    for (TBCanvasItemView *nodeItem in treeSegment) {
        
        // Swing the visible node views to a natural treeSegment.
        if ([nodeItem isKindOfClass:[TBCanvasNodeView class]]) {
            srand48(clock());
            CGFloat random = ((1.0 + rand()%10) / 10.0);
            if (ticktock++ % 2 == 0) random *= -1.0;
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4 * 0.1 / random);
            nodeItem.transform = transform;
        }
    }
}

- (void)saveCollapsedSegment:(NSMutableArray *)collapsedSegment
{
    // Collect nodeviews and notify delegate.
    NSMutableArray *collapsedNodeViews = [[NSMutableArray alloc] init];
    NSMutableArray *collapsedNodeIndexPaths = [[NSMutableArray alloc] init];
    
    for (TBCanvasItemView *item in collapsedSegment) {
        
        if ([item isKindOfClass:[TBCanvasNodeView class]]) {
            
            TBCanvasNodeView *nodeView = (TBCanvasNodeView *)item;
            [collapsedNodeViews addObject:nodeView];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:item.tag inSection:0];
            [collapsedNodeIndexPaths addObject:indexPath];
            
            if ([_canvasViewDelegate respondsToSelector:@selector(didCollapseConnectionsOnCanvasUnderNodeView:atIndexPath:)]) {
                [_canvasViewDelegate didCollapseConnectionsOnCanvasUnderNodeView:nodeView atIndexPath:indexPath];
            }
        }
    }
    
    if ([_canvasViewDelegate respondsToSelector:@selector(didCollapseSegmentOfNodesOnCanvasWithIndexPaths:nodeViews:)]) {
        [_canvasViewDelegate didCollapseSegmentOfNodesOnCanvasWithIndexPaths:collapsedNodeIndexPaths nodeViews:collapsedNodeViews];
    }
}

#pragma mark - Expanding a treeSegment

- (void)expandSegment:(TBCanvasNodeView *)nodeView
{
    // Collect collapseable treeSegment
    NSMutableArray *segmentBelowNode = [self segmentForCanvasNodeView:nodeView];
    nodeView.segmentRect = CGRectUnion(nodeView.frame, [self segmentRectangleFromSegment:segmentBelowNode]);
    
    // Expand segment - except other collapsed subnodes.
    [self expandSegment:nodeView headNode:nodeView expandSubNode:YES];
    nodeView.hasCollapsedSubStructure = NO;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nodeView.tag inSection:0];
    if ([_canvasViewDelegate respondsToSelector:@selector(didExpandNodeOnCanvasAtIndexPath:nodeView:)]) {
        [_canvasViewDelegate didExpandNodeOnCanvasAtIndexPath:indexPath nodeView:nodeView];
    }
    
    if ([_canvasViewDelegate respondsToSelector:@selector(didExpandConnectionsOnCanvasUnderNodeView:atIndexPath:)]) {
        [_canvasViewDelegate didExpandConnectionsOnCanvasUnderNodeView:nodeView atIndexPath:indexPath];
    }
    
    // Redraw connections to external node views.
    [self collectConnectionsForFullRefresh];
    [self refreshConnectionsOutsideSelection];
    
    [self saveExpandedSegment:segmentBelowNode];
    
    [self bringSubviewToFront:nodeView];
    [self sizeCanvasToFit];
}

- (void)expandItem:(TBCanvasItemView *)item headNode:(TBCanvasNodeView *)headNode expandAsSubnode:(BOOL)expandAsSubnode
{
    if (expandAsSubnode) {
        
        /*
         // If this is not the right treeSegment (cross reference) - shift to real parent.
         if (([item isKindOfClass:[TBCanvasNodeView class]]) && (((TBCanvasNodeView *)item).headNodeTag != headNode.tag)) {
         
         TBCanvasNodeView *nodeView = (TBCanvasNodeView *)item;
         TBCanvasNodeView *realHeadNode = [_nodeViews objectAtIndex:nodeView.headNodeTag];
         nodeView.center = realHeadNode.center;
         
         } else {
         */
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(0.0);
        item.transform = transform;
        
        CGPoint center = CGPointMake(headNode.center.x + item.deltaToCollapsedNode.width, headNode.center.y + item.deltaToCollapsedNode.height);
        [item setCenter:center animated:YES];
        
        item.deltaToCollapsedNode = CGSizeMake(0.0, 0.0);
        item.isInCollapsedSegment = NO;
        
        if ([item isKindOfClass:[TBCanvasNodeView class]]) {
            ((TBCanvasNodeView *)item).headNodeTag = -1;
        }
        //}
        
    } else
        [item setCenter:headNode.center animated:YES];
}

- (void)expandSegment:(TBCanvasNodeView *)nodeView headNode:(TBCanvasNodeView *)headNode expandSubNode:(BOOL)expandSubnode
{
    for (TBCanvasConnectionView *connection in nodeView.childConnections) {
        
        // Ignore connections outside collapsed segment.
        if (connection.isInCollapsedSegment) {
            
            [self expandItem:connection headNode:headNode expandAsSubnode:expandSubnode];
            
            // Avoid circular references to another parent view or to viewTouched.
            NSMutableArray *segmentBelowNode = [self segmentForCanvasNodeView:nodeView];
            if ([segmentBelowNode containsObject:connection.childNode]) {
                
                // Ignore child nodes outside collapsed segment.
                //if ((connection.childNode.isInCollapsedSegment) && (connection.childNode.headNodeTag == headNode.tag)) {
                if (connection.childNode.isInCollapsedSegment) {
                    [self expandItem:connection.childNode headNode:headNode expandAsSubnode:expandSubnode];
                    
                    if (isInConnectMode) {
                        [self expandItem:connection.childNode.connectionHandle headNode:headNode expandAsSubnode:expandSubnode];
                    }
                    
                    if (expandSubnode == YES) {
                        
                        // Expand items in relation to subnode.
                        if (connection.childNode.hasCollapsedSubStructure == NO) {
                            [self expandSegment:connection.childNode headNode:headNode expandSubNode:YES];
                        } else {
                            [self expandSegment:connection.childNode headNode:connection.childNode expandSubNode:NO];
                        }
                        
                    } else {
                        
                        // Expand items in relation to head node.
                        [self expandSegment:connection.childNode headNode:headNode expandSubNode:NO];
                    }
                }
            }
            if (isInConnectMode) {
                [self expandItem:connection.moveConnectionHandle headNode:headNode expandAsSubnode:expandSubnode];
            }
        }
    }
}

- (void)saveExpandedSegment:(NSMutableArray *)treeSegment
{
    // Collect nodeviews and notify delegate.
    NSMutableArray *expandedNodeViews = [[NSMutableArray alloc] init];
    NSMutableArray *expandedNodeIndexPaths = [[NSMutableArray alloc] init];
    
    for (TBCanvasNodeView *item in treeSegment) {
        
        if ([item isKindOfClass:[TBCanvasNodeView class]]) {
            
            TBCanvasNodeView *nodeView = (TBCanvasNodeView *)item;
            
            [expandedNodeViews addObject:nodeView];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nodeView.tag inSection:0];
            [expandedNodeIndexPaths addObject:indexPath];
            
            if ([_canvasViewDelegate respondsToSelector:@selector(didExpandConnectionsOnCanvasUnderNodeView:atIndexPath:)]) {
                [_canvasViewDelegate didExpandConnectionsOnCanvasUnderNodeView:nodeView atIndexPath:indexPath];
            }
        }
    }
    
    if ([_canvasViewDelegate respondsToSelector:@selector(didExpandSegmentOfNodesOnCanvasWithIndexPaths:nodeViews:)]) {
        [_canvasViewDelegate didExpandSegmentOfNodesOnCanvasWithIndexPaths:expandedNodeIndexPaths nodeViews:expandedNodeViews];
    }
}

#pragma mark - Menu handling

- (void)scheduleMenuForItemView:(TBCanvasItemView *)canvasItemView
{
    [self killMenuTimer];
    if (_menuTimer == nil) {
        _menuTimer = [NSTimer scheduledTimerWithTimeInterval:(0.3) target:self selector:@selector(showMenu:) userInfo:canvasItemView repeats:NO];
    }
}

- (void)showMenu:(NSTimer *)timer
{
    // Present menue -delete -collapse / expand
	[self hideMenu];
    
    _viewWithMenu = (TBCanvasNodeView *)timer.userInfo;
    
    [self becomeFirstResponder];
    [self configureMenu];
    
    CGRect menuRect = CGRectMake(_viewWithMenu.center.x - _viewWithMenu.touchOffset.width, _viewWithMenu.center.y - _viewWithMenu.touchOffset.height - 50.0, 3.0, 1.0);
    [_menuController setTargetRect:menuRect inView:self];
    [_menuController setMenuVisible:YES animated:YES];
    
    [self killMenuTimer];
}

- (void)hideMenu
{
    if ([_menuController isMenuVisible]) {
		[_menuController setMenuVisible:NO animated:YES];
        _viewWithMenu = nil;
    }
}

- (void)killMenuTimer
{
    // Kill timer
    if (_menuTimer) {
        [_menuTimer invalidate];
        _menuTimer = nil;
    }
}

// Touch handling, tile selection, and menu/pasteboard.
- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    // collapse
    if (action == @selector(collapse:)) {
        return (_viewWithMenu.hasCollapsedSubStructure == NO && _viewWithMenu.childConnections.count > 0);
    }
    
    // expand
    if (action == @selector(expand:)) {
        return (_viewWithMenu.hasCollapsedSubStructure && _viewWithMenu.childConnections.count > 0);
    }
    
	if (action == @selector(delete:)) {
		return YES;
    }
    
    return NO;
}

- (void)collapse:(id)sender
{
    [self collapseSegment:_viewWithMenu];
    
    // Reset after the animation has finished.
    [self performSelector:@selector(setViewWithMenu:) withObject:nil afterDelay:0.3];
}

- (void)expand:(id)sender
{
    [self expandSegment:_viewWithMenu];
    
    // Reset after the animation has finished.
    [self performSelector:@selector(setViewWithMenu:) withObject:nil afterDelay:0.3];
}

- (void)delete:(id)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_viewWithMenu.tag inSection:0];
    
    if (_viewWithMenu.hasCollapsedSubStructure) {
        [self expandSegment:_viewWithMenu];
    }
    
    [self deleteNodeAtIndexPath:indexPath];
    
    if ([_canvasViewDelegate respondsToSelector:@selector(didDeleteNodeOnCanvasAtIndexPath:)]) {
        [_canvasViewDelegate didDeleteNodeOnCanvasAtIndexPath:indexPath];
    }
}

#pragma mark - Touch handling - external

- (BOOL)isProcessingViews
{
    return (_viewsTouched.count > 0);
}

- (BOOL)isInSingleTouchMode
{
    return ((_temporaryConnectionView) || (_selectedConnectionView));
}

- (NSMutableArray *)segmentForCanvasNodeView:(TBCanvasNodeView *)canvasNodeView
{
    NSString *key = [NSString stringWithFormat:@"%li", (long)canvasNodeView.tag];
    NSMutableArray *segmentBelowNode = _segmentsBelowNode[key];
    
    if (segmentBelowNode == nil) {
        segmentBelowNode = [self collectSegmentBelowNode:canvasNodeView];
        _segmentsBelowNode[key] = segmentBelowNode;
    }
    
    return segmentBelowNode;
}

#pragma mark - TBCanvasNodeViewDelegate

- (BOOL)canProcessCanvasNodeView:(TBCanvasNodeView *)canvasNodeView
{
    return ([self isInSingleTouchMode] == NO);
}

- (void)canvasNodeView:(TBCanvasNodeView *)canvasNodeView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    location.x += canvasNodeView.touchOffset.width;
    location.y += canvasNodeView.touchOffset.height;
    
    // Set view.
    [_viewsTouched addObject:canvasNodeView];
    
    [self bringSubviewToFront:canvasNodeView];
    [canvasNodeView setSelected:YES];
    
    if (canvasNodeView.hasCollapsedSubStructure) {
        
        NSMutableArray *segmentBelowNode = [self segmentForCanvasNodeView:canvasNodeView];
        canvasNodeView.segmentRect = CGRectUnion(canvasNodeView.frame, [self segmentRectangleFromSegment:segmentBelowNode]);
        
        if (segmentBelowNode.count > 0) {
            [segmentBelowNode makeObjectsPerformSelector:@selector(setSelected:) withObject:@"YES"];
        }
    }
    [self collectConnectionsForFullRefresh];
    
    if (_menuEnabled) {
        [self scheduleMenuForItemView:canvasNodeView];
    }
}

- (void)canvasNodeView:(TBCanvasNodeView *)canvasNodeView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    location.x += canvasNodeView.touchOffset.width;
    location.y += canvasNodeView.touchOffset.height;
    
    CGPoint delta = CGPointMake(location.x - canvasNodeView.center.x, location.y - canvasNodeView.center.y);
    canvasNodeView.center = location;
    isMovingCanvasNodeViews = YES;
    
    [self killMenuTimer];
    
    if (isInConnectMode) {
        TBCanvasCreateHandleView *handle = _createHandles[canvasNodeView.tag];
        handle.center = CGPointMake(canvasNodeView.center.x, canvasNodeView.center.y + (canvasNodeView.frame.size.height / 2.0));
    }
    
    if (canvasNodeView.hasCollapsedSubStructure) {
        
        NSMutableArray *segmentBelowNode = [self segmentForCanvasNodeView:canvasNodeView];
        canvasNodeView.segmentRect = CGRectUnion(canvasNodeView.frame, [self segmentRectangleFromSegment:segmentBelowNode]);
        
        for (TBCanvasItemView *item in segmentBelowNode) {
            item.center = CGPointMake(item.center.x + delta.x, item.center.y + delta.y);
        }
        
        canvasNodeView.segmentRect = CGRectOffset(canvasNodeView.segmentRect, delta.x, delta.y);
        
        [self refreshConnectionsOutsideSelection];
    }
    
    [self moveConnectionsForItemView:canvasNodeView];
    [self checkAutoScrollingForCanvasItemView:canvasNodeView];
}

- (void)canvasNodeView:(TBCanvasNodeView *)canvasNodeView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    location.x += canvasNodeView.touchOffset.width;
    location.y += canvasNodeView.touchOffset.height;
    
    // Check if view is outside left or top border of canvas and correct if necessary.
    location.x = MAX(location.x, OUTER_CANVAS_MARGIN);
    location.y = MAX(location.y, OUTER_CANVAS_MARGIN);
    canvasNodeView.center = location;
    
    NSMutableArray *segmentBelowNode = nil;
    if (canvasNodeView.hasCollapsedSubStructure) {
        
        segmentBelowNode = [self segmentForCanvasNodeView:canvasNodeView];
        canvasNodeView.segmentRect = CGRectUnion(canvasNodeView.frame, [self segmentRectangleFromSegment:segmentBelowNode]);
    }
    
    if (isMovingCanvasNodeViews == NO) {
        
        if (_viewWithMenu == nil) {
            [self killMenuTimer];
            
            if ([_canvasViewDelegate respondsToSelector:@selector(didSelectNodeOnCanvasAtIndexPath:)]) {
                [_canvasViewDelegate didSelectNodeOnCanvasAtIndexPath:[NSIndexPath indexPathForRow:canvasNodeView.tag inSection:0]];
            }
        }
    } else {
        
        if ([_canvasViewDelegate respondsToSelector:@selector(didMoveNodeOnCanvasAtIndexPath:nodeView:)]) {
            [_canvasViewDelegate didMoveNodeOnCanvasAtIndexPath:[NSIndexPath indexPathForRow:canvasNodeView.tag inSection:0] nodeView:canvasNodeView];
        }
        
        if (isInConnectMode) {
            TBCanvasCreateHandleView *handle = _createHandles[canvasNodeView.tag];
            handle.center = CGPointMake(canvasNodeView.center.x, canvasNodeView.center.y + (canvasNodeView.frame.size.height / 2.0));
            [self bringSubviewToFront:_createHandles[canvasNodeView.tag]];
            
            for (TBCanvasConnectionView *connectionView in canvasNodeView.parentConnections) {
                [self bringSubviewToFront:connectionView.moveConnectionHandle];
            }
        }
        
        [self sizeCanvasToFit];
        [self scrollTouchedViewToVisible];
        
        if (canvasNodeView.hasCollapsedSubStructure) {
            
            NSMutableArray *segmentOfNodeViews = [[NSMutableArray alloc] init];
            for (TBCanvasNodeView *nodeView in segmentBelowNode) {
                if ([nodeView isKindOfClass:[TBCanvasNodeView class]]) {
                    [segmentOfNodeViews addObject:nodeView];
                }
            }
            if ([_canvasViewDelegate respondsToSelector:@selector(didMoveSegmentOfNodesOnCanvasWithIndexPaths:nodeViews:)]) {
                [_canvasViewDelegate didMoveSegmentOfNodesOnCanvasWithIndexPaths:nil nodeViews:segmentOfNodeViews];
            }
        }
    }
    
    [segmentBelowNode makeObjectsPerformSelector:@selector(setSelected:) withObject:nil];
    
    [self moveConnectionsForItemView:canvasNodeView];
    [_connectionViewsForFullRefresh removeAllObjects];
    
    [canvasNodeView setSelected:NO];
    
    isMovingCanvasNodeViews = NO;
    [_autoscrollTimer invalidate];
    
    [_viewsTouched removeObject:canvasNodeView];
    [_autoscrollingItems removeObject:canvasNodeView];
}

- (void)canvasNodeView:(TBCanvasNodeView *)canvasNodeView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self moveConnectionsForItemView:canvasNodeView];
    
    TBCanvasCreateHandleView *handle = _createHandles[canvasNodeView.tag];
    handle.center = CGPointMake(canvasNodeView.center.x, canvasNodeView.center.y + (canvasNodeView.frame.size.height / 2.0));
    [self bringSubviewToFront:_createHandles[canvasNodeView.tag]];
    
    for (TBCanvasConnectionView *connectionView in canvasNodeView.parentConnections) {
        [self bringSubviewToFront:connectionView.moveConnectionHandle];
    }
    
    [self sizeCanvasToFit];
    [self scrollTouchedViewToVisible];
    
    [_viewsTouched removeObject:canvasNodeView];
    [_autoscrollingItems removeObject:canvasNodeView];
}

#pragma mark - TBCanvasCreateHandleViewDelegate

- (BOOL)canProcessCanvasCreateHandle:(TBCanvasCreateHandleView *)canvasCreateHandle
{
    if ([self isInSingleTouchMode]) {
        return (_viewsTouched[0] == canvasCreateHandle);
    }
    
    if ([self isProcessingViews]) {
        return NO;
    }
    
    return YES;
}

- (void)canvasCreateHandle:(TBCanvasCreateHandleView *)canvasCreateHandle touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    
    _lockedToSingleTouch = YES;
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    location.x += canvasCreateHandle.touchOffset.width;
    location.y += canvasCreateHandle.touchOffset.height;
    
    [_viewsTouched addObject:canvasCreateHandle];
    [canvasCreateHandle setHighlighted:YES];
    
    // Add the temporary connection object.
    TBCanvasNodeView *parentView = _nodeViews[canvasCreateHandle.tag];
    _temporaryConnectionView = [self.canvasViewDataSource newConectionForNodeOnCanvasAtIndexPath:[NSIndexPath indexPathForRow:parentView.tag inSection:0]];
    _temporaryConnectionView.canvasNodeConnectionDelegate = self;
    _temporaryConnectionView.parentNode = parentView;
    _temporaryConnectionView.zoomScale = zoomScale;
    [self addSubview:_temporaryConnectionView];
    
    _temporaryConnectionView.frame =  CGRectMake(_temporaryConnectionView.parentNode.center.x, _temporaryConnectionView.parentNode.center.y,
                                             location.x - _temporaryConnectionView.parentNode.center.x,
                                             location.y - _temporaryConnectionView.parentNode.center.y);
    
    CGPoint start = [self convertPoint:_temporaryConnectionView.parentNode.center toView:_temporaryConnectionView];
    CGPoint end   = [self convertPoint:location toView:_temporaryConnectionView];
    [_temporaryConnectionView drawConnectionFromPoint:start toPoint:end];
}

- (void)canvasCreateHandle:(TBCanvasCreateHandleView *)canvasCreateHandle touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    location.x += [canvasCreateHandle touchOffset].width;
    location.y += [canvasCreateHandle touchOffset].height;
    
    canvasCreateHandle.center = location;
    isMovingCanvasNodeViews = YES;
    
    _temporaryConnectionView.frame =  CGRectMake(_temporaryConnectionView.parentNode.center.x, _temporaryConnectionView.parentNode.center.y,
                                             location.x - _temporaryConnectionView.parentNode.center.x,
                                             location.y - _temporaryConnectionView.parentNode.center.y);
    
    CGPoint start = [self convertPoint:_temporaryConnectionView.parentNode.center toView:_temporaryConnectionView];
    CGPoint end   = [self convertPoint:location toView:_temporaryConnectionView];
    [_temporaryConnectionView drawConnectionFromPoint:start toPoint:end];
    
    for (TBCanvasNodeView *nodeView in _nodeViews) {
        
        if ((CGRectIntersectsRect(nodeView.frame, canvasCreateHandle.frame))  && (nodeView != _temporaryConnectionView.parentNode) && (nodeView.isInCollapsedSegment == NO)) {
            if (_connectableNodeView) {
                if (_connectableNodeView != (TBCanvasNodeView *)nodeView) {
                    [_connectableNodeView setSelected:NO];
                    _connectableNodeView = nil;
                    _connectableNodeView = (TBCanvasNodeView *)nodeView;
                    [_connectableNodeView setSelected:YES];
                    goto bail;
                    
                } else {
                    goto bail;
                }
                
            } else {
                _connectableNodeView = (TBCanvasNodeView *)nodeView;
                [_connectableNodeView setSelected:YES];
                goto bail;
            }
            
        }
    }
    
    if (_connectableNodeView) {
        [_connectableNodeView setSelected:NO];
        _connectableNodeView = nil;
    }
    
bail:
    [self checkAutoScrollingForCanvasItemView:canvasCreateHandle];
}

- (void)canvasCreateHandle:(TBCanvasCreateHandleView *)canvasCreateHandle touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    
    if (_connectableNodeView) {
        TBCanvasNodeView *parentView = _temporaryConnectionView.parentNode;
        
        // Add a new valid connection.
        TBCanvasConnectionView *connection = [self.canvasViewDataSource newConectionForNodeOnCanvasAtIndexPath:[NSIndexPath indexPathForRow:parentView.tag inSection:0]];
        connection.canvasNodeConnectionDelegate = self;
        connection.zoomScale = zoomScale;
        
        connection.parentNode = parentView;
        connection.childNode = _connectableNodeView;
        connection.tag = connection.parentNode.childConnections.count;
        
        [parentView.childConnections addObject:connection];
        [_connectableNodeView.parentConnections addObject:connection];
        [_connectionViews addObject:connection];
        
        [self addSubview:connection];
        [self sendSubviewToBack:connection];
        
        [connection drawConnection];
        
        // Add new invisible handle.
        TBCanvasMoveHandleView *moveHandle = [self makeMoveConnectionHandleForConnection:connection];
        [_moveHandles addObject:moveHandle];
        
        connection.moveConnectionHandle = moveHandle;
        
        [self bringSubviewToFront:moveHandle];
        [self addSubview:moveHandle];
        
        [_connectableNodeView setSelected:NO];
        _connectableNodeView = nil;
        
        NSIndexPath *parentIndex = [NSIndexPath indexPathForRow:connection.parentNode.tag inSection:0];
        NSIndexPath *childIndex = [NSIndexPath indexPathForRow:connection.childNode.tag inSection:0];
        
        if ([_canvasViewDelegate respondsToSelector:@selector(didAddConnectionAtIndexPath:andNodeAtIndexPath:)]) {
            [_canvasViewDelegate didAddConnectionAtIndexPath:parentIndex andNodeAtIndexPath:childIndex];
        }
    }
    
    canvasCreateHandle.center = [self convertPoint:_temporaryConnectionView.parentNode.connectionHandleAncorPoint toView:self];
    
    [canvasCreateHandle setHighlighted:NO];
    [_temporaryConnectionView removeFromSuperview];
    _temporaryConnectionView = nil;
    _connectableNodeView = nil;
    
    [self sizeCanvasToFit];
    [self scrollTouchedViewToVisible];
    
    [_viewsTouched removeObject:canvasCreateHandle];
    [_autoscrollingItems removeObject:canvasCreateHandle];
    
    _lockedToSingleTouch = NO;
}

- (void)canvasCreateHandle:(TBCanvasCreateHandleView *)canvasCreateHandle touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    isMovingCanvasNodeViews = NO;
    [_autoscrollTimer invalidate];
    [self sizeCanvasToFit];
    
    canvasCreateHandle.center = [self convertPoint:_temporaryConnectionView.parentNode.connectionHandleAncorPoint toView:self];
    [_temporaryConnectionView removeFromSuperview];
    _temporaryConnectionView = nil;
    _connectableNodeView = nil;
    
    [self scrollTouchedViewToVisible];
    
    [canvasCreateHandle setSelected:NO];
    
    [_connectionViewsForFullRefresh removeAllObjects];
    
    [_viewsTouched removeObject:canvasCreateHandle];
    [_autoscrollingItems removeObject:canvasCreateHandle];
    
    _lockedToSingleTouch = NO;
}

#pragma mark - TBCanvasMoveHandleViewDelegate

- (BOOL)canProcessCanvasMoveHandle:(TBCanvasMoveHandleView *)canvasMoveHandle
{
    if ([self isInSingleTouchMode]) {
        return (_viewsTouched[0] == canvasMoveHandle);
    }
    
    if ([self isProcessingViews]) {
        return NO;
    }
    
    return YES;
}

- (void)canvasMoveHandle:(TBCanvasMoveHandleView *)canvasMoveHandle touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    
    _lockedToSingleTouch = YES;
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    location.x += canvasMoveHandle.touchOffset.width;
    location.y += canvasMoveHandle.touchOffset.height;
    
    [_viewsTouched addObject:canvasMoveHandle];
    [canvasMoveHandle setHighlighted:YES];
    
    // Set the selected connection object.
    _selectedConnectionView = canvasMoveHandle.connection;
    
    CGPoint start = [self convertPoint:_selectedConnectionView.parentNode.center toView:_selectedConnectionView];
    CGPoint end   = [self convertPoint:location toView:_selectedConnectionView];
    
    [_selectedConnectionView drawConnectionFromPoint:start toPoint:end];
}

- (void)canvasMoveHandle:(TBCanvasMoveHandleView *)canvasMoveHandle touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    location.x += canvasMoveHandle.touchOffset.width;
    location.y += canvasMoveHandle.touchOffset.height;
    
    canvasMoveHandle.center = location;
    isMovingCanvasNodeViews = YES;
    
    
    _selectedConnectionView.frame =  CGRectMake(_selectedConnectionView.parentNode.center.x, _selectedConnectionView.parentNode.center.y+20.0,
                                            location.x - _selectedConnectionView.parentNode.center.x,
                                            location.y - _selectedConnectionView.parentNode.center.y);
    
    CGPoint start = [self convertPoint:_selectedConnectionView.parentNode.center toView:_selectedConnectionView];
    CGPoint end   = [self convertPoint:location toView:_selectedConnectionView];
    [_selectedConnectionView drawConnectionFromPoint:start toPoint:end];
    
    for (TBCanvasNodeView *nodeView in _nodeViews) {
        
        if ((CGRectIntersectsRect(nodeView.frame, canvasMoveHandle.frame)) && (nodeView != _selectedConnectionView.parentNode) && (nodeView.isInCollapsedSegment == NO)) {
            if (_connectableNodeView) {
                if (_connectableNodeView != (TBCanvasNodeView *)nodeView) {
                    [_connectableNodeView setSelected:NO];
                    _connectableNodeView = nil;
                    _connectableNodeView = (TBCanvasNodeView *)nodeView;
                    [_connectableNodeView setSelected:YES];
                    goto bail2;
                    
                } else {
                    goto bail2;
                }
                
            } else {
                _connectableNodeView = (TBCanvasNodeView *)nodeView;
                [_connectableNodeView setSelected:YES];
                goto bail2;
            }
            
        }
    }
    
    if (_connectableNodeView) {
        [_connectableNodeView setSelected:NO];
        _connectableNodeView = nil;
    }
    
bail2:
    [self checkAutoScrollingForCanvasItemView:canvasMoveHandle];
}

- (void)canvasMoveHandle:(TBCanvasMoveHandleView *)canvasMoveHandle touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    
    if (_connectableNodeView) {
        // Move connection to another childview
        NSIndexPath *connectionIndexPath = [_selectedConnectionView indexPath];
        NSIndexPath *newChildIndexPath = [NSIndexPath indexPathForRow:_connectableNodeView.tag inSection:0];
        
        [_selectedConnectionView.childNode.connectedNodes removeObject:_selectedConnectionView.parentNode];
        [_selectedConnectionView.childNode.parentConnections removeObject:_selectedConnectionView];
        _selectedConnectionView.childNode = _connectableNodeView;
        
        [_selectedConnectionView.childNode.connectedNodes addObject:_selectedConnectionView.parentNode];
        [_selectedConnectionView.childNode.parentConnections addObject:_selectedConnectionView];
        [_selectedConnectionView drawConnection];
        [_connectableNodeView setSelected:NO];
        _connectableNodeView = nil;
        
        if ([_canvasViewDelegate respondsToSelector:@selector(didMoveConnectionAtNode:toNewChildIndexPath:)]) {
            [_canvasViewDelegate didMoveConnectionAtNode:connectionIndexPath toNewChildIndexPath:newChildIndexPath];
        }
        
        canvasMoveHandle.center = [self convertPoint:_selectedConnectionView.visibleEndPoint fromView:_selectedConnectionView];
        [canvasMoveHandle setHighlighted:NO];
        _selectedConnectionView = nil;
        _connectableNodeView = nil;
        
    } else {
        // Remove connection completely
        [_selectedConnectionView suspenderSnapAnimation];
        _selectedConnectionView = nil;
        _connectableNodeView = nil;
        [canvasMoveHandle removeFromSuperview];
        [_moveHandles removeObject:canvasMoveHandle];
    }
    
    [self sizeCanvasToFit];
    [self scrollTouchedViewToVisible];
    
    isMovingCanvasNodeViews = NO;
    [_autoscrollTimer invalidate];
    
    [_viewsTouched removeObject:canvasMoveHandle];
    [_autoscrollingItems removeObject:canvasMoveHandle];
    
    _lockedToSingleTouch = NO;
}

- (void)canvasMoveHandle:(TBCanvasMoveHandleView *)canvasMoveHandle touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    isMovingCanvasNodeViews = NO;
    [_autoscrollTimer invalidate];
    
    [self sizeCanvasToFit];
    [self scrollTouchedViewToVisible];
    
    canvasMoveHandle.center = [self convertPoint:_selectedConnectionView.visibleEndPoint fromView:_selectedConnectionView];
    [canvasMoveHandle setHighlighted:NO];
    _selectedConnectionView = nil;
    _connectableNodeView = nil;
    
    [_viewsTouched removeObject:canvasMoveHandle];
    [_autoscrollingItems removeObject:canvasMoveHandle];
    
    _lockedToSingleTouch = NO;
}

@end
