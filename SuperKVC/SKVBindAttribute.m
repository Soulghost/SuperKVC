//
//  SKVBindAttribute.m
//  SuperKVC
//
//  Created by soulghost on 7/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "SKVBindAttribute.h"

@implementation SKVBindAttribute

- (instancetype)initWithBindClass:(Class)bindClass {
    if (self = [super init]) {
        _bindClass = bindClass;
    }
    return self;
}

- (NSInteger)priority {
    return kSKVBindAttributePriority;
}

@end
