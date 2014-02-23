//
//  CollectionCanvasView.m
//
//  Created by Julian Krumow on 23.01.12.
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


#import "CollectionCanvasView.h"
#import "CollectionCanvasScrollView.h"
#import "CanvasNewConnectionHandle.h"
#import "CanvasMoveConnectionHandle.h"

@interface CollectionCanvasView()
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
@property (nonatomic, strong) NSMutableArray *connections;

// Stores all handles to establish a new connection.
@property (nonatomic, strong) NSMutableArray *moreHandles;

// Stores all handles to move an established connection.
@property (nonatomic, strong) NSMutableArray *moveHandles;

// Stores all CanvasNodeItems that are part of the selected tree segment and will be processed with the head node.
@property (nonatomic, strong) NSMutableDictionary *segmentsBelowNode;

// Stores all CanvasNodeConnection of a node view inside a selected tree segment wich point to a node view outside the segment.
@property (nonatomic, strong) NSMutableArray *connectionsForFullRefresh;

// A connection that is used when the user wants to establish a new connection between two CanvasNodeViews.
@property (nonatomic, strong) CanvasNodeConnection *temporaryConnection;

// When the temporary connection is above a CanvasNodeView, this view will be highlighted and stored at this pointer.
@property (nonatomic, strong) CanvasNodeView *connectableNodeView;

// A connection that has been tapped by the user. The attributes of this connection can be edited.
@property (nonatomic, strong) CanvasNodeConnection *selectedConnection;

@property (nonatomic, strong) NSMutableArray *autoscrollingItems;

// Moves the dragged view and the parent scrollview by a given fraction when the view has been dragged outside the content view.
@property (nonatomic, strong) NSTimer *autoscrollTimer;

// Triggered when a touch on an CanvasNodeView has began. Invalidated when the touch has moved has ended.
@property (nonatomic, strong) NSTimer *menuTimer;

// The menu controller of this CollectionCanvasView.
@property (nonatomic, strong) UIMenuController *menuController;

// The view currently decorated with a menu.
@property (nonatomic, strong) CanvasNodeView *viewWithMenu;

/** @name Layout */

/**
 Returns a valid center point on the canvas for a new nodeview.
 
 @param nodeView the CanvasNodeView
 
 @return the valid center as CGPoint
 */
- (CGPoint)autoLayoutNodeView:(CanvasNodeView *)nodeView;

/** @name Handling CanvasNodeConnection objects */

/**
 Adds a CanvasNodeConnection between CanvasNodeViews.
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
 
 @param itemView The given CanvasItemView to check.
 */
- (void)checkAutoScrollingForCanvasItemView:(CanvasItemView *)itemView;

/**
 Scrolls the touched view to be visible.
 */
- (void)scrollNodeViewToVisible;

/** @name Connection Handles */

/**
 Adds handles to all connections.
 
 - Adds a CanvasNewConnectionHandle above every CanvasNodeView on the canvas.
 - Adds a CanvasMoveConnectionHandle above every CanvasNodeConnection.
 
 Handles will be subviews of the CollectionCanvasView.
 Handle objects will be stored in the NSMutableArrays
 - newHandles
 - moveHandles
 */
- (void)addConnectionHandles;

/**
 Returns a CanvasNewConnectionHandle for a given CanvasNodeView.
 
 @param  nodeView The given CanvasNodeView
 @return The resulting CanvasNewConnectionHandle
 */
- (CanvasNewConnectionHandle *)makeNewConnectionHandleForNodeView:(CanvasNodeView *)nodeView;

/**
 Returns a CanvasMoveConnectionHandle for a given CanvasNodeConnection.
 
 @param  connection The given CanvasNodeConnection
 @return The resulting CanvasMoveConnectionHandle
 */
- (CanvasMoveConnectionHandle *)makeMoveConnectionHandleForConnection:(CanvasNodeConnection *)connection;

/**
 Removes all CanvasNewConnectionHandles and CanvasMoveConnectionHandles from the CollectionCanvasView
 and from the 'newHandles' and 'moveHandles' arrays.
 */
- (void)removeConnectionHandles;

/**
 Redraws all given CanvasNodeConnection objects passed in an array.
 
 @param connections The CanvasNodeConnection objects to redraw.
 */
- (void)refreshConnections:(NSMutableArray *)connections;

/**
 Redraws all parent and child connections of a given CanvasNodeView object.
 
 @param canvasNodeView The given CanvasNodeView object
 */
- (void)refreshConnectionsForView:(CanvasNodeView *)canvasNodeView;

/**
 Redraws all CanvasNodeConnections inside the connectionsForFullRefresh array.
 */
- (void)refreshConnectionsOutsideSelection;

/**
 Move a CanvasItemView's connections.
 
 @param itemView The given CanvasItemView object.
 */
- (void)moveConnectionsForItemView:(CanvasItemView *)itemView;

/** @name Processing multiple items */

/**
 Collects all CanvasNodeItems that belong to a selected tree segment (below the selected node view).
 Stores the collected objects inside the moveableSegment array.
 
 @param nodeView The given CanvasNodeView object
 
 @return A CGRect wich surrounds all collected CanvavsNodeView objects.
 */
- (NSMutableArray *)collectSegmentBelowNode:(CanvasNodeView *)nodeView;

/**
 Calculates the smallest possible rectangle around a given array of CanvasItemView objects.
 
 @param treeSegment The array containing the given CanvasItemViews.
 */
- (CGRect)segmentRectangleFromSegment:(NSArray *)treeSegment;

/**
 Collects all CanvasNodeConnectio objects wich point to node views outside the selected tree segment.
 Stores the collected objects inside the connectionsForFullRefresh array.
 */
- (void)collectConnectionsForFullRefresh;

/**
 Collapses all items below a given node view.
 
 @param nodeView The given node view to collapse
 */
- (void)collapseSegment:(CanvasNodeView *)nodeView;

/**
 Swing the visible CanvasNodeViews to a natural treeSegment.
 
 @param treeSegment The treeSegment of CanvasNodeViews.
 */
- (void)ticktockSegment:(NSArray *)treeSegment;

/**
 Passes a collapsed treeSegment of CanvasNodeViews to the delegate to be saved.
 
 @param treeSegment The treeSegment of CanvasNodeViews
 */
- (void)saveCollapsedSegment:(NSMutableArray *)treeSegment;

/**
 Expands all items below a given node view.
 
 @param nodeView The given node view to expand
 */
- (void)expandSegment:(CanvasNodeView *)nodeView;

/**
 Sets an item to expanded status.
 
 Resets the position on the canvas - relative to head node when it is not part of a collapsed subnode.
 
 @param item The given CanvasItemView
 @param headNode The head node of this tree segment
 @param expandAsSubnode Set to NO when the subnode is collapsed too
 */
- (void)expandItem:(CanvasItemView *)item headNode:(CanvasNodeView *)headNode expandAsSubnode:(BOOL)expandAsSubnode;

/**
 Expands all items below a given node view.
 
 Though this method works recursive the head node is given as a separate parameter.
 
 @param nodeView The given node view
 @param headNode The head of the collapsed node
 @param expandSubnode Set to NO when the subnode is collapsed too
 */
- (void)expandSegment:(CanvasNodeView *)nodeView headNode:(CanvasNodeView *)headNode expandSubNode:(BOOL)expandSubnode;

/**
 Passes an expanded treeSegment of CanvasNodeViews to the delegate to be saved.
 
 @param treeSegment The treeSegment of CanvasNodeViews
 */
- (void)saveExpandedSegment:(NSMutableArray *)treeSegment;

/** @name Handling the menu */

