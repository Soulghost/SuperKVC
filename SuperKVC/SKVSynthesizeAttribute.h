//
//  SKVSynthesizeAttribute.h
//  SuperKVCDemo
//
//  Created by soulghost on 13/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "SKVAttribute.h"

@interface SKVSynthesizeAttribute : SKVAttribute

@property (nonatomic, strong) NSString *propName;
@property (nonatomic, strong) NSString *ivarName;

- (void(^) (NSString *ivarName))to;

@end
