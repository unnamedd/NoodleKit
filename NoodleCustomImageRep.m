//
//  NoodleCustomImageRep.m
//  ImageCacheTest
//
//  Created by Paul Kim on 3/16/11.
//  Copyright 2011 Noodlesoft, LLC. All rights reserved.
//

#import "NoodleCustomImageRep.h"


@implementation NoodleCustomImageRep

@synthesize drawBlock = _drawBlock;

+ (id)imageRepWithDrawBlock:(void (^)(NoodleCustomImageRep *))block
{
    return [[[self class] alloc] initWithDrawBlock:block];
}

- (id)initWithDrawBlock:(void (^)(NoodleCustomImageRep *))block
{
    if ((self = [super init]) != nil)
    {
        [self setDrawBlock:block];
    }
    return self;
}

#pragma mark NSCopying method

- (id)copyWithZone:(NSZone *)zone
{
	NoodleCustomImageRep	*copy;

	copy = [super copyWithZone:zone];
    
    // NSImageRep uses NSCopyObject so we have to force a copy here 
    copy->_drawBlock = [_drawBlock copy];
	
	return copy;
}


#pragma mark NSImageRep methods

- (BOOL)draw
{
    if (_drawBlock != NULL)
    {
        _drawBlock(self);
        
        return YES;
    }
    return NO;
}

@end
