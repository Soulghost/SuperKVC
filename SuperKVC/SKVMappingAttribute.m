//
//  SKVMappingAttribute.m
//  SuperKVC
//
//  Created by soulghost on 7/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "SKVMappingAttribute.h"

@implementation SKVMappingAttribute

- (void (^)(NSString *))to {
    return ^ (NSString *to) {
        self.modelKey = to;
    };
}

- (NSInteger)priority {
    return kSKVMappingAttributePriority;
}

@end
