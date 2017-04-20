//
//  SKVIgnoreAttribute.h
//  SuperKVC
//
//  Created by soulghost on 7/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "SKVAttribute.h"

@interface SKVIgnoreAttribute : SKVAttribute

@property (nonatomic, strong) NSMutableSet *ignoreList;

- (SKVIgnoreAttribute* (^)(NSString *modelKey))and;

@end