/**
 Starts timer if necesary to present a menu above the given CanvasItemView.
 
 @param canvasItemView The given CanvasItemView
 */
- (void)scheduleMenuForItemView:(CanvasItemView *)canvasItemView;

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

@implementation CollectionCanvasView

@synthesize canvasViewDataSource;
@synthesize canvasViewDelegate;
@synthesize scrollView;
@synthesize viewsTouched = _viewsTouched;

@synthesize temporaryConnection = _temporaryConnection;
@synthesize connectableNodeView = _connectableNodeView;
@synthesize selectedConnection = _selectedConnection;

@synthesize nodeViews = _nodeViews;
@synthesize connections = _connections;
@synthesize moreHandles = _moreHandles;
@synthesize moveHandles = _moveHandles;
@synthesize segmentsBelowNode = _segmentsBelowNode;
@synthesize connectionsForFullRefresh = _connectionsForFullRefresh;

@synthesize autoscrollTimer = _autoscrollTimer;
@synthesize autoscrollingItems = _autoscrollingItems;
@synthesize menuTimer = _menuTimer;
@synthesize menuController = _menuController;
@synthesize viewWithMenu = _viewWithMenu;

@synthesize lockedToSingleTouch = _lockedToSingleTouch;

static CGFloat OUTER_CANVAS_MARGIN      = 100.0;
static CGFloat OUTER_FILEVIEW_MARGIN    = 40.0;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        CALayer *layer = [self layer];
        layer.cornerRadius = 8.0;
        
        zoomScale = 0.5;
        
        _temporaryConnection = nil;
        _connectableNodeView = nil;
        _selectedConnection = nil;
        
        scrollView = nil;
        _autoscrollTimer = nil;
        _menuTimer = nil;
        
        _viewsTouched = [[NSMutableArray alloc] init];
        _nodeViews = [[NSMutableArray alloc] init];
        _connections = [[NSMutableArray alloc] init];
        _moreHandles = [[NSMutableArray alloc] init];
        _moveHandles = [[NSMutableArray alloc] init];
        _segmentsBelowNode = [[NSMutableDictionary alloc] init];
        _connectionsForFullRefresh = [[NSMutableArray alloc] init];
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

#pragma mark - Canvas view setup

