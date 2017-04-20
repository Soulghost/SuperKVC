//
//  NSObject+SuperKVC.h
//  SuperKVC
//
//  Created by soulghost on 7/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperKVCInjector.h"

@interface NSObject (SuperKVC)

- (id)sk_injectWithInjector:(void(^)(SuperKVCInjector *injector))block;
- (id)sk_dequeInjectorForClass:(Class)clazz emptyHandler:(void(^)(SuperKVCInjector *injector))block;

@end
