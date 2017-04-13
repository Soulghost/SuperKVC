//
//  SKVManager.m
//  SuperKVCDemo
//
//  Created by soulghost on 13/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "SKVManager.h"
#import "SKVManager_Private.h"

@implementation SKVProperty

- (instancetype)initWithPropName:(NSString *)propName {
    if (self = [super init]) {
        _propName = propName;
    }
    return self;
}

@end

@implementation SKVManager

+ (instancetype)sharedManager {
    static SKVManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _cacheLimit = 10;
    }
    return self;
}

#pragma mark - Action
- (void)clearCache {
    [self.injectorCache removeAllObjects];
    [self.propsCache removeAllObjects];
}

#pragma mark - LazyLoad
- (NSCache<NSString *,NSArray<SKVProperty *> *> *)propsCache {
    if (_propsCache == nil) {
        _propsCache = [[NSCache alloc] init];
        _propsCache.countLimit = _cacheLimit;
    }
    return _propsCache;
}

- (NSCache *)injectorCache {
    if (_injectorCache == nil) {
        _injectorCache = [[NSCache alloc] init];
        _injectorCache.countLimit = _cacheLimit;
    }
    return _injectorCache;
}

#pragma mark - Cache
- (void)cachePropsForClass:(Class)clazz props:(NSArray<SKVProperty *> *)props {
    [self.propsCache setObject:props forKey:NSStringFromClass(clazz)];
}

- (NSArray<SKVProperty *> *)propsFromCacheForClass:(Class)clazz {
    return (NSArray *)[self.propsCache objectForKey:NSStringFromClass(clazz)];
}

- (void)cacheInjectorForClass:(Class)clazz injector:(SuperKVCInjector *)injector {
    [self.injectorCache setObject:injector forKey:NSStringFromClass(clazz)];
}

- (SuperKVCInjector *)injectorFromCacheForClass:(Class)clazz {
    return (SuperKVCInjector *)[self.injectorCache objectForKey:NSStringFromClass(clazz)];
}

#pragma mark -

@end
