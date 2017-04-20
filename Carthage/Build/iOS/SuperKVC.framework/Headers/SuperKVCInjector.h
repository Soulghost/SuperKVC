//
//  SuperKVCInjector.h
//  SuperKVC
//
//  Created by soulghost on 7/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKVBindAttribute.h"
#import "SKVMappingAttribute.h"
#import "SKVSynthesizeAttribute.h"
#import "SKVFormatAttribute.h"
#import "SKVIgnoreAttribute.h"

@interface SuperKVCInjector : NSObject

- (void(^)(Class clazz))bind;
- (SKVMappingAttribute *(^)(NSString *responseKey))mapping;
- (SKVSynthesizeAttribute *(^)(NSString *propName))synthesize;
- (SKVFormatAttribute *(^)(NSString *modelKey))format;
- (SKVIgnoreAttribute *(^)(NSString *modelKey))ignore;

@end
