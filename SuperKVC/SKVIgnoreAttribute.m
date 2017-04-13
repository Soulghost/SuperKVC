//
//  SKVIgnoreAttribute.m
//  SuperKVC
//
//  Created by soulghost on 7/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "SKVIgnoreAttribute.h"

@implementation SKVIgnoreAttribute

- (SKVIgnoreAttribute *(^)(NSString *))and {
    return ^SKVIgnoreAttribute* (NSString *modelKey) {
        [self.ignoreList addObject:modelKey];
        return self;
    };
}

#pragma mark - Getter & Setter
- (NSMutableSet *)ignoreList {
    if (_ignoreList == nil) {
        _ignoreList = @[].mutableCopy;
    }
    return _ignoreList;
}

- (NSInteger)priority {
    return kSKVIgnoreAttributePriority;
}

@end
