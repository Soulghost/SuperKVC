//
//  SKVSynthesizeAttribute.m
//  SuperKVCDemo
//
//  Created by soulghost on 13/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "SKVSynthesizeAttribute.h"

@implementation SKVSynthesizeAttribute

- (NSInteger)priority {
    return kSKVSynthesizeAttributePriority;
}

- (void (^)(NSString *))to {
    return ^ (NSString *ivarName) {
        self.ivarName = ivarName;
    };
}

@end
