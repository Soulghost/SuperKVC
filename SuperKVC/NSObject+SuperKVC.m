//
//  NSObject+SuperKVC.m
//  SuperKVC
//
//  Created by soulghost on 7/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "NSObject+SuperKVC.h"
#import "SuperKVCInjector_Private.h"
#import "SKVManager.h"
#import "SKVManager_Private.h"
#import <objc/runtime.h>

@implementation NSObject (SuperKVC)

- (id)sk_injectWithInjector:(void (^)(SuperKVCInjector *))block {
    SuperKVCInjector *injector = [SuperKVCInjector new];
    block(injector);
    return [self parseAttributesForInjector:injector];
}

- (id)sk_dequeInjectorForClass:(Class)clazz emptyHandler:(void (^)(SuperKVCInjector *))block {
    SuperKVCInjector *injector = [[SKVManager sharedManager] injectorFromCacheForClass:clazz];
    // find cached injector for class
    if (injector) {
        return [self buildAndInjectWithClass:injector.bindClass forInjector:injector];
    }
    // build injector
    return [self sk_injectWithInjector:block];
}

- (id)parseAttributesForInjector:(SuperKVCInjector *)injector {
    NSArray *attributes = injector.sortedAttributes;
    // try to find bind attribute
    SKVAttribute *maybeBindAttribute = [attributes firstObject];
    NSAssert([maybeBindAttribute isKindOfClass:[SKVBindAttribute class]], @"injector must have a bind config");
    // use bind attribute to create the model to inject
    SKVBindAttribute *bindAttribute = (SKVBindAttribute *)maybeBindAttribute;
    injector.bindClass = bindAttribute.bindClass;
    NSUInteger attrCnt = attributes.count;
    for (NSUInteger i = 1; i < attrCnt; i++) {
        SKVAttribute *attribute = attributes[i];
        if ([attribute isKindOfClass:[SKVMappingAttribute class]]) {
            [self parseMappingAttribute:(SKVMappingAttribute *)attribute forInjector:injector];
        } else if ([attribute isKindOfClass:[SKVSynthesizeAttribute class]]) {
            [self parseSynthesizeAttribute:(SKVSynthesizeAttribute *)attribute forInjector:injector];
        } else if ([attribute isKindOfClass:[SKVIgnoreAttribute class]]) {
            [self parseIgnoreAttribute:(SKVIgnoreAttribute *)attribute forInjector:injector];
        } else if ([attribute isKindOfClass:[SKVFormatAttribute class]]) {
            [self parseFormatAttribute:(SKVFormatAttribute *)attribute forInjector:injector];
        }
    }
    // cache injector
    [[SKVManager sharedManager] cacheInjectorForClass:injector.bindClass injector:injector];
    return [self buildAndInjectWithClass:injector.bindClass forInjector:injector];
}

- (void)parseMappingAttribute:(SKVMappingAttribute *)attr forInjector:(SuperKVCInjector *)injector {
    injector.mappingDict[attr.modelKey] = attr.responseKey;
}

- (void)parseSynthesizeAttribute:(SKVSynthesizeAttribute *)attr forInjector:(SuperKVCInjector *)injector {
    injector.synthesizeDict[attr.propName] = attr.ivarName;
    injector.hasSynthesize = YES;
}

- (void)parseIgnoreAttribute:(SKVIgnoreAttribute *)attr forInjector:(SuperKVCInjector *)injector {
    [injector.ignoreSet addObjectsFromArray:[attr.ignoreList allObjects]];
}

- (void)parseFormatAttribute:(SKVFormatAttribute *)attr forInjector:(SuperKVCInjector *)injector {
    injector.formatDict[attr.modelKey] = attr;
}

- (id)buildAndInjectWithClass:(Class)clazz forInjector:(SuperKVCInjector *)injector {
    id ret = nil;
    if ([self isKindOfClass:[NSArray class]]) {
        ret = @[].mutableCopy;
        NSArray *dicts = (NSArray *)self;
        for (NSDictionary *dict in dicts) {
            id model = [self buildAndInjectModelWithClass:clazz dict:dict forInjector:injector];
            [ret addObject:model];
        }
    } else if ([self isKindOfClass:[NSDictionary class]]) {
        ret = [self buildAndInjectModelWithClass:clazz dict:(NSDictionary *)self forInjector:injector];
    }
    return ret;
}

- (id)buildAndInjectModelWithClass:(Class)clazz dict:(NSDictionary *)dict forInjector:(SuperKVCInjector *)injector {
    BOOL (^handlePropNamed)(id model, NSString *propName) = ^BOOL (id model, NSString *propName) {
        NSString *responseName = propName;
        if (injector.mappingDict[propName] != nil) {
            responseName = injector.mappingDict[propName];
        }
        // get ivar, check synthesize first
        NSString *ivarName = [NSString stringWithFormat:@"_%@",propName];
        if (injector.hasSynthesize && injector.synthesizeDict[propName]) {
            ivarName = injector.synthesizeDict[propName];
        }
        Ivar ivar = class_getInstanceVariable(clazz, ivarName.UTF8String);
        if (ivar == NULL) {
            return NO;
        }
        id value = dict[responseName];
        // check if NSNull
        if ([value isKindOfClass:[NSNull class]]) {
            return YES;
        }
        // idle format
        if (injector.formatDict[propName] != nil) {
            SKVFormatAttribute *formatAttr = injector.formatDict[propName];
            value = formatAttr.converterBlock(value);
        }
        // check if primary type
        if ([value isKindOfClass:[NSValue class]]) {
            [model setValue:value forKey:propName];
        } else {
            object_setIvar(model, ivar, value);
        }
        return YES;
    };
    id model = [clazz new];
    // check cache
    SKVManager *mgr = [SKVManager sharedManager];
    NSArray<SKVProperty *> *cachedProps = [mgr propsFromCacheForClass:[model class]];
    if (cachedProps) {
        [cachedProps enumerateObjectsUsingBlock:^(SKVProperty * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *propName = obj.propName;
            handlePropNamed(model, propName);
        }];
        return model;
    }
    // prepare for cache
    NSMutableArray<SKVProperty *> *propsToCache = @[].mutableCopy;
    unsigned int count = 0;
    objc_property_t *props = class_copyPropertyList(clazz, &count);
    for (NSUInteger i = 0; i < count; i++) {
        objc_property_t prop = props[i];
        NSString *propName = [[NSString alloc] initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        // check if ignore
        if ([injector.ignoreSet containsObject:propName]) {
            continue;
        }
        if (handlePropNamed(model, propName)) {
            [propsToCache addObject:[[SKVProperty alloc] initWithPropName:propName]];
        }
    }
    [mgr cachePropsForClass:[model class] props:propsToCache];
    free(props);
    return model;
}

@end