- (void)fillCanvas
{
    NSInteger nodeCount = 0;
    NSMutableArray *headNodes = [[NSMutableArray alloc] init];
    NSMutableArray *segmentNodes = [[NSMutableArray alloc] init];
    
    if ([canvasViewDataSource respondsToSelector:@selector(numberOfNodesInSection:)])
        nodeCount = [canvasViewDataSource numberOfNodesInSection:0];
    
    for (NSInteger i = 0; i < nodeCount; i++) {
        CanvasNodeView *nodeView = nil;
        
        if ([canvasViewDataSource respondsToSelector:@selector(nodeViewOnCanvasAtIndexPath:)])
            nodeView = [canvasViewDataSource nodeViewOnCanvasAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if (nodeView) {
            
            if (nodeView.tag == i) {
                
                nodeView.delegate = self;
                nodeView.zoomScale = zoomScale;
                
                if (CGPointEqualToPoint(nodeView.center, CGPointZero))
                    nodeView.center = [self autoLayoutNodeView:nodeView];
                
                [_nodeViews addObject:nodeView];
                [self addSubview:nodeView];
                
                // Collect headnodes.
                if (nodeView.hasCollapsedSubStructure)
                    [headNodes addObject:nodeView];
                
                // Make treeSegment look natural.
                if (nodeView.isInCollapsedSegment)
                    [segmentNodes addObject:nodeView];
                
            } else
                NSLog(@"### Error: CollectionCanvasView: Internal Inconsistency.###");
        }
    }
    [self connectNodes];
    [self sizeCanvasToFit];
    
    [self ticktockSegment:segmentNodes];
    
    // Bring headnodes to fromt - descending - parent first.
    for (NSInteger i=headNodes.count-1; i>=0; i--)
        [self bringSubviewToFront:(UIView *)headNodes[i]];
    
    // Cleanup.
    [headNodes removeAllObjects];
    [segmentNodes removeAllObjects];
}

- (CGPoint)autoLayoutNodeView:(CanvasNodeView *)nodeView
{
    CGRect frame = nodeView.frame;
    frame.origin.x = (CGRectGetMinX(self.scrollView.bounds) / zoomScale) + OUTER_FILEVIEW_MARGIN;
    frame.origin.y = (CGRectGetMinY(self.scrollView.bounds) / zoomScale) + OUTER_FILEVIEW_MARGIN;
    
    for (CanvasNodeView *view in _nodeViews) {
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
    for (CanvasNodeView *nodeView in _nodeViews) {
        
        if ([canvasViewDataSource respondsToSelector:@selector(connectionsForNodeOnCanvasAtIndexPath:)])
            nodeConnections = [canvasViewDataSource connectionsForNodeOnCanvasAtIndexPath:[NSIndexPath indexPathForRow:nodeView.tag inSection:0]];
        
        // Iterate through all connections.
        for (CanvasNodeConnection *nodeConnection in nodeConnections) {
            
            NSUInteger parentTag = nodeConnection.parentIndex;
            NSUInteger childTag  = nodeConnection.childIndex;
            
            CanvasNodeView *parentView = _nodeViews[parentTag];
            CanvasNodeView *childView = _nodeViews[childTag];
            
            // add a new connection and connect both ends.
            CanvasNodeConnection *canvasNodeConnection = [[CanvasNodeConnection alloc] init];
            canvasNodeConnection.canvasNodeConnectionDelegate = self;
            canvasNodeConnection.parentNode = parentView;
            canvasNodeConnection.childNode = childView;
            
            // register connection in all three arrays.
            [parentView.childConnections addObject:canvasNodeConnection];
            [childView.parentConnections addObject:canvasNodeConnection];
            [_connections addObject:canvasNodeConnection];
            
            // set connection attributes.
            [self addSubview:canvasNodeConnection];
            [self sendSubviewToBack:canvasNodeConnection];
            [canvasNodeConnection drawConnection];
        }
    }
}

- (void)clearCanvas
{
    [_segmentsBelowNode removeAllObjects];
    [_connectionsForFullRefresh removeAllObjects];
    
    [_connections makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_connections makeObjectsPerformSelector:@selector(reset)];
    [_connections removeAllObjects];
    
    [_nodeViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_nodeViews makeObjectsPerformSelector:@selector(reset)];
    [_nodeViews removeAllObjects];
    
    [self removeConnectionHandles];
    isInConnectMode = NO;
    
    if (_temporaryConnection) {
        [_temporaryConnection removeFromSuperview];
        [_temporaryConnection reset];
        _temporaryConnection = nil;
    }
    
    if (_selectedConnection) {
        [_selectedConnection reset];
        _selectedConnection = nil;
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
    
    for (CanvasItemView *itemView in _autoscrollingItems) {
        
        // When the view reaches left or upper border of the view kill the timer.
        if (itemView.scaledFrame.origin.x <= 0.0)
            autoscrollDistanceHorizontal = 0.0;
        
        if (itemView.scaledFrame.origin.y <= 0.0)
            autoscrollDistanceVertical  = 0.0;
        
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
            [self scrollNodeViewToVisible];
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
    
    for (CanvasItemView *itemView in _autoscrollingItems) {
        
        CGPoint center = itemView.center;
        center.x += autoscrollDistanceHorizontal / zoomScale;
        center.y += autoscrollDistanceVertical / zoomScale;
        itemView.center = center;
        
        if ([itemView isKindOfClass:[CanvasNodeView class]]) {
            
            CanvasNodeView *nodeView = (CanvasNodeView *)itemView;
            
            if (isInConnectMode) {
                CanvasNewConnectionHandle *newHandle = _moreHandles[nodeView.tag];
                newHandle.center = CGPointMake(nodeView.center.x, nodeView.center.y + (nodeView.frame.size.height * 0.5));
            }
            
            NSMutableArray *segmentBelowNode = [self segmentForCanvasNodeView:nodeView];
            
            for (CanvasItemView *item in segmentBelowNode)
                item.center = CGPointMake(item.center.x + autoscrollDistanceHorizontal / zoomScale, item.center.y + autoscrollDistanceVertical / zoomScale);
            
            nodeView.segmentRect = CGRectOffset(nodeView.segmentRect, autoscrollDistanceHorizontal / zoomScale, autoscrollDistanceVertical / zoomScale);
        }
        [self moveConnectionsForItemView:itemView];
    }
}

- (float)autoscrollDistanceForProximityToEdge:(float)proximity {
    return ceilf((AUTOSCROLL_THRESHOLD - proximity) / 5.0);
}

- (void)checkAutoScrollingForCanvasItemView:(CanvasItemView *)itemView
{
    // Reset if nothing to scroll.
    if (_autoscrollingItems.count == 0) {
        autoscrollDistanceHorizontal = 0.0;
        autoscrollDistanceVertical   = 0.0;
    }
    
    CGRect scrollViewRect = CGRectInset(self.scrollView.bounds, AUTOSCROLL_MARGIN, AUTOSCROLL_MARGIN);
    CGRect viewTouchedRect = itemView.scaledFrame;
    
    //if ([itemView isKindOfClass:[CanvasNodeView class]])
    //    viewTouchedRect = ((CanvasNodeView *)itemView).scaledSegmentRect;
    
    float autoscrollDistanceH = 0.0;
    float autoscrollDistanceV = 0.0;
    
    if ((CGRectGetMinX(viewTouchedRect) < CGRectGetMinX(scrollViewRect)) || (CGRectGetMaxX(viewTouchedRect) > CGRectGetMaxX(scrollViewRect))
        || (CGRectGetMinY(viewTouchedRect) < CGRectGetMinY(scrollViewRect)) || (CGRectGetMaxY(viewTouchedRect) > CGRectGetMaxY(scrollViewRect))) {
        
        float distanceFromTopEdge    = CGRectGetMinY(viewTouchedRect) - CGRectGetMinY(self.scrollView.bounds);
        float distanceFromLeftEdge   = CGRectGetMinX(viewTouchedRect) - CGRectGetMinX(self.scrollView.bounds);
        float distanceFromRightEdge  = CGRectGetMaxX(self.scrollView.bounds) - CGRectGetMaxX(viewTouchedRect);
        float distanceFromBottomEdge = CGRectGetMaxY(self.scrollView.bounds) - CGRectGetMaxY(viewTouchedRect);
        
        if (distanceFromLeftEdge < AUTOSCROLL_THRESHOLD)
            autoscrollDistanceH = [self autoscrollDistanceForProximityToEdge:distanceFromLeftEdge] * -1;
        else if (distanceFromRightEdge < AUTOSCROLL_THRESHOLD)
            autoscrollDistanceH = [self autoscrollDistanceForProximityToEdge:distanceFromRightEdge];
        
        if (distanceFromTopEdge < AUTOSCROLL_THRESHOLD)
            autoscrollDistanceV = [self autoscrollDistanceForProximityToEdge:distanceFromTopEdge] * -1;
        else if (distanceFromBottomEdge < AUTOSCROLL_THRESHOLD)
            autoscrollDistanceV = [self autoscrollDistanceForProximityToEdge:distanceFromBottomEdge];
    }
    
    autoscrollDistanceHorizontal = MAX(autoscrollDistanceHorizontal, autoscrollDistanceH);
    
    autoscrollDistanceVertical = MAX(autoscrollDistanceVertical, autoscrollDistanceV);
    
    
    if ((autoscrollDistanceH == 0.0) && (autoscrollDistanceV == 0.0))
        [_autoscrollingItems removeObjectIdenticalTo:itemView];
    else
        if ([_autoscrollingItems containsObject:itemView] == NO)
            [_autoscrollingItems addObject:itemView];
    
    // Reset timer when view is inside visible bounds again OR start timer if not.
    if ((autoscrollDistanceHorizontal == 0.0 && autoscrollDistanceVertical == 0.0) || _autoscrollingItems.count == 0) {
        
        if (_autoscrollTimer) {
            [_autoscrollTimer invalidate];
            _autoscrollTimer = nil;
            [_autoscrollingItems removeAllObjects];
            
            [self sizeCanvasToFit];
            [self scrollNodeViewToVisible];
        }
        
    } else {
        
        if (_autoscrollingItems.count > 0)
            if (_autoscrollTimer == nil)
                _autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0) target:self selector:@selector(autoScrollOnEdges) userInfo:nil repeats:YES];
    }
}

- (void)scrollNodeViewToVisible
{
    if (_viewsTouched.count == 1) {
        CanvasItemView *viewTouched = _viewsTouched.lastObject;
        [self.scrollView scrollRectToVisible:CGRectInset(viewTouched.scaledFrame, -OUTER_FILEVIEW_MARGIN * zoomScale, -OUTER_FILEVIEW_MARGIN * zoomScale) animated:YES];
    }
}

- (void)sizeCanvasToFit {
    
    CGSize size = {0.0, 0.0};
    
    // Get smallest possible rect around all views + outer margin.
    for (CanvasNodeView *nodeView in _nodeViews) {
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
    
    // Iterate through all CanvasNodeViews.
    for (CanvasNodeView *nodeView in _nodeViews)
        nodeView.zoomScale = zoomScale;
    
    // Iterate through all CanvasNodeConnections.
    for (CanvasNodeConnection *connection in _connections)
        connection.zoomScale = zoomScale;
    
    // Iterate through all CanvasNewConnectionHandles.
    for (CanvasNewConnectionHandle *handle in _moreHandles)
        handle.zoomScale = zoomScale;
    
    // Iterate through all CanvasMoveConnectionHandle.
    for (CanvasMoveConnectionHandle *handle in _moveHandles)
        handle.zoomScale = zoomScale;
    
    // Don't forget the temporary connection if it has been set.
    if (_temporaryConnection)
        _temporaryConnection.zoomScale = zoomScale;
    
    [self sizeCanvasToFit];
}

#pragma mark - CanvasNodeView handling

- (void)updateNodeViewAtIndexPath:(NSIndexPath *)indexPath
{
    [[self nodeAtIndexPath:indexPath] removeFromSuperview];
    
    CanvasNodeView *nodeView = nil;
    
    if ([canvasViewDataSource respondsToSelector:@selector(nodeViewOnCanvasAtIndexPath:)])
        nodeView = [canvasViewDataSource nodeViewOnCanvasAtIndexPath:indexPath];
    
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
    CanvasNodeView *nodeView = nil;
    
    if ([canvasViewDataSource respondsToSelector:@selector(nodeViewOnCanvasAtIndexPath:)])
        nodeView = [canvasViewDataSource nodeViewOnCanvasAtIndexPath:indexPath];
    
    if (nodeView) {
        nodeView.tag = indexPath.row;
        nodeView.delegate = self;
        nodeView.zoomScale = zoomScale;
        
        [_nodeViews insertObject:nodeView atIndex:indexPath.row];
        [self addSubview:nodeView];
        
        // Reindex remaining node views
        for (NSInteger i = indexPath.row; i < _nodeViews.count; i++)
            ((CanvasNodeView *)_nodeViews[i]).tag = i;
        
        // Add new connection handle if necessary.
        if (isInConnectMode) {
            CanvasNewConnectionHandle *handle = [self makeNewConnectionHandleForNodeView:nodeView];
            nodeView.connectionHandle = handle;
            
            [_moreHandles insertObject:handle atIndex:handle.tag];
            
            // Reindex remaining handles
            for (NSInteger i = handle.tag; i < _moreHandles.count; i++)
                ((CanvasNewConnectionHandle *)_moreHandles[i]).tag = i;
            
            // Add new connection handle to node view.
            [self addSubview:handle];
        }
        
        [self sizeCanvasToFit];
        
        // Load thumb image.
        if ([canvasViewDataSource respondsToSelector:@selector(thumbImageForNodeViewAtIndexPath:)])
            [canvasViewDataSource thumbImageForNodeViewAtIndexPath:indexPath];
    }
}

- (void)deleteNodeAtIndexPath:(NSIndexPath *)indexPath
{
    CanvasNodeView *nodeView = nil;
    
    nodeView = [self nodeAtIndexPath:indexPath];
    
    if (nodeView) {
        
        // Expand node when collapsed.
        if (nodeView.hasCollapsedSubStructure)
            [self expandSegment:nodeView];
        
        // Cascaded removal of parent and child connections
        for (CanvasNodeConnection *parentConnection in nodeView.parentConnections) {
            [parentConnection removeFromSuperview];
            
            // Delete node
            [parentConnection.parentNode.connectedNodes removeObject:nodeView];
            
            // Delete connection
            [parentConnection.parentNode.childConnections removeObject:parentConnection];
            
            // Remove connection
            [_connections removeObject:parentConnection];
        }
        for (CanvasNodeConnection *childConnection in nodeView.childConnections) {
            [childConnection removeFromSuperview];
            
            // Delete node
            [childConnection.childNode.connectedNodes removeObject:nodeView];
            
            // Delete connection
            [childConnection.childNode.parentConnections removeObject:childConnection];
            
            // Remove connection
            [_connections removeObject:childConnection];
        }
        
        [_nodeViews removeObjectAtIndex:indexPath.row];
        
        // Reindex remaining node views
        for (NSInteger i = indexPath.row; i < _nodeViews.count; i++)
            ((CanvasNodeView *)_nodeViews[i]).tag = i;
        
        // Remove new connection handle if necessary.
        if (isInConnectMode) {
            CanvasNewConnectionHandle *handle = _moreHandles[nodeView.tag];
            [handle removeFromSuperview];
            [_moreHandles removeObjectAtIndex:nodeView.tag];
            
            // Reindex remaining handles
            for (NSInteger i = handle.tag; i < _moreHandles.count; i++)
                ((CanvasNewConnectionHandle *)_moreHandles[i]).tag = i;
        }
        
        [nodeView removeFromSuperview];
    }
}

- (CanvasNodeView *)nodeAtIndexPath:(NSIndexPath *)indexPath
{
    return _nodeViews[indexPath.row];
}

- (void)updateThumbImage:(UIImage *)image forNodeViewAtIndexPath:(NSIndexPath *)indexPath
{
    CanvasNodeView *nodeView = nil;
    
    nodeView = [self nodeAtIndexPath:indexPath];
    
    if (nodeView) {
        CGPoint center = nodeView.center;
        
        // Set thumbnail image.
        //nodeView.thumbImage = image;
        
        // Recenter nodeView after changing size to sie of image.
        nodeView.center = center;
        
        // Redraw connections to correct endPoint and moveHandle position.
        [nodeView.parentConnections makeObjectsPerformSelector:@selector(drawConnection)];
    }
}

#pragma mark - Connection handles

- (void)toggleConnectMode
{
    if (isInConnectMode)
        [self removeConnectionHandles];
    else
        [self addConnectionHandles];
    
    isInConnectMode = !isInConnectMode;
}

- (void)addConnectionHandles
{
    // Add CanvasNewConnectionHandles
    for (CanvasNodeView *nodeView in _nodeViews) {
        
        if (nodeView.isInCollapsedSegment == NO) {
            
            CanvasNewConnectionHandle *handle = [self makeNewConnectionHandleForNodeView:nodeView];
            nodeView.connectionHandle = handle;
            [_moreHandles addObject:handle];
            
            [self addSubview:handle];
        }
    }
    
    // Add CanvasMoveConnectionHandles
    for (CanvasNodeConnection *connection in _connections) {
        
        if (connection.isInCollapsedSegment == NO) {
            
            CanvasMoveConnectionHandle *handle = [self makeMoveConnectionHandleForConnection:connection];
            connection.moveConnectionHandle = handle;
            [_moveHandles addObject:handle];
            
            [self addSubview:handle];
        }
    }
}

- (CanvasNewConnectionHandle *)makeNewConnectionHandleForNodeView:(CanvasNodeView *)nodeView
{
    CGPoint handleCenter = [self convertPoint:nodeView.connectionHandleAncorPoint toView:self];
    
    CanvasNewConnectionHandle *handle = [[CanvasNewConnectionHandle alloc] initWithFrame:CGRectMake(handleCenter.x - 10.0, handleCenter.y - 10.0, 20.0, 20.0)];
    handle.zoomScale = zoomScale;
    handle.nodeView = nodeView;
    handle.delegate = self;
    
    return handle;
}

- (CanvasMoveConnectionHandle *)makeMoveConnectionHandleForConnection:(CanvasNodeConnection *)connection
{
    CGPoint handleCenter = [self convertPoint:connection.visibleEndPoint fromView:connection];
    
    CanvasMoveConnectionHandle *handle = [[CanvasMoveConnectionHandle alloc] initWithFrame:CGRectMake(handleCenter.x - 10.0, handleCenter.y - 10.0, 20.0, 20.0)];
    handle.zoomScale = zoomScale;
    handle.connection = connection;
    handle.delegate = self;
    
    return handle;
}


- (void)removeConnectionHandles
{
    [_moreHandles makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_moreHandles removeAllObjects];
    
    [_moveHandles makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_moveHandles removeAllObjects];
}

#pragma mark - Drawing connections

- (void)refreshConnectionsForView:(CanvasNodeView *)canvasNodeView
{
    [self refreshConnections:canvasNodeView.parentConnections];
    [self refreshConnections:canvasNodeView.childConnections];
}

- (void)refreshConnections:(NSMutableArray *)connections
{
    for (CanvasNodeConnection *canvasNodeConnection in connections) {
        [canvasNodeConnection drawConnection];
        
        if (isInConnectMode) {
            if (canvasNodeConnection.isValid) {
                CanvasMoveConnectionHandle *handle = canvasNodeConnection.moveConnectionHandle;
                handle.center = [self convertPoint:canvasNodeConnection.visibleEndPoint fromView:canvasNodeConnection];
            }
        }
    }
}

- (void)refreshConnectionsOutsideSelection
{
    [self refreshConnections:_connectionsForFullRefresh];
}

- (void)moveConnectionsForItemView:(CanvasItemView *)itemView
{
    if ([itemView isKindOfClass:[CanvasNodeView class]]) {
        [self refreshConnectionsForView:(CanvasNodeView *)itemView];
        
    } else {
        
        CanvasNodeConnection *connection = nil;
        
        if ([itemView isKindOfClass:[CanvasNewConnectionHandle class]])
            connection = _temporaryConnection;
        else if ([itemView isKindOfClass:[CanvasMoveConnectionHandle class]])
            connection = _selectedConnection;
        
        connection.frame =  CGRectMake(connection.parentNode.center.x, connection.parentNode.center.y+20.0,
                                       itemView.center.x - connection.parentNode.center.x,
                                       itemView.center.y - connection.parentNode.center.y);
        
        CGPoint start = [self convertPoint:connection.parentNode.center toView:connection];
        CGPoint end   = [self convertPoint:itemView.center toView:connection];
        [connection drawConnectionFromPoint:start toPoint:end];
    }
}

#pragma mark - CanvasNodeConnectionDelegate

- (void)removedConnection:(CanvasNodeConnection *)connection atIndexPath:(NSIndexPath *)indexPath
{
    [connection removeFromSuperview];
    [connection.parentNode.connectedNodes removeObject:connection.childNode];
    [connection.parentNode.childConnections removeObject:connection];
    [connection.childNode.connectedNodes removeObject:connection.parentNode];
    [connection.childNode.parentConnections removeObject:connection];
    [_connections removeObject:connection];
    
    if ([canvasViewDelegate respondsToSelector:@selector(didRemoveConnectionAtIndexPath:)])
        [canvasViewDelegate didRemoveConnectionAtIndexPath:indexPath];
}

#pragma mark - Processing multiple items

- (NSMutableArray *)collectSegmentBelowNode:(CanvasNodeView *)nodeView
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (CanvasNodeConnection *connection in nodeView.childConnections) {
        if (connection.isValid) {
            [array addObject:connection];
            
            // Avoid circular references to another parent view or to viewTouched.
            if ([array containsObject:connection.childNode] == NO && [_viewsTouched containsObject:connection.childNode] == NO) {
                [array addObject:connection.childNode];
                
                if (isInConnectMode)
                    if (connection.childNode.connectionHandle)
                        [array addObject:connection.childNode.connectionHandle];
                
                [array addObjectsFromArray:[self collectSegmentBelowNode:connection.childNode]];
            }
            if (isInConnectMode)
                if (connection.moveConnectionHandle)
                    [array addObject:connection.moveConnectionHandle];
        }
    }
    return array;
}

- (CGRect)segmentRectangleFromSegment:(NSArray *)treeSegment
{
    CGRect segmentRect = CGRectZero;
    for (CanvasItemView *itemView in treeSegment) {
        segmentRect = CGRectUnion(itemView.frame, segmentRect);
    }
    return segmentRect;
}

- (void)collectConnectionsForFullRefresh
{
    for (NSMutableArray *segmentBelowNode in _segmentsBelowNode.allValues) {
        for (CanvasItemView *nodeItem in segmentBelowNode) {
            if ([nodeItem isKindOfClass:[CanvasNodeView class]]) {
                CanvasNodeView *nodeView = (CanvasNodeView *)nodeItem;
                if (nodeView.parentConnections.count > 1) {
                    for (CanvasNodeConnection *parentConnection in nodeView.parentConnections) {
                        if ([segmentBelowNode containsObject:parentConnection] == NO)
                            [_connectionsForFullRefresh addObject:parentConnection];
                    }
                }
            }
        }
    }
}

#pragma mark - Collapsing a treeSegment

- (void)collapseSegment:(CanvasNodeView *)nodeView
{
    // Collect collapseable treeSegment
    NSMutableArray *segmentBelowNode = [self segmentForCanvasNodeView:nodeView];
    nodeView.segmentRect = CGRectUnion(nodeView.frame, [self segmentRectangleFromSegment:segmentBelowNode]);
    nodeView.hasCollapsedSubStructure = YES;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nodeView.tag inSection:0];
    if ([canvasViewDelegate respondsToSelector:@selector(didCollapseNodeOnCanvasAtIndexPath:nodeView:)])
        [canvasViewDelegate didCollapseNodeOnCanvasAtIndexPath:indexPath nodeView:nodeView];
    
    if ([canvasViewDelegate respondsToSelector:@selector(didCollapseConnectionsOnCanvasUnderNodeView:atIndexPath:)])
        [canvasViewDelegate didCollapseConnectionsOnCanvasUnderNodeView:nodeView atIndexPath:indexPath];
    
    // Collapse segment
    for (CanvasItemView *nodeItem in segmentBelowNode) {
        
        // if node is not yet in a collapsed (sub)treeSegment.
        if (nodeItem.isInCollapsedSegment == NO) {
            nodeItem.deltaToCollapsedNode = CGSizeMake(nodeItem.center.x - nodeView.center.x, nodeItem.center.y - nodeView.center.y);
            nodeItem.isInCollapsedSegment = YES;
            
            if ([nodeItem isKindOfClass:[CanvasNodeView class]])
                ((CanvasNodeView *)nodeItem).headNodeTag = nodeView.tag;
        }
        [nodeItem setCenter:nodeView.center animated:YES];
    }
    
    [self ticktockSegment:segmentBelowNode];
    
    // Redraw connections witin the collapsed structure.
    for (CanvasNodeConnection *connection in segmentBelowNode) {
        if ([connection isKindOfClass:[CanvasNodeConnection class]]) {
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
    
    for (CanvasItemView *nodeItem in treeSegment) {
        
        // Swing the visible node views to a natural treeSegment.
        if ([nodeItem isKindOfClass:[CanvasNodeView class]]) {
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
    
    for (CanvasItemView *item in collapsedSegment) {
        
        if ([item isKindOfClass:[CanvasNodeView class]]) {
            
            CanvasNodeView *nodeView = (CanvasNodeView *)item;
            [collapsedNodeViews addObject:nodeView];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:item.tag inSection:0];
            [collapsedNodeIndexPaths addObject:indexPath];
            
            if ([canvasViewDelegate respondsToSelector:@selector(didCollapseConnectionsOnCanvasUnderNodeView:atIndexPath:)])
                [canvasViewDelegate didCollapseConnectionsOnCanvasUnderNodeView:nodeView atIndexPath:indexPath];
        }
    }
    
    if ([canvasViewDelegate respondsToSelector:@selector(didCollapseSegmentOfNodesOnCanvasWithIndexPaths:nodeViews:)])
        [canvasViewDelegate didCollapseSegmentOfNodesOnCanvasWithIndexPaths:collapsedNodeIndexPaths nodeViews:collapsedNodeViews];
}

#pragma mark - Expanding a treeSegment

- (void)expandSegment:(CanvasNodeView *)nodeView
{
    // Collect collapseable treeSegment
    NSMutableArray *segmentBelowNode = [self segmentForCanvasNodeView:nodeView];
    nodeView.segmentRect = CGRectUnion(nodeView.frame, [self segmentRectangleFromSegment:segmentBelowNode]);
    
    // Expand segment - except other collapsed subnodes.
    [self expandSegment:nodeView headNode:nodeView expandSubNode:YES];
    nodeView.hasCollapsedSubStructure = NO;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nodeView.tag inSection:0];
    if ([canvasViewDelegate respondsToSelector:@selector(didExpandNodeOnCanvasAtIndexPath:nodeView:)])
        [canvasViewDelegate didExpandNodeOnCanvasAtIndexPath:indexPath nodeView:nodeView];
    
    if ([canvasViewDelegate respondsToSelector:@selector(didExpandConnectionsOnCanvasUnderNodeView:atIndexPath:)])
        [canvasViewDelegate didExpandConnectionsOnCanvasUnderNodeView:nodeView atIndexPath:indexPath];
    
    // Redraw connections to external node views.
    [self collectConnectionsForFullRefresh];
    [self refreshConnectionsOutsideSelection];
    
    [self saveExpandedSegment:segmentBelowNode];
    
    [self bringSubviewToFront:nodeView];
    [self sizeCanvasToFit];
}

- (void)expandItem:(CanvasItemView *)item headNode:(CanvasNodeView *)headNode expandAsSubnode:(BOOL)expandAsSubnode
{
    if (expandAsSubnode) {
        
        /*
         // If this is not the right treeSegment (cross reference) - shift to real parent.
         if (([item isKindOfClass:[CanvasNodeView class]]) && (((CanvasNodeView *)item).headNodeTag != headNode.tag)) {
         
         CanvasNodeView *nodeView = (CanvasNodeView *)item;
         CanvasNodeView *realHeadNode = [_nodeViews objectAtIndex:nodeView.headNodeTag];
         nodeView.center = realHeadNode.center;
         
         } else {
         */
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(0.0);
        item.transform = transform;
        
        CGPoint center = CGPointMake(headNode.center.x + item.deltaToCollapsedNode.width, headNode.center.y + item.deltaToCollapsedNode.height);
        [item setCenter:center animated:YES];
        
        item.deltaToCollapsedNode = CGSizeMake(0.0, 0.0);
        item.isInCollapsedSegment = NO;
        
        if ([item isKindOfClass:[CanvasNodeView class]])
            ((CanvasNodeView *)item).headNodeTag = -1;
        //}
        
    } else
        [item setCenter:headNode.center animated:YES];
}

- (void)expandSegment:(CanvasNodeView *)nodeView headNode:(CanvasNodeView *)headNode expandSubNode:(BOOL)expandSubnode
{
    for (CanvasNodeConnection *connection in nodeView.childConnections) {
        
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
                    
                    if (isInConnectMode)
                        [self expandItem:connection.childNode.connectionHandle headNode:headNode expandAsSubnode:expandSubnode];
                    
                    if (expandSubnode == YES) {
                        
                        // Expand items in relation to subnode.
                        if (connection.childNode.hasCollapsedSubStructure == NO)
                            [self expandSegment:connection.childNode headNode:headNode expandSubNode:YES];
                        else
                            [self expandSegment:connection.childNode headNode:connection.childNode expandSubNode:NO];
                        
                    } else {
                        
                        // Expand items in relation to head node.
                        [self expandSegment:connection.childNode headNode:headNode expandSubNode:NO];
                    }
                }
            }
            if (isInConnectMode)
                [self expandItem:connection.moveConnectionHandle headNode:headNode expandAsSubnode:expandSubnode];
        }
    }
}

