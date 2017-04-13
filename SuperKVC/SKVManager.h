//
//  SKVManager.h
//  SuperKVCDemo
//
//  Created by soulghost on 13/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKVManager : NSObject

/** the cache limit of class reflection and injector configuration */
@property (nonatomic, assign) NSInteger cacheLimit;

+ (instancetype)sharedManager;
- (void)clearCache;

@end
