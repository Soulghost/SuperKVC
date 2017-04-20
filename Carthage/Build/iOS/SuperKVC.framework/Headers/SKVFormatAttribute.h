//
//  SKVFormatAttribute.h
//  SuperKVC
//
//  Created by soulghost on 7/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "SKVAttribute.h"

typedef id (^SKVFormatAttributeConverter)(id originValue);

@interface SKVFormatAttribute : SKVAttribute

@property (nonatomic, strong) NSString *modelKey;
@property (nonatomic, copy, readonly) SKVFormatAttributeConverter converterBlock;

- (instancetype)with;
- (void(^)(SKVFormatAttributeConverter converter))converter;

@end
