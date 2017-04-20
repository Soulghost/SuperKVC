//
//  SKVMappingAttribute.h
//  SuperKVC
//
//  Created by soulghost on 7/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "SKVAttribute.h"

@interface SKVMappingAttribute : SKVAttribute

@property (nonatomic, strong) NSString *responseKey;
@property (nonatomic, strong) NSString *modelKey;

- (void(^)(NSString *modelKey))to;

@end