- (void)saveExpandedSegment:(NSMutableArray *)treeSegment
{
    // Collect nodeviews and notify delegate.
    NSMutableArray *expandedNodeViews = [[NSMutableArray alloc] init];
    NSMutableArray *expandedNodeIndexPaths = [[NSMutableArray alloc] init];
    
    for (CanvasNodeView *item in treeSegment) {
        
        if ([item isKindOfClass:[CanvasNodeView class]]) {
            
            CanvasNodeView *nodeView = (CanvasNodeView *)item;
            
            [expandedNodeViews addObject:nodeView];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nodeView.tag inSection:0];
            [expandedNodeIndexPaths addObject:indexPath];
            
            if ([canvasViewDelegate respondsToSelector:@selector(didExpandConnectionsOnCanvasUnderNodeView:atIndexPath:)])
                [canvasViewDelegate didExpandConnectionsOnCanvasUnderNodeView:nodeView atIndexPath:indexPath];
        }
    }
    
    if ([canvasViewDelegate respondsToSelector:@selector(didExpandSegmentOfNodesOnCanvasWithIndexPaths:nodeViews:)])
        [canvasViewDelegate didExpandSegmentOfNodesOnCanvasWithIndexPaths:expandedNodeIndexPaths nodeViews:expandedNodeViews];
}

