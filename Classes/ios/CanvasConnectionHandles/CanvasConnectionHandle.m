//
//  CanvasConnectionHandle.m
//
//  Created by julian krumow on 20.12.12.
//
//  Copyright (c) 2012 Julian Krumow ()
//
//


#import "CanvasConnectionHandle.h"

@implementation CanvasConnectionHandle

#define EXCEPTION_TEXT @"is an abstract class. You must implement a subtype of this class."

- (id)init
{
    [self checkInheritance];
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    [self checkInheritance];
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)checkInheritance
{
    if ([self isMemberOfClass:[CanvasConnectionHandle class]]) {
        NSString *reason = [NSString stringWithFormat:@"%@ %@", EXCEPTION_TEXT, [self class]];
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
    }
}

@end
