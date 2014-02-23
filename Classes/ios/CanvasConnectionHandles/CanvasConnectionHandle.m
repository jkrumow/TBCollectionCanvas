//
//  CanvasConnectionHandle.m
//
//  Created by julian krumow on 20.12.12.
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
