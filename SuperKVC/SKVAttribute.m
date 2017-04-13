//
//  SKVAttribute.m
//  SuperKVC
//
//  Created by soulghost on 7/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "SKVAttribute.h"

@implementation SKVAttribute

- (SKVAttribute *)with {
    return self;
}

- (NSInteger)priority {
    return kSKVAttributePriority;
}

@end