#pragma mark - Menu handling

- (void)scheduleMenuForItemView:(CanvasItemView *)canvasItemView
{
    [self killMenuTimer];
    if (_menuTimer == nil)
        _menuTimer = [NSTimer scheduledTimerWithTimeInterval:(0.3) target:self selector:@selector(showMenu:) userInfo:canvasItemView repeats:NO];
}

- (void)showMenu:(NSTimer *)timer
{
    // Present menue -delete -collapse / expand
	[self hideMenu];
    
    _viewWithMenu = (CanvasNodeView *)timer.userInfo;
    
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
    if (action == @selector(collapse:))
        return (_viewWithMenu.hasCollapsedSubStructure == NO && _viewWithMenu.childConnections.count > 0);
    
    // expand
    if (action == @selector(expand:))
        return (_viewWithMenu.hasCollapsedSubStructure && _viewWithMenu.childConnections.count > 0);
    
	if (action == @selector(delete:))
		return YES;
    
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
    
    if (_viewWithMenu.hasCollapsedSubStructure)
        [self expandSegment:_viewWithMenu];
    
    [self deleteNodeAtIndexPath:indexPath];
    
    if ([canvasViewDelegate respondsToSelector:@selector(didDeleteNodeOnCanvasAtIndexPath:)])
        [canvasViewDelegate didDeleteNodeOnCanvasAtIndexPath:indexPath];
}

