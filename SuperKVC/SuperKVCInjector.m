//
//  SuperKVCInjector.m
//  SuperKVC
//
//  Created by soulghost on 7/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "SuperKVCInjector.h"
#import "SuperKVCInjector_Private.h"

@interface SuperKVCInjector ()

/** 记录属性是否已经完成排序 */
@property (nonatomic, assign) BOOL isSorted;

@end

@implementation SuperKVCInjector

- (void(^)(Class clazz))bind {
    return ^(Class clazz) {
        SKVBindAttribute *attr = [[SKVBindAttribute alloc] initWithBindClass:clazz];
        [self.attributes addObject:attr];
    };
}

- (SKVMappingAttribute *(^)(NSString *))mapping {
    return ^SKVMappingAttribute* (NSString *responseKey) {
        SKVMappingAttribute *attr = [SKVMappingAttribute new];
        attr.responseKey = responseKey;
        [self.attributes addObject:attr];
        return attr;
    };
}

- (SKVSynthesizeAttribute *(^)(NSString *))synthesize {
    return ^SKVSynthesizeAttribute* (NSString *propName) {
        SKVSynthesizeAttribute *attr = [SKVSynthesizeAttribute new];
        attr.propName = propName;
        [self.attributes addObject:attr];
        return attr;
    };
}

- (SKVFormatAttribute *(^)(NSString *))format {
    return ^SKVFormatAttribute* (NSString *modelKey) {
        SKVFormatAttribute *attr = [SKVFormatAttribute new];
        attr.modelKey = modelKey;
        [self.attributes addObject:attr];
        return attr;
    };
}

- (SKVIgnoreAttribute *(^)(NSString *))ignore {
    return ^SKVIgnoreAttribute* (NSString *modelKey) {
        SKVIgnoreAttribute *attr = [SKVIgnoreAttribute new];
        [attr.ignoreList addObject:modelKey];
        [self.attributes addObject:attr];
        return attr;
    };
}

- (NSArray *)sortedAttributes {
    if (!self.isSorted) {
        NSAssert(self.attributes.count != 0, @"injector must have at least one bind config");
        // sorting attributes, bind > mapping > ignore > format
        [self.attributes sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            SKVAttribute *a1 = obj1;
            SKVAttribute *a2 = obj2;
            if (a1.priority < a2.priority) {
                return NSOrderedAscending;
            } else if (a1.priority == a2.priority) {
                return NSOrderedSame;
            } else {
                return NSOrderedDescending;
            }
        }];
        self.isSorted = YES;
    }
    return _attributes;
}

#pragma mark - Getter & Setter
- (NSMutableArray *)attributes {
    if (_attributes == nil) {
        _attributes = @[].mutableCopy;
    }
    return _attributes;
}

- (NSMutableDictionary *)mappingDict {
    if (_mappingDict == nil) {
        _mappingDict = @{}.mutableCopy;
    }
    return _mappingDict;
}

- (NSMutableDictionary *)synthesizeDict {
    if (_synthesizeDict == nil) {
        _synthesizeDict = @{}.mutableCopy;
    }
    return _synthesizeDict;
}

- (NSMutableSet *)ignoreSet {
    if (_ignoreSet == nil) {
        _ignoreSet = [NSMutableSet set];
    }
    return _ignoreSet;
}

- (NSMutableDictionary<NSString *,SKVFormatAttribute *> *)formatDict {
    if (_formatDict == nil) {
        _formatDict = @{}.mutableCopy;
    }
    return _formatDict;
}

@end
