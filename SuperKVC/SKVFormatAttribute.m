//
//  SKVFormatAttribute.m
//  SuperKVC
//
//  Created by soulghost on 7/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "SKVFormatAttribute.h"

@interface SKVFormatAttribute ()

@end

@implementation SKVFormatAttribute

- (instancetype)with {
    return self;
}

- (void (^)(SKVFormatAttributeConverter))converter {
    return ^(SKVFormatAttributeConverter converterBlock) {
        _converterBlock = converterBlock;
    };
}

- (NSInteger)priority {
    return kSKVFormatAttributePriority;
}

@end