#pragma mark - Touch handling - external

- (BOOL)isProcessingViews
{
    return (_viewsTouched.count > 0);
}

- (BOOL)isInSingleTouchMode
{
    return ((_temporaryConnection) || (_selectedConnection));
}

#pragma mark - CanvasItemViewDelegate

- (BOOL)canProcessCanvasNodeView:(CanvasNodeView *)canvasNodeView
{
    return ([self isInSingleTouchMode] == NO);
}

- (BOOL)canProcessCanvasNewConnectionHandle:(CanvasNewConnectionHandle *)canvasNewConnectionHandle
{
    if ([self isInSingleTouchMode])
        return (_viewsTouched[0] == canvasNewConnectionHandle);
    
    if ([self isProcessingViews])
        return NO;
    
    return YES;
}

- (BOOL)canProcessCanvasMoveConnectionHandle:(CanvasMoveConnectionHandle *)canvasMoveConnectionHandle
{
    if ([self isInSingleTouchMode])
        return (_viewsTouched[0] == canvasMoveConnectionHandle);
    
    if ([self isProcessingViews])
        return NO;
    
    return YES;
}

#pragma mark - CanvasNodeViewDelegate

- (NSMutableArray *)segmentForCanvasNodeView:(CanvasNodeView *)canvasNodeView
{
    NSString *key = [NSString stringWithFormat:@"%li", (long)canvasNodeView.tag];
    NSMutableArray *segmentBelowNode = _segmentsBelowNode[key];
    
    if (segmentBelowNode == nil) {
        segmentBelowNode = [self collectSegmentBelowNode:canvasNodeView];
        _segmentsBelowNode[key] = segmentBelowNode;
    }
    
    return segmentBelowNode;
}

- (void)canvasNodeView:(CanvasNodeView *)canvasNodeView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
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
        
        if (segmentBelowNode.count > 0)
            [segmentBelowNode makeObjectsPerformSelector:@selector(setSelected:) withObject:@"YES"];
    }
    [self collectConnectionsForFullRefresh];
    
    [self scheduleMenuForItemView:canvasNodeView];
}

- (void)canvasNodeView:(CanvasNodeView *)canvasNodeView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
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
        CanvasNewConnectionHandle *handle = _moreHandles[canvasNodeView.tag];
        handle.center = CGPointMake(canvasNodeView.center.x, canvasNodeView.center.y + (canvasNodeView.frame.size.height / 2.0));
    }
    
    if (canvasNodeView.hasCollapsedSubStructure) {
        
        NSMutableArray *segmentBelowNode = [self segmentForCanvasNodeView:canvasNodeView];
        canvasNodeView.segmentRect = CGRectUnion(canvasNodeView.frame, [self segmentRectangleFromSegment:segmentBelowNode]);
        
        for (CanvasItemView *item in segmentBelowNode)
            item.center = CGPointMake(item.center.x + delta.x, item.center.y + delta.y);
        
        canvasNodeView.segmentRect = CGRectOffset(canvasNodeView.segmentRect, delta.x, delta.y);
        
        [self refreshConnectionsOutsideSelection];
    }
    
    [self moveConnectionsForItemView:canvasNodeView];
    [self checkAutoScrollingForCanvasItemView:canvasNodeView];
}

