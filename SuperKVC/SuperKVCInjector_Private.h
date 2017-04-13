//
//  SuperKVCInjector_Private.h
//  SuperKVC
//
//  Created by soulghost on 11/4/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "SuperKVCInjector.h"

@interface SuperKVCInjector ()

@property (nonatomic, assign) Class bindClass;
@property (nonatomic, strong) NSMutableDictionary *mappingDict;
@property (nonatomic, strong) NSMutableDictionary *synthesizeDict;
@property (nonatomic, strong) NSMutableSet *ignoreSet;
@property (nonatomic, strong) NSMutableDictionary<NSString *, SKVFormatAttribute *> *formatDict;
@property (nonatomic, strong) NSMutableArray *attributes;
@property (nonatomic, assign) BOOL hasSynthesize;

- (NSArray *)sortedAttributes;

@end
