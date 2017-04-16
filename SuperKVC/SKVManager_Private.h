//
//  SKVManager_Private.h
//  SuperKVCDemo
//
//  Created by soulghost on 13/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "SKVManager.h"

@class SuperKVCInjector;

@interface SKVProperty : NSObject

@property (nonatomic, copy) NSString *propName;
@property (nonatomic, assign) BOOL isPrimary;

- (instancetype)initWithPropName:(NSString *)propName isPrimary:(BOOL)isPrimary;

@end

@interface SKVManager ()

@property (nonatomic, strong) NSCache<NSString *, NSArray<SKVProperty *> *> *propsCache;
@property (nonatomic, strong) NSCache<NSString *, SuperKVCInjector *> *injectorCache;

- (void)cachePropsForClass:(Class)clazz props:(NSArray<SKVProperty *> *)props;
- (NSArray<SKVProperty *> *)propsFromCacheForClass:(Class)clazz;
- (void)cacheInjectorForClass:(Class)clazz injector:(SuperKVCInjector *)injector;
- (SuperKVCInjector *)injectorFromCacheForClass:(Class)clazz;

@end