- (void)canvasNodeView:(CanvasNodeView *)canvasNodeView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
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
            
            if ([canvasViewDelegate respondsToSelector:@selector(didSelectNodeOnCanvasAtIndexPath:)])
                [canvasViewDelegate didSelectNodeOnCanvasAtIndexPath:[NSIndexPath indexPathForRow:canvasNodeView.tag inSection:0]];
        }
    } else {
        
        if ([canvasViewDelegate respondsToSelector:@selector(didMoveNodeOnCanvasAtIndexPath:nodeView:)])
            [canvasViewDelegate didMoveNodeOnCanvasAtIndexPath:[NSIndexPath indexPathForRow:canvasNodeView.tag inSection:0] nodeView:canvasNodeView];
        
        if (isInConnectMode)
            [self bringSubviewToFront:_moreHandles[canvasNodeView.tag]];
        
        [self sizeCanvasToFit];
        [self scrollNodeViewToVisible];
        
        if (canvasNodeView.hasCollapsedSubStructure) {
            
            NSMutableArray *segmentOfNodeViews = [[NSMutableArray alloc] init];
            for (CanvasNodeView *nodeView in segmentBelowNode) {
                if ([nodeView isKindOfClass:[CanvasNodeView class]]) {
                    [segmentOfNodeViews addObject:nodeView];
                }
            }
            if ([canvasViewDelegate respondsToSelector:@selector(didMoveSegmentOfNodesOnCanvasWithIndexPaths:nodeViews:)])
                [canvasViewDelegate didMoveSegmentOfNodesOnCanvasWithIndexPaths:nil nodeViews:segmentOfNodeViews];
        }
    }
    
    [segmentBelowNode makeObjectsPerformSelector:@selector(setSelected:) withObject:nil];
    
    [self moveConnectionsForItemView:canvasNodeView];
    [_connectionsForFullRefresh removeAllObjects];
    
    [canvasNodeView setSelected:NO];
    
    isMovingCanvasNodeViews = NO;
    [_autoscrollTimer invalidate];
    
    [_viewsTouched removeObject:canvasNodeView];
    [_autoscrollingItems removeObject:canvasNodeView];
}

- (void)canvasNodeView:(CanvasNodeView *)canvasNodeView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self moveConnectionsForItemView:canvasNodeView];
    [_viewsTouched removeObject:canvasNodeView];
    [_autoscrollingItems removeObject:canvasNodeView];
}

#pragma mark - CanvasNewConnectionHandleDelegate

- (void)canvasNewConnectionHandle:(CanvasNewConnectionHandle *)canvasNewConnectionHandle touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    
    _lockedToSingleTouch = YES;
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    location.x += canvasNewConnectionHandle.touchOffset.width;
    location.y += canvasNewConnectionHandle.touchOffset.height;
    
    [_viewsTouched addObject:canvasNewConnectionHandle];
    [canvasNewConnectionHandle setHighlighted:YES];
    
    // Add the temporary connection object.
    _temporaryConnection = [[CanvasNodeConnection alloc] initWithFrame:CGRectZero];
    _temporaryConnection.canvasNodeConnectionDelegate = self;
    _temporaryConnection.parentNode = _nodeViews[canvasNewConnectionHandle.tag];
    _temporaryConnection.zoomScale = zoomScale;
    [self addSubview:_temporaryConnection];
    
    _temporaryConnection.frame =  CGRectMake(_temporaryConnection.parentNode.center.x, _temporaryConnection.parentNode.center.y,
                                             location.x - _temporaryConnection.parentNode.center.x,
                                             location.y - _temporaryConnection.parentNode.center.y);
    
    CGPoint start = [self convertPoint:_temporaryConnection.parentNode.center toView:_temporaryConnection];
    CGPoint end   = [self convertPoint:location toView:_temporaryConnection];
    [_temporaryConnection drawConnectionFromPoint:start toPoint:end];
}

- (void)canvasNewConnectionHandle:(CanvasNewConnectionHandle *)canvasNewConnectionHandle touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    location.x += [canvasNewConnectionHandle touchOffset].width;
    location.y += [canvasNewConnectionHandle touchOffset].height;
    
    canvasNewConnectionHandle.center = location;
    isMovingCanvasNodeViews = YES;
    
    _temporaryConnection.frame =  CGRectMake(_temporaryConnection.parentNode.center.x, _temporaryConnection.parentNode.center.y,
                                             location.x - _temporaryConnection.parentNode.center.x,
                                             location.y - _temporaryConnection.parentNode.center.y);
    
    CGPoint start = [self convertPoint:_temporaryConnection.parentNode.center toView:_temporaryConnection];
    CGPoint end   = [self convertPoint:location toView:_temporaryConnection];
    [_temporaryConnection drawConnectionFromPoint:start toPoint:end];
    
    for (CanvasNodeView *nodeView in _nodeViews) {
        
        if ((CGRectIntersectsRect(nodeView.frame, canvasNewConnectionHandle.frame))  && (nodeView != _temporaryConnection.parentNode) && (nodeView.isInCollapsedSegment == NO)) {
            if (_connectableNodeView) {
                if (_connectableNodeView != (CanvasNodeView *)nodeView) {
                    [_connectableNodeView setSelected:NO];
                    _connectableNodeView = nil;
                    _connectableNodeView = (CanvasNodeView *)nodeView;
                    [_connectableNodeView setSelected:YES];
                    goto bail;
                    
                } else
                    goto bail;
                
            } else {
                _connectableNodeView = (CanvasNodeView *)nodeView;
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
    [self checkAutoScrollingForCanvasItemView:canvasNewConnectionHandle];
}

- (void)canvasNewConnectionHandle:(CanvasNewConnectionHandle *)canvasNewConnectionHandle touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    
    if (_connectableNodeView) {
        CanvasNodeView *parentView = _temporaryConnection.parentNode;
        
        // Add a new valid connection.
        CGRect frame = CGRectMake(0.0, 0.0, 0.0, 0.0);
        CanvasNodeConnection *connection = [[CanvasNodeConnection alloc] initWithFrame:frame];
        connection.canvasNodeConnectionDelegate = self;
        connection.zoomScale = zoomScale;
        
        connection.parentNode = parentView;
        connection.childNode = _connectableNodeView;
        connection.tag = connection.parentNode.childConnections.count;
        
        [parentView.childConnections addObject:connection];
        [_connectableNodeView.parentConnections addObject:connection];
        [_connections addObject:connection];
        
        [self addSubview:connection];
        [self sendSubviewToBack:connection];
        
        [connection drawConnection];
        
        // Add new invisible handle.
        CGPoint handleCenter = [self convertPoint:connection.visibleEndPoint fromView:connection];
        CanvasMoveConnectionHandle *moveHandle = [[CanvasMoveConnectionHandle alloc] initWithFrame:CGRectMake(handleCenter.x - 10.0, handleCenter.y - 10.0, 20.0, 20.0)];
        moveHandle.delegate = self;
        moveHandle.zoomScale = zoomScale;
        moveHandle.connection = connection;
        [_moveHandles addObject:moveHandle];
        
        connection.moveConnectionHandle = moveHandle;
        
        [self bringSubviewToFront:moveHandle];
        [self addSubview:moveHandle];
        
        [_connectableNodeView setSelected:NO];
        _connectableNodeView = nil;
        
        NSIndexPath *parentIndex = [NSIndexPath indexPathForRow:connection.parentNode.tag inSection:0];
        NSIndexPath *childIndex = [NSIndexPath indexPathForRow:connection.childNode.tag inSection:0];
        
        if ([canvasViewDelegate respondsToSelector:@selector(didAddConnectionAtIndexPath:andNodeAtIndexPath:)])
            [canvasViewDelegate didAddConnectionAtIndexPath:parentIndex andNodeAtIndexPath:childIndex];
    }
    
    canvasNewConnectionHandle.center = [self convertPoint:_temporaryConnection.parentNode.connectionHandleAncorPoint toView:self];
    
    [canvasNewConnectionHandle setHighlighted:NO];
    [_temporaryConnection removeFromSuperview];
    _temporaryConnection = nil;
    _connectableNodeView = nil;
    
    [_viewsTouched removeObject:canvasNewConnectionHandle];
    [_autoscrollingItems removeObject:canvasNewConnectionHandle];
    
    _lockedToSingleTouch = NO;
    
    [self sizeCanvasToFit];
}

- (void)canvasNewConnectionHandle:(CanvasNewConnectionHandle *)canvasNewConnectionHandle touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    isMovingCanvasNodeViews = NO;
    [_autoscrollTimer invalidate];
    [self sizeCanvasToFit];
    
    canvasNewConnectionHandle.center = [self convertPoint:_temporaryConnection.parentNode.connectionHandleAncorPoint toView:self];
    [_temporaryConnection removeFromSuperview];
    _temporaryConnection = nil;
    _connectableNodeView = nil;
    
    [self scrollNodeViewToVisible];
    
    [canvasNewConnectionHandle setSelected:NO];
    
    [_connectionsForFullRefresh removeAllObjects];
    
    [_viewsTouched removeObject:canvasNewConnectionHandle];
    [_autoscrollingItems removeObject:canvasNewConnectionHandle];
    
    _lockedToSingleTouch = NO;
}

#pragma mark - CanvasMoveConnectionHandleDelegate

- (void)canvasMoveConnectionHandle:(CanvasMoveConnectionHandle *)canvasMoveConnectionHandle touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    
    _lockedToSingleTouch = YES;
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    location.x += canvasMoveConnectionHandle.touchOffset.width;
    location.y += canvasMoveConnectionHandle.touchOffset.height;
    
    [_viewsTouched addObject:canvasMoveConnectionHandle];
    [canvasMoveConnectionHandle setHighlighted:YES];
    
    // Set the selected connection object.
    _selectedConnection = canvasMoveConnectionHandle.connection;
    
    CGPoint start = [self convertPoint:_selectedConnection.parentNode.center toView:_selectedConnection];
    CGPoint end   = [self convertPoint:location toView:_selectedConnection];
    
    [_selectedConnection drawConnectionFromPoint:start toPoint:end];
}

- (void)canvasMoveConnectionHandle:(CanvasMoveConnectionHandle *)canvasMoveConnectionHandle touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    location.x += canvasMoveConnectionHandle.touchOffset.width;
    location.y += canvasMoveConnectionHandle.touchOffset.height;
    
    canvasMoveConnectionHandle.center = location;
    isMovingCanvasNodeViews = YES;
    
    
    _selectedConnection.frame =  CGRectMake(_selectedConnection.parentNode.center.x, _selectedConnection.parentNode.center.y+20.0,
                                            location.x - _selectedConnection.parentNode.center.x,
                                            location.y - _selectedConnection.parentNode.center.y);
    
    CGPoint start = [self convertPoint:_selectedConnection.parentNode.center toView:_selectedConnection];
    CGPoint end   = [self convertPoint:location toView:_selectedConnection];
    [_selectedConnection drawConnectionFromPoint:start toPoint:end];
    
    for (CanvasNodeView *nodeView in _nodeViews) {
        
        if ((CGRectIntersectsRect(nodeView.frame, canvasMoveConnectionHandle.frame)) && (nodeView != _selectedConnection.parentNode) && (nodeView.isInCollapsedSegment == NO)) {
            if (_connectableNodeView) {
                if (_connectableNodeView != (CanvasNodeView *)nodeView) {
                    [_connectableNodeView setSelected:NO];
                    _connectableNodeView = nil;
                    _connectableNodeView = (CanvasNodeView *)nodeView;
                    [_connectableNodeView setSelected:YES];
                    goto bail2;
                    
                } else
                    goto bail2;
                
            } else {
                _connectableNodeView = (CanvasNodeView *)nodeView;
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
    [self checkAutoScrollingForCanvasItemView:canvasMoveConnectionHandle];
}

- (void)canvasMoveConnectionHandle:(CanvasMoveConnectionHandle *)canvasMoveConnectionHandle touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    
    if (_connectableNodeView) {
        // Move connection to another childview
        NSIndexPath *connectionIndexPath = [_selectedConnection indexPath];
        NSIndexPath *newChildIndexPath = [NSIndexPath indexPathForRow:_connectableNodeView.tag inSection:0];
        
        [_selectedConnection.childNode.connectedNodes removeObject:_selectedConnection.parentNode];
        [_selectedConnection.childNode.parentConnections removeObject:_selectedConnection];
        _selectedConnection.childNode = _connectableNodeView;
        
        [_selectedConnection.childNode.connectedNodes addObject:_selectedConnection.parentNode];
        [_selectedConnection.childNode.parentConnections addObject:_selectedConnection];
        [_selectedConnection drawConnection];
        [_connectableNodeView setSelected:NO];
        _connectableNodeView = nil;
        
        if ([canvasViewDelegate respondsToSelector:@selector(didMoveConnectionAtNode:toNewChildIndexPath:)])
            [canvasViewDelegate didMoveConnectionAtNode:connectionIndexPath toNewChildIndexPath:newChildIndexPath];
        
        canvasMoveConnectionHandle.center = [self convertPoint:_selectedConnection.visibleEndPoint fromView:_selectedConnection];
        [canvasMoveConnectionHandle setHighlighted:NO];
        _selectedConnection = nil;
        _connectableNodeView = nil;
        
    } else {
        // Remove connection completely
        [_selectedConnection suspenderSnapAnimation];
        _selectedConnection = nil;
        _connectableNodeView = nil;
        [canvasMoveConnectionHandle removeFromSuperview];
        [_moveHandles removeObject:canvasMoveConnectionHandle];
    }
    
    
    isMovingCanvasNodeViews = NO;
    [_autoscrollTimer invalidate];
    
    [_viewsTouched removeObject:canvasMoveConnectionHandle];
    [_autoscrollingItems removeObject:canvasMoveConnectionHandle];
    
    _lockedToSingleTouch = NO;
    
    [self sizeCanvasToFit];
}

- (void)canvasMoveConnectionHandle:(CanvasMoveConnectionHandle *)canvasMoveConnectionHandle touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMenu];
    isMovingCanvasNodeViews = NO;
    [_autoscrollTimer invalidate];
    [self sizeCanvasToFit];
    
    canvasMoveConnectionHandle.center = [self convertPoint:_selectedConnection.visibleEndPoint fromView:_selectedConnection];
    [canvasMoveConnectionHandle setHighlighted:NO];
    _selectedConnection = nil;
    _connectableNodeView = nil;
    
    [_viewsTouched removeObject:canvasMoveConnectionHandle];
    [_autoscrollingItems removeObject:canvasMoveConnectionHandle];
    
    _lockedToSingleTouch = NO;
}

@end
